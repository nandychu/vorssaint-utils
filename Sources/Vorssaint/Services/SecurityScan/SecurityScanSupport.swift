// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Vorssaint

import Darwin
import Foundation
import Security

enum SecuritySignatureState: Equatable {
    case valid, adHoc, unsigned, invalid, unavailable
}

struct SecuritySignature: Equatable {
    let state: SecuritySignatureState
    let status: OSStatus?

    static let unavailable = SecuritySignature(state: .unavailable, status: nil)

    static func checked(status: OSStatus, flags: UInt32 = 0) -> Self {
        let state: SecuritySignatureState
        switch status {
        case errSecSuccess:
            state = flags & SecCodeSignatureFlags.adhoc.rawValue != 0 ? .adHoc : .valid
        case errSecCSUnsigned: state = .unsigned
        // Permission, trust, unsupported format, and disappearing-process errors
        // are incomplete checks, not evidence that the executable was modified.
        case errSecCSSignatureFailed, errSecCSInfoPlistFailed,
             errSecCSResourceDirectoryFailed, errSecCSGuestInvalid:
            state = .invalid
        default: state = .unavailable
        }
        return Self(state: state, status: status == errSecSuccess ? nil : status)
    }
}

enum SecurityListenerScope {
    case local, network, unknown
}

enum SecurityFinding: String, Identifiable {
    case invalidSignature, unsignedNetworkListener, temporaryNetworkListener
    var id: String { rawValue }
}

struct SecurityProcessIdentity {
    let pid: Int32
    let startedAt: UInt64?
    let name: String
    let path: String?

    func matches(startedAt current: UInt64?) -> Bool {
        guard let startedAt, let current else { return false }
        return startedAt == current
    }

    func matches(_ current: SecurityProcessIdentity) -> Bool {
        // exec can replace the executable without changing the PID or its
        // start time. Never combine an old path with the new image's signature.
        guard pid == current.pid, let path, path == current.path else { return false }
        return matches(startedAt: current.startedAt)
    }
}

struct SecurityProcessEntry: Identifiable {
    let process: SecurityProcessIdentity
    let signature: SecuritySignature
    let listeners: [PortManagerEntry]
    let identityVerified: Bool
    var id: Int32 { process.pid }
    var findings: [SecurityFinding] {
        guard identityVerified else { return [] }
        return SecurityScanSupport.findings(path: process.path, signature: signature.state,
                                            endpoints: listeners.map(\.address))
    }
    var isIncomplete: Bool {
        !identityVerified || process.path == nil || signature.state == .unavailable
    }
}

struct SecurityScanReport {
    let startedAt: Date
    let completedAt: Date
    let entries: [SecurityProcessEntry]
    let processReadIncomplete: Bool
    let listenerReadIncomplete: Bool
    var listenerCount: Int { entries.reduce(0) { $0 + $1.listeners.count } }
    var reviewCount: Int { entries.filter { !$0.findings.isEmpty }.count }
    var incompleteCount: Int { entries.filter(\.isIncomplete).count }
}

enum SecurityScanSupport {
    static func scope(of endpoint: String) -> SecurityListenerScope {
        guard let separator = endpoint.lastIndex(of: ":"),
              let port = Int(endpoint[endpoint.index(after: separator)...]),
              (1...65535).contains(port) else { return .unknown }
        var host = String(endpoint[..<separator])
        if host.hasPrefix("["), host.hasSuffix("]") { host = String(host.dropFirst().dropLast()) }
        if host == "*" { return .network }
        // inet_pton covers compressed/full IPv6 and avoids hostname guesses.
        host = String(host.split(separator: "%", maxSplits: 1).first ?? "")
        var ipv4 = in_addr()
        if inet_pton(AF_INET, host, &ipv4) == 1 {
            return UInt32(bigEndian: ipv4.s_addr) >> 24 == 127 ? .local : .network
        }
        var ipv6 = in6_addr()
        if inet_pton(AF_INET6, host, &ipv6) == 1 {
            let bytes = withUnsafeBytes(of: &ipv6) { Array($0) }
            if bytes.prefix(15).allSatisfy({ $0 == 0 }), bytes[15] == 1 { return .local }
            // IPv4-mapped loopback is still reachable only on this Mac.
            if bytes.prefix(10).allSatisfy({ $0 == 0 }), bytes[10] == 255,
               bytes[11] == 255, bytes[12] == 127 { return .local }
            return .network
        }
        return .unknown
    }

    static func isTemporaryExecutable(_ path: String) -> Bool {
        let path = (path as NSString).standardizingPath
        if path.hasPrefix("/tmp/") || path.hasPrefix("/private/tmp/") { return true }
        let components = path.split(separator: "/")
        let normalized = components.first == "private" ? Array(components.dropFirst()) : components
        return normalized.count > 5 && normalized[0] == "var" && normalized[1] == "folders"
            && normalized[4] == "T"
    }

    static func findings(path: String?, signature: SecuritySignatureState,
                         endpoints: [String]) -> [SecurityFinding] {
        var result: [SecurityFinding] = []
        if signature == .invalid { result.append(.invalidSignature) }
        if endpoints.contains(where: { scope(of: $0) == .network }) {
            if signature == .unsigned || signature == .adHoc { result.append(.unsignedNetworkListener) }
            if let path, isTemporaryExecutable(path) { result.append(.temporaryNetworkListener) }
        }
        return result
    }

    /// lsof returns 1 for no matches as well as errors. Only a quiet, empty
    /// result can mean no visible listeners; diagnostics must stay incomplete.
    static func listenerReadIncomplete(status: Int32, output: String,
                                       timedOut: Bool, byteCount: Int, limit: Int) -> Bool {
        if timedOut || byteCount >= limit { return true }
        if status == 1 { return !output.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        guard status == 0 else { return true }
        let lines = output.split(separator: "\n")
        guard !lines.isEmpty else { return true }
        return lines.contains { line in
            guard let first = line.first else { return false }
            return !"pcfPnT".contains(first) || line.hasPrefix("lsof:")
        } || PortManagerSupport.parseLsof(output).isEmpty
    }
}
