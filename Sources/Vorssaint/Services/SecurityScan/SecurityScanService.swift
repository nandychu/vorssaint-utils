// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Vorssaint

import Combine
import Darwin
import Foundation
import Security

/// An on-demand, read-only snapshot. Results stay in memory and no privileged
/// helper, permission prompt, timer, or network reputation service is used.
final class SecurityScanService: ObservableObject {
    static let shared = SecurityScanService()
    typealias Scanner = (BoundedProcessCancellation, @escaping (Int, Int) -> Void) -> SecurityScanReport

    @Published private(set) var report: SecurityScanReport?
    @Published private(set) var isScanning = false
    @Published private(set) var completed = 0
    @Published private(set) var total = 0
    private var cancellation: BoundedProcessCancellation?
    private var generation = 0
    private let available: () -> Bool
    private let scanner: Scanner
    private let queue = DispatchQueue(label: "Vorssaint.SecurityScan", qos: .utility)

    init(available: @escaping () -> Bool = { AppFeature.securityScan.isAvailable },
         scanner: @escaping Scanner = SecurityScanService.snapshot) {
        self.available = available
        self.scanner = scanner
    }

    func scan() {
        guard available(), !isScanning else { return }
        generation += 1
        let request = generation
        let token = BoundedProcessCancellation()
        cancellation = token
        report = nil
        completed = 0; total = 0; isScanning = true
        queue.async { [weak self] in
            guard let self, !token.isCancelled else { return }
            let report = self.scanner(token) { [weak self] done, count in
                DispatchQueue.main.async { [weak self] in
                    guard let self, self.generation == request, !token.isCancelled else { return }
                    self.completed = done; self.total = count
                }
            }
            DispatchQueue.main.async { [weak self] in
                guard let self, self.generation == request, !token.isCancelled else { return }
                self.isScanning = false
                self.cancellation = nil
                if self.available() { self.report = report }
            }
        }
    }

    func cancel() {
        generation += 1
        cancellation?.cancel()
        cancellation = nil
        isScanning = false
    }

    func syncWithPreferences() {
        guard !available() else { return }
        cancel()
        report = nil
    }

    static func snapshot(_ cancellation: BoundedProcessCancellation,
                         progress: @escaping (Int, Int) -> Void) -> SecurityScanReport {
        let began = Date()
        let (pids, enumerationIncomplete) = processIDs()
        var identities = Dictionary(uniqueKeysWithValues: pids.map { ($0, identity(for: $0)) })
        let limit = 2 * 1024 * 1024
        let ports = BoundedProcessRunner.run("/usr/sbin/lsof",
            ["-nP", "+c0", "-iTCP", "-sTCP:LISTEN", "-F", "pcnPT"],
            timeout: 10, maxOutputBytes: limit, cancellation: cancellation)
        let output = String(decoding: ports.output, as: UTF8.self)
        let listeners = PortManagerSupport.parseLsof(output).filter {
            $0.protocolName == "TCP" && (1...65535).contains($0.port)
        }
        let grouped = Dictionary(grouping: listeners, by: \.pid)
        // Preserve listeners whose owner appeared during the scan without
        // attributing signature/path findings to an unverified process identity.
        for listener in listeners where identities[listener.pid] == nil {
            identities[listener.pid] = SecurityProcessIdentity(pid: listener.pid, startedAt: nil,
                name: listener.processName, path: nil)
        }
        var entries: [SecurityProcessEntry] = []
        let ordered = identities.values.sorted { $0.pid < $1.pid }
        for (index, process) in ordered.enumerated() {
            if cancellation.isCancelled { break }
            let stableBefore = process.matches(identity(for: process.pid))
            // Bound the amount of work in a manual scan. A single OS signing
            // call cannot be interrupted; remaining checks become unavailable.
            let canCheck = stableBefore && Date().timeIntervalSince(began) < 30
            let signature = canCheck ? signature(for: process.pid) : .unavailable
            let stable = stableBefore && process.matches(identity(for: process.pid))
            entries.append(SecurityProcessEntry(process: process,
                signature: stable ? signature : .unavailable,
                listeners: grouped[process.pid] ?? [], identityVerified: stable))
            if index % 25 == 0 || index == ordered.count - 1 { progress(index + 1, ordered.count) }
        }
        entries.sort {
            if $0.findings.count != $1.findings.count { return $0.findings.count > $1.findings.count }
            if $0.listeners.isEmpty != $1.listeners.isEmpty { return !$0.listeners.isEmpty }
            return $0.process.name.localizedStandardCompare($1.process.name) == .orderedAscending
        }
        return SecurityScanReport(startedAt: began, completedAt: Date(), entries: entries,
            processReadIncomplete: enumerationIncomplete,
            listenerReadIncomplete: SecurityScanSupport.listenerReadIncomplete(
                status: ports.status, output: output, timedOut: ports.timedOut,
                byteCount: ports.output.count, limit: limit))
    }

    private static func processIDs() -> ([pid_t], Bool) {
        let estimated = proc_listallpids(nil, 0)
        guard estimated > 0 else { return ([], true) }
        var capacity = Int(estimated) + 256
        for _ in 0..<3 {
            var pids = [pid_t](repeating: 0, count: capacity)
            let count = pids.withUnsafeMutableBytes { proc_listallpids($0.baseAddress, Int32($0.count)) }
            guard count > 0 else { return ([], true) }
            if count < capacity {
                return (Array(Set(pids.prefix(Int(count)).filter { $0 > 0 })), false)
            }
            capacity *= 2
        }
        return ([], true)
    }

    private static func identity(for pid: pid_t) -> SecurityProcessIdentity {
        let startedAt = startTime(for: pid)
        var pathBuffer = [CChar](repeating: 0, count: Int(MAXPATHLEN) * 4)
        let pathCount = proc_pidpath(pid, &pathBuffer, UInt32(pathBuffer.count))
        let path = pathCount > 0 ? String(cString: pathBuffer) : nil
        var nameBuffer = [CChar](repeating: 0, count: 1024)
        let nameCount = proc_name(pid, &nameBuffer, UInt32(nameBuffer.count))
        let name = path.map { ($0 as NSString).lastPathComponent }
            ?? (nameCount > 0 ? String(cString: nameBuffer) : "PID \(pid)")
        return SecurityProcessIdentity(pid: pid, startedAt: startedAt, name: name, path: path)
    }

    private static func startTime(for pid: pid_t) -> UInt64? {
        var info = proc_bsdinfo()
        let size = MemoryLayout<proc_bsdinfo>.size
        guard proc_pidinfo(pid, PROC_PIDTBSDINFO, 0, &info, Int32(size)) == size else { return nil }
        return info.pbi_start_tvsec * 1_000_000 + info.pbi_start_tvusec
    }

    private static func signature(for pid: pid_t) -> SecuritySignature {
        var code: SecCode?
        let lookup = SecCodeCopyGuestWithAttributes(nil,
            [kSecGuestAttributePid as String: NSNumber(value: pid)] as CFDictionary, [], &code)
        guard lookup == errSecSuccess, let code else {
            return SecuritySignature(state: .unavailable, status: lookup)
        }
        // Dynamic validation checks the running code's identity and host state,
        // not all bundle resources, notarization, or online certificate revocation.
        let status = SecCodeCheckValidity(code, .noNetworkAccess, nil)
        guard status == errSecSuccess else { return .checked(status: status) }
        var staticCode: SecStaticCode?
        let copied = SecCodeCopyStaticCode(code, [], &staticCode)
        guard copied == errSecSuccess, let staticCode else { return .unavailable }
        var information: CFDictionary?
        let read = SecCodeCopySigningInformation(staticCode,
            SecCSFlags(rawValue: kSecCSSigningInformation), &information)
        guard read == errSecSuccess, let info = information as? [String: Any],
              let flags = info[kSecCodeInfoFlags as String] as? NSNumber else { return .unavailable }
        return .checked(status: status, flags: flags.uint32Value)
    }
}
