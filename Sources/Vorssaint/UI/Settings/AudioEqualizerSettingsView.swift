// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Vorssaint

import AppKit
import SwiftUI

struct AudioEqualizerSettingsView: View {
    @ObservedObject private var settings = AudioEqualizerSettings.shared
    @ObservedObject private var mixer = AppVolumeMixer.shared
    @ObservedObject private var features = FeatureRuntime.shared
    @ObservedObject private var l10n = L10n.shared
    @State private var selectedDevice = ""
    @State private var presetName = ""

    private var strings: AudioEqualizerFeatureStrings { FeatureStrings.audioEqualizer(l10n.language) }
    private var devices: [MixerOutputDevice] {
        mixer.outputDevices.filter { AudioEqualizerSupport.supportsOutput(uid: $0.uid, isVirtual: $0.priorityTier == .virtual) }
    }
    private var profile: AudioEqualizerProfile { settings.preferences.profile(for: selectedDevice) }
    private var presets: [AudioEqualizerPreset] { AudioEqualizerSupport.builtInPresets + settings.preferences.presets }
    private var selectedPreset: String { presets.contains { $0.id == profile.presetID } ? profile.presetID : "custom" }
    private var mixerAvailable: Bool { features.isAvailable(.mixer) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Label(strings.title, systemImage: "slider.vertical.3").font(.title2.bold())
                Toggle(strings.enabled, isOn: Binding(get: { settings.enabled }, set: settings.setEnabled))
                    .toggleStyle(.switch).disabled(!mixerAvailable || !AppVolumeMixer.isSupported)
                if !mixerAvailable {
                    Text(strings.mixerRequired).foregroundStyle(.secondary)
                }
                Text(strings.scope).font(.caption).foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                if mixer.needsPermission && settings.enabled {
                    Text(strings.permission).font(.callout).foregroundStyle(.orange)
                    Button(strings.settings) { Permissions.shared.openAudioCaptureSettings() }
                }
                if devices.isEmpty {
                    Text(strings.noOutput).foregroundStyle(.secondary)
                } else {
                    editor
                }
            }.padding(22)
        }
        .onAppear { selectAvailableDevice() }
        .onChange(of: mixer.outputDevices) { _, _ in selectAvailableDevice() }
        .onChange(of: mixer.currentOutputDeviceUID) { _, uid in
            if let uid, devices.contains(where: { $0.uid == uid }) { selectedDevice = uid }
            else { selectAvailableDevice() }
        }
    }

    private var editor: some View {
        VStack(alignment: .leading, spacing: 20) {
            Picker(strings.output, selection: $selectedDevice) {
                ForEach(devices) { device in Text(device.name).tag(device.uid) }
            }
            Text(strings.deviceHint).font(.caption).foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            playbackStatus
            HStack {
                Picker(strings.preset, selection: Binding(get: { selectedPreset }, set: selectPreset)) {
                    Text(strings.custom).tag("custom")
                    ForEach(presets) { preset in Text(presetTitle(preset)).tag(preset.id) }
                }
                if settings.preferences.presets.contains(where: { $0.id == profile.presetID }) {
                    Button {
                        let id = profile.presetID
                        settings.edit { $0.deletePreset(id) }
                    } label: { Image(systemName: "trash") }
                    .help(strings.delete).accessibilityLabel(strings.delete)
                }
                Button(strings.reset) { update { $0 = AudioEqualizerProfile() } }
            }
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(strings.preamp).font(.headline)
                    Spacer()
                    if !profile.autoPreamp { Text(decibels(profile.preamp)).monospacedDigit() }
                    Toggle(strings.autoPreamp, isOn: Binding(get: { profile.autoPreamp }, set: { value in
                        update { $0.autoPreamp = value; $0.presetID = "custom" }
                    })).toggleStyle(.checkbox).help(strings.autoPreampHint)
                }
                Slider(value: Binding(get: { profile.preamp }, set: { value in
                    update { $0.preamp = value; $0.presetID = "custom" }
                }), in: -24...12, step: 0.1)
                .disabled(profile.autoPreamp).accessibilityLabel(strings.preamp)
                Text(strings.autoPreampHint).font(.caption).foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            VStack(alignment: .leading, spacing: 12) {
                Text(strings.bands).font(.headline)
                HStack(spacing: 0) {
                    ForEach(0..<10) { band in
                        VStack(spacing: 10) {
                            Text(decibels(profile.bands[band], unit: false)).font(.caption.monospacedDigit())
                            AudioEqualizerBandSlider(value: Binding(get: { profile.bands[band] }, set: { value in
                                update { $0.bands[band] = value; $0.presetID = "custom" }
                            }), label: "\(AudioEqualizerSupport.frequencyLabels[band]) Hz")
                            .frame(width: 28, height: 170)
                            Text(AudioEqualizerSupport.frequencyLabels[band])
                                .font(.caption.monospacedDigit())
                        }.frame(maxWidth: .infinity)
                    }
                }
                HStack {
                    Text("−12 … +12 dB").font(.caption).foregroundStyle(.secondary)
                    Spacer()
                    Text("Hz").font(.caption).foregroundStyle(.secondary)
                }
            }
            .padding(14)
            .background(Color.primary.opacity(0.045), in: RoundedRectangle(cornerRadius: 12))
            HStack {
                TextField(strings.name, text: $presetName).textFieldStyle(.roundedBorder)
                Button(strings.save) {
                    settings.edit { _ = $0.savePreset(name: presetName, for: selectedDevice) }
                    presetName = ""
                }.disabled(presetName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                           || settings.preferences.presets.count >= 128)
            }
        }
    }

    private var playbackStatus: some View {
        let status = FeatureStrings.audioEqualizerPlayback(l10n.language)
        let active = mixer.equalizerActiveApps[selectedDevice] ?? []
        return VStack(alignment: .leading, spacing: 6) {
            Label(!settings.enabled ? status.off : active.isEmpty ? status.waiting
                  : "\(status.processing): \(active.joined(separator: ", "))",
                  systemImage: settings.enabled && !active.isEmpty ? "waveform" : "pause.circle")
                .foregroundStyle(settings.enabled && !active.isEmpty ? Color.green : Color.secondary)
            if settings.enabled && active.isEmpty && selectedDevice != mixer.currentOutputDeviceUID {
                Text(status.differentOutput).font(.caption).foregroundStyle(.orange)
            }
        }.font(.callout).fixedSize(horizontal: false, vertical: true)
    }

    private func update(_ change: (inout AudioEqualizerProfile) -> Void) {
        guard !selectedDevice.isEmpty else { return }
        var next = profile
        change(&next)
        settings.edit { $0.save(next, for: selectedDevice) }
    }

    private func selectPreset(_ id: String) {
        guard let preset = presets.first(where: { $0.id == id }) else { return }
        update { $0 = preset.profile; $0.presetID = id }
    }

    private func selectAvailableDevice() {
        guard !devices.contains(where: { $0.uid == selectedDevice }) else { return }
        selectedDevice = devices.first(where: { $0.uid == mixer.currentOutputDeviceUID })?.uid
            ?? devices.first?.uid ?? ""
    }

    private func presetTitle(_ preset: AudioEqualizerPreset) -> String {
        switch preset.id {
        case "flat": return strings.flat
        case "bass": return strings.bass
        case "voice": return strings.voice
        case "treble": return strings.treble
        default: return preset.name
        }
    }

    private func decibels(_ value: Double, unit: Bool = true) -> String {
        String(format: "%+.1f", value) + (unit ? " dB" : "")
    }
}

/// Rotating SwiftUI's horizontal slider leaves AppKit's mouse tracking on the
/// horizontal axis. A native vertical control keeps drawing, hit testing and
/// keyboard/accessibility input in the same coordinate system.
private struct AudioEqualizerBandSlider: NSViewRepresentable {
    @Binding var value: Double
    let label: String

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeNSView(context: Context) -> NSSlider {
        let slider = NSSlider(frame: NSRect(x: 0, y: 0, width: 28, height: 170))
        slider.sliderType = .linear
        slider.isVertical = true
        slider.minValue = -12
        slider.maxValue = 12
        slider.numberOfTickMarks = 49
        slider.allowsTickMarkValuesOnly = false
        slider.altIncrementValue = 0.1
        slider.isContinuous = true
        slider.target = context.coordinator
        slider.action = #selector(Coordinator.changed(_:))
        return slider
    }

    func sizeThatFits(_ proposal: ProposedViewSize, nsView: NSSlider, context: Context) -> CGSize? {
        CGSize(width: proposal.width ?? 28, height: proposal.height ?? 170)
    }

    func updateNSView(_ slider: NSSlider, context: Context) {
        context.coordinator.parent = self
        if slider.doubleValue != value { slider.doubleValue = value }
        slider.isEnabled = context.environment.isEnabled
        slider.setAccessibilityLabel(label)
        slider.setAccessibilityValueDescription(String(format: "%+.1f dB", value))
    }

    final class Coordinator: NSObject {
        var parent: AudioEqualizerBandSlider
        init(_ parent: AudioEqualizerBandSlider) { self.parent = parent }

        @objc func changed(_ sender: NSSlider) {
            let value = (sender.doubleValue * 10).rounded() / 10
            if parent.value != value { parent.value = value }
        }
    }
}
