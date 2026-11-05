// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Vorssaint

import Foundation
import Security

enum SecurityScanTests {
    static func run(_ suite: TestSuite) {
        for endpoint in ["127.0.0.1:80", "127.23.4.5:8080", "[::1]:3000",
                         "[0:0:0:0:0:0:0:1]:80", "[::ffff:127.0.0.1]:8080"] {
            suite.expect(SecurityScanSupport.scope(of: endpoint) == .local,
                         "loopback listener stays local: \(endpoint)")
        }
        for endpoint in ["*:80", "0.0.0.0:80", "[::]:80", "192.168.1.10:1234",
                         "[fe80::1%en0]:80", "[::ffff:192.168.1.2]:80"] {
            suite.expect(SecurityScanSupport.scope(of: endpoint) == .network,
                         "non-loopback listener binds a network interface: \(endpoint)")
        }
        for endpoint in ["", "localhost:80", "127.0.0.1:no", "127.0.0.1:0", "*:65536"] {
            suite.expect(SecurityScanSupport.scope(of: endpoint) == .unknown,
                         "malformed or unresolved scope is not guessed: \(endpoint)")
        }
        let network = ["*:3000"]
        suite.expect(SecurityScanSupport.findings(path: "/usr/bin/tool", signature: .valid,
            endpoints: network).isEmpty, "a network listener alone is not a security finding")
        suite.expect(SecurityScanSupport.findings(path: "/opt/homebrew/bin/node", signature: .adHoc,
            endpoints: ["127.0.0.1:3000"]).isEmpty, "local development servers do not trigger a network finding")
        suite.expect(SecurityScanSupport.findings(path: "/tmp/server", signature: .adHoc,
            endpoints: network) == [.unsignedNetworkListener, .temporaryNetworkListener],
            "combined signals explain both network exposure and the temporary executable")
        suite.expect(SecurityScanSupport.findings(path: "/usr/bin/tool", signature: .unavailable,
            endpoints: network).isEmpty, "unavailable signature is never treated as unsigned or invalid")
        suite.expect(SecurityScanSupport.findings(path: nil, signature: .invalid,
            endpoints: []) == [.invalidSignature], "invalid identity is reported even without a listener")
        for path in ["/tmp/server", "/private/tmp/test/server", "/var/folders/aa/bbb/T/server",
                     "/private/var/folders/aa/bbb/T/server"] {
            suite.expect(SecurityScanSupport.isTemporaryExecutable(path), "temporary executable: \(path)")
        }
        for path in ["/tmp-safe/server", "/tmp/../Applications/server", "/Applications/server",
                     "/private/var/folders/aa/bbb/C/server", "/Users/person/tmp/server"] {
            suite.expect(!SecurityScanSupport.isTemporaryExecutable(path), "non-temporary executable: \(path)")
        }
        suite.expect(SecuritySignature.checked(status: errSecSuccess).state == .valid,
                     "successful identity validation is recorded")
        suite.expect(SecuritySignature.checked(status: errSecSuccess,
            flags: SecCodeSignatureFlags.adhoc.rawValue).state == .adHoc, "ad hoc is distinct from a signed identity")
        suite.expect(SecuritySignature.checked(status: errSecCSUnsigned).state == .unsigned,
                     "unsigned is distinct from a failed signature")
        suite.expect(SecuritySignature.checked(status: errSecCSSignatureFailed).state == .invalid,
                     "a modified signature is a finding")
        for status in [errSecCSSignatureNotVerifiable, errSecCSNoSuchCode, errSecCSStaticCodeChanged,
                       errSecCSInternalError, errSecCSBadObjectFormat, errSecNotTrusted] {
            suite.expect(SecuritySignature.checked(status: status).state == .unavailable,
                         "permission, trust, update and lookup failures stay incomplete: \(status)")
        }
        func incomplete(_ status: Int32, _ output: String, timeout: Bool = false, bytes: Int = 0) -> Bool {
            SecurityScanSupport.listenerReadIncomplete(status: status, output: output,
                timedOut: timeout, byteCount: bytes, limit: 1024)
        }
        let listener = "p123\ncServer\nf4\nPTCP\nn*:3000\nTST=LISTEN\n"
        suite.expect(!incomplete(0, listener), "lsof machine output is a successful visible snapshot")
        suite.expect(!incomplete(1, ""), "quiet lsof exit 1 means no visible matches")
        suite.expect(incomplete(1, "lsof: permission denied"), "exit 1 with an error is incomplete")
        suite.expect(incomplete(0, listener + "lsof: WARNING: partial\n"), "warnings cannot claim full coverage")
        suite.expect(incomplete(0, "") && incomplete(-1, ""), "empty success and failed launch stay incomplete")
        suite.expect(incomplete(0, listener, timeout: true), "a timeout cannot claim full coverage")
        suite.expect(incomplete(0, listener, bytes: 1024), "output at the cap is conservatively incomplete")

        let process = SecurityProcessIdentity(pid: 123, startedAt: 100, name: "Example", path: "/tmp/server")
        suite.expect(process.matches(startedAt: 100) && !process.matches(startedAt: 101)
            && !process.matches(startedAt: nil), "PID reuse and unavailable identity never match")
        suite.expect(process.matches(process)
            && !process.matches(.init(pid: 123, startedAt: 100, name: "New", path: "/usr/bin/new"))
            && !process.matches(.init(pid: 123, startedAt: 100, name: "Example", path: nil)),
            "exec replacement and unreadable paths cannot inherit the old executable's findings")
        let changed = SecurityProcessEntry(process: process, signature: .checked(status: errSecCSSignatureFailed),
            listeners: [.init(port: 3000, protocolName: "TCP", address: "*:3000", pid: 123,
                              processName: "Example", startedAt: nil)], identityVerified: false)
        suite.expect(changed.findings.isEmpty && changed.isIncomplete,
                     "unverified process correlation never attributes a security finding to a reused PID")

        suite.expect(!AppFeature.securityScan.installedByDefault && AppFeature.securityScan.permissions.isEmpty
            && AppFeature.securityScan.enabledKeys.isEmpty, "security scanning is opt-in, on demand and permission-free")
        suite.expect(AppFeature.securityScan.settingsDestination == FeatureSettingsDestination(.securityScan)
            && FeatureVisibilitySupport.features(for: .securityScan) == [.securityScan], "security page uses its feature gate")
        for language in AppLanguage.allCases {
            let strings = FeatureStrings.securityScan(language)
            suite.expect(Mirror(reflecting: strings).children.allSatisfy { !($0.value as! String).isEmpty },
                         "all security labels are present: \(language)")
            suite.expect(strings.summary.components(separatedBy: "%d").count == 4,
                         "summary preserves three counts: \(language)")
        }
        lifecycle(suite)
    }

    private static func lifecycle(_ suite: TestSuite) {
        let report = SecurityScanReport(startedAt: Date(), completedAt: Date(), entries: [],
                                       processReadIncomplete: false, listenerReadIncomplete: false)
        var available = false
        let started = DispatchSemaphore(value: 0)
        let release = DispatchSemaphore(value: 0)
        let returned = DispatchSemaphore(value: 0)
        let service = SecurityScanService(available: { available }, scanner: { token, progress in
            started.signal()
            _ = release.wait(timeout: .now() + 2)
            progress(1, 1)
            returned.signal()
            return report
        })
        suite.expect(!service.isScanning && service.report == nil, "creating the service does not scan")
        service.scan()
        suite.expect(!service.isScanning, "unavailable feature refuses a manual scan")
        available = true
        service.scan()
        suite.expect(started.wait(timeout: .now() + 2) == .success && service.isScanning,
                     "manual action launches the background scan")
        service.scan()
        service.cancel()
        release.signal()
        _ = returned.wait(timeout: .now() + 2)
        RunLoop.current.run(until: Date().addingTimeInterval(0.05))
        suite.expect(service.report == nil && !service.isScanning && service.completed == 0,
                     "cancelled completion and progress cannot publish stale data")
        suite.expect(started.wait(timeout: .now() + 0.05) == .timedOut,
                     "repeated scan while busy does not launch a second scan")
        service.scan()
        _ = started.wait(timeout: .now() + 2)
        release.signal()
        _ = returned.wait(timeout: .now() + 2)
        let deadline = Date().addingTimeInterval(2)
        while service.isScanning && Date() < deadline {
            RunLoop.current.run(until: Date().addingTimeInterval(0.01))
        }
        suite.expect(service.report != nil && !service.isScanning, "a later manual scan can publish its result")
        available = false
        service.syncWithPreferences()
        suite.expect(service.report == nil, "disabling the feature clears private scan results")
        available = true
        service.scan()
        _ = started.wait(timeout: .now() + 2)
        available = false
        service.syncWithPreferences()
        release.signal()
        _ = returned.wait(timeout: .now() + 2)
        RunLoop.current.run(until: Date().addingTimeInterval(0.05))
        suite.expect(service.report == nil && !service.isScanning, "uninstalling cancels an active scan")
    }
}
