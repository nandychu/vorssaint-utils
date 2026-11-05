// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Vorssaint

import SwiftUI

struct SecurityScanView: View {
    @ObservedObject private var service = SecurityScanService.shared
    @ObservedObject private var l10n = L10n.shared
    @State private var query = ""
    @State private var filter = 0

    private var strings: SecurityScanFeatureStrings { FeatureStrings.securityScan(l10n.language) }
    private var entries: [SecurityProcessEntry] {
        (service.report?.entries ?? []).filter { entry in
            let matchesFilter = filter == 0 || (filter == 1 && !entry.findings.isEmpty)
                || (filter == 2 && !entry.listeners.isEmpty) || (filter == 3 && entry.isIncomplete)
            let search = query.trimmingCharacters(in: .whitespacesAndNewlines)
            return matchesFilter && (search.isEmpty
                || entry.process.name.localizedCaseInsensitiveContains(search)
                || (entry.process.path?.localizedCaseInsensitiveContains(search) ?? false)
                || String(entry.id).contains(search)
                || entry.listeners.contains { $0.address.localizedCaseInsensitiveContains(search) })
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label(strings.title, systemImage: "shield.lefthalf.filled").font(.title2.bold())
                Spacer()
                if service.isScanning {
                    ProgressView().controlSize(.small)
                    Button(l10n.s.uninstallerCancel) { service.cancel() }
                } else {
                    Button(strings.scan) { service.scan() }.buttonStyle(.borderedProminent)
                }
            }
            Text(strings.scope).font(.caption).foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            if service.isScanning {
                Text("\(strings.scanning) \(service.completed) / \(service.total)")
                    .font(.callout).foregroundStyle(.secondary)
            }
            if let report = service.report {
                HStack(alignment: .firstTextBaseline) {
                    Text(String(format: strings.summary, report.entries.count,
                                report.listenerCount, report.reviewCount)).font(.callout)
                    Spacer()
                    Text(report.completedAt, style: .time).font(.caption).foregroundStyle(.secondary)
                        .help(report.completedAt.formatted(date: .abbreviated, time: .standard))
                }
                if report.processReadIncomplete {
                    Label(strings.failed, systemImage: "exclamationmark.triangle").foregroundStyle(.orange)
                }
                if report.listenerReadIncomplete {
                    Label(strings.listenerReadFailed, systemImage: "exclamationmark.triangle")
                        .font(.caption).foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                if report.incompleteCount > 0 {
                    Label("\(strings.incomplete): \(report.incompleteCount). \(strings.partial)", systemImage: "info.circle")
                        .font(.caption).foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            TextField(strings.filter, text: $query).textFieldStyle(.roundedBorder)
            Picker("", selection: $filter) {
                Text(strings.all).tag(0)
                Text(strings.review).tag(1)
                Text(strings.listeners).tag(2)
                Text(strings.incomplete).tag(3)
            }.pickerStyle(.segmented).labelsHidden()
            Divider()
            if entries.isEmpty {
                Text(service.isScanning ? strings.scanning : (service.report == nil ? strings.ready : strings.empty))
                    .foregroundStyle(.secondary).frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(entries) { entry in
                    row(entry).listRowSeparator(.hidden)
                }.listStyle(.plain)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .onDisappear { service.cancel() }
    }

    private func row(_ entry: SecurityProcessEntry) -> some View {
        DisclosureGroup {
            VStack(alignment: .leading, spacing: 8) {
                Text(entry.process.path ?? strings.unavailable)
                    .font(.caption.monospaced()).textSelection(.enabled)
                    .fixedSize(horizontal: false, vertical: true)
                Text(signatureLabel(entry.signature))
                    .font(.caption).foregroundStyle(.secondary)
                if !entry.identityVerified {
                    Text(strings.identityChanged).font(.caption).foregroundStyle(.secondary)
                }
                ForEach(entry.findings) { finding in
                    Label(reason(finding), systemImage: "exclamationmark.triangle")
                        .font(.caption).foregroundStyle(.orange)
                        .fixedSize(horizontal: false, vertical: true)
                }
                ForEach(entry.listeners) { listener in
                    HStack(alignment: .top) {
                        Text("TCP \(listener.address)").font(.caption.monospaced()).textSelection(.enabled)
                        Spacer()
                        Text(scopeLabel(listener.address)).font(.caption).foregroundStyle(.secondary)
                    }
                }
            }.padding(.vertical, 8)
        } label: {
            HStack(spacing: 9) {
                Image(systemName: entry.findings.isEmpty ? "app.dashed" : "exclamationmark.triangle")
                    .foregroundStyle(entry.findings.isEmpty ? Color.secondary : Color.orange)
                VStack(alignment: .leading, spacing: 3) {
                    Text(entry.process.name).font(.body.weight(.medium)).lineLimit(1)
                    Text("PID \(String(entry.id)) · \(signatureLabel(entry.signature))")
                        .font(.caption).foregroundStyle(.secondary).lineLimit(1)
                }
                Spacer()
                if !entry.listeners.isEmpty {
                    Text("TCP · \(entry.listeners.count)").font(.caption.monospacedDigit())
                }
                if !entry.findings.isEmpty {
                    Text(strings.review).font(.caption).foregroundStyle(.orange)
                }
            }.padding(.vertical, 5)
        }
    }

    private func signatureLabel(_ signature: SecuritySignature) -> String {
        let label: String
        switch signature.state {
        case .valid: label = strings.valid
        case .adHoc: label = strings.adHoc
        case .unsigned: label = strings.unsigned
        case .invalid: label = strings.invalid
        case .unavailable: label = strings.unavailable
        }
        return signature.status.map { "\(label) (\($0))" } ?? label
    }

    private func scopeLabel(_ endpoint: String) -> String {
        switch SecurityScanSupport.scope(of: endpoint) {
        case .local: return strings.local
        case .network: return strings.network
        case .unknown: return strings.unknownScope
        }
    }

    private func reason(_ finding: SecurityFinding) -> String {
        switch finding {
        case .invalidSignature: return strings.invalidReason
        case .unsignedNetworkListener: return strings.unsignedNetworkReason
        case .temporaryNetworkListener: return strings.temporaryReason
        }
    }
}
