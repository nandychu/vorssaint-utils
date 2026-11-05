// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Vorssaint

import AppKit
import SwiftUI

struct CPUStressView: View {
    @ObservedObject private var service = CPUStressService.shared
    @ObservedObject private var l10n = L10n.shared
    @State private var duration = 30
    @State private var workers = max(1, CPUStressService.maximumWorkers / 2)

    private var strings: CPUStressFeatureStrings { FeatureStrings.cpuStress(l10n.language) }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label(strings.title, systemImage: AppFeature.cpuStress.symbolName).font(.title2.bold())
                Spacer()
                if service.isActive {
                    Button(strings.stop) { service.stop() }
                        .disabled(service.state == .stopping)
                } else {
                    Button(strings.start) { service.start(duration: duration, workers: workers) }
                        .buttonStyle(.borderedProminent)
                }
            }
            Text(strings.description).font(.callout).foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            Form {
                Section {
                    Picker(l10n.s.durationLabel, selection: $duration) {
                        ForEach([30, 60, 180, 300], id: \.self) { seconds in
                            Text(Duration.seconds(seconds).formatted(.units(allowed: [.minutes, .seconds],
                                                                            width: .abbreviated))).tag(seconds)
                        }
                    }
                    Stepper(value: $workers, in: 1...CPUStressService.maximumWorkers) {
                        LabeledContent(strings.workers) {
                            Text("\(workers) / \(CPUStressService.maximumWorkers)").monospacedDigit()
                        }
                    }
                }.disabled(service.isActive)

                if service.state != .idle {
                    Section {
                        ProgressView(value: service.elapsed, total: Double(service.duration)) {
                            Text(status).foregroundStyle(service.state == .thermalLimit ? Color.orange : Color.primary)
                        } currentValueLabel: {
                            Text("\(time(Int(service.elapsed))) / \(time(service.duration))").monospacedDigit()
                        }
                        if service.isActive {
                            LabeledContent(l10n.s.cpuLabel, value: percent(service.cpuUsage))
                        }
                        LabeledContent(strings.peak, value: percent(service.peakCPUUsage))
                    }
                }
            }.formStyle(.grouped)
        }
        .padding(18)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .onDisappear { service.stop() }
        .onReceive(SettingsWindowVisibility.shared.$isVisible) { visible in
            if !visible { service.stop() }
        }
        .onReceive(NSWorkspace.shared.notificationCenter.publisher(for: NSWorkspace.willSleepNotification)
            .receive(on: DispatchQueue.main)) { _ in service.stop() }
    }

    private var status: String {
        switch service.state {
        case .idle: return ""
        case .running: return strings.running
        case .stopping: return strings.stopping
        case .completed: return strings.completed
        case .stopped: return strings.stopped
        case .thermalLimit: return strings.thermalLimit
        }
    }

    private func time(_ seconds: Int) -> String {
        Duration.seconds(seconds).formatted(.time(pattern: .minuteSecond))
    }

    private func percent(_ usage: Double?) -> String {
        usage?.formatted(.percent.precision(.fractionLength(0))) ?? "—"
    }
}
