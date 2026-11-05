// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Vorssaint

import Foundation

struct AudioEqualizerProfile: Codable, Equatable {
    var preamp: Double = 0
    var bands: [Double] = Array(repeating: 0, count: 10)
    var presetID: String = "flat"
    var autoPreamp: Bool = false

    init(preamp: Double = 0, bands: [Double] = Array(repeating: 0, count: 10),
         presetID: String = "flat", autoPreamp: Bool = false) {
        self.preamp = preamp; self.bands = bands; self.presetID = presetID; self.autoPreamp = autoPreamp
    }

    private enum CodingKeys: String, CodingKey { case preamp, bands, presetID, autoPreamp }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        preamp = try values.decode(Double.self, forKey: .preamp)
        bands = try values.decode([Double].self, forKey: .bands)
        presetID = try values.decode(String.self, forKey: .presetID)
        autoPreamp = try values.decodeIfPresent(Bool.self, forKey: .autoPreamp) ?? false
    }

    var sanitized: Self {
        Self(preamp: Self.clamp(preamp, -24...12),
             bands: (0..<10).map { Self.clamp(bands.indices.contains($0) ? bands[$0] : 0, -12...12) },
             presetID: String(presetID.prefix(128)), autoPreamp: autoPreamp)
    }

    static func clamp(_ value: Double, _ range: ClosedRange<Double>) -> Double {
        value.isFinite ? min(range.upperBound, max(range.lowerBound, value)) : 0
    }
}

struct AudioEqualizerPreset: Codable, Equatable, Identifiable {
    let id: String
    var name: String
    var profile: AudioEqualizerProfile
}

struct AudioEqualizerPreferences: Codable, Equatable {
    var devices: [String: AudioEqualizerProfile] = [:]
    var presets: [AudioEqualizerPreset] = []

    init(rawValue: String = "") {
        guard rawValue.utf8.count <= 512 * 1024,
              let decoded = try? JSONDecoder().decode(Self.self, from: Data(rawValue.utf8)) else { return }
        for (uid, profile) in decoded.devices.sorted(by: { $0.key < $1.key }).prefix(128)
        where !uid.isEmpty && uid.utf8.count <= 1024 {
            devices[uid] = profile.sanitized
        }
        var seen = Set(AudioEqualizerSupport.builtInPresets.map(\.id))
        for preset in decoded.presets.prefix(128) {
            let name = preset.name.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !preset.id.isEmpty, preset.id.count <= 128, !name.isEmpty,
                  seen.insert(preset.id).inserted else { continue }
            presets.append(.init(id: preset.id, name: String(name.prefix(80)), profile: preset.profile.sanitized))
        }
    }

    var rawValue: String {
        guard let data = try? JSONEncoder().encode(self) else { return "" }
        return String(decoding: data, as: UTF8.self)
    }

    func profile(for uid: String) -> AudioEqualizerProfile { devices[uid] ?? AudioEqualizerProfile() }

    mutating func save(_ profile: AudioEqualizerProfile, for uid: String) {
        guard !uid.isEmpty, uid.utf8.count <= 1024, devices[uid] != nil || devices.count < 128 else { return }
        devices[uid] = profile.sanitized
    }

    mutating func savePreset(name: String, for uid: String) -> Bool {
        let name = String(name.trimmingCharacters(in: .whitespacesAndNewlines).prefix(80))
        guard !name.isEmpty, !uid.isEmpty, presets.count < 128 else { return false }
        let id = UUID().uuidString
        var profile = profile(for: uid)
        profile.presetID = id
        presets.append(.init(id: id, name: name, profile: profile))
        save(profile, for: uid)
        return true
    }

    mutating func deletePreset(_ id: String) {
        guard presets.contains(where: { $0.id == id }) else { return }
        presets.removeAll { $0.id == id }
        // Keep the sound of each device; only its link to the deleted name goes.
        for uid in devices.keys where devices[uid]?.presetID == id { devices[uid]?.presetID = "custom" }
    }
}

enum AudioEqualizerSupport {
    static func supportsSource(bundleIdentifier: String?) -> Bool {
        // eqMac renders its already-equalized mix to a physical output.
        // Excluding its loopback alone would still process that mix twice.
        bundleIdentifier?.lowercased() != "com.bitgapp.eqmac"
    }

    static func supportsOutput(uid: String, isVirtual: Bool) -> Bool {
        // eqMac advertises USB transport despite being a software loopback.
        // Tapping it would EQ audio again before eqMac's own processing.
        !isVirtual && !["EQMOutputCapture", "EQMDevice", "EQMAC2.1_DRIVER_ENGINE", "EQMAC2_DRIVER_ENGINE"].contains(uid)
    }
    // Ten-band layout and one-octave width match eqMac 1.9.2 AdvancedEqualizer.
    // Its older public 1.3.2 implementation used narrower half-octave bands.
    // This implementation does not embed eqMac code or assets.
    static let bandwidthOctaves = 1.0
    static let frequencies: [Double] = [32, 64, 125, 250, 500, 1000, 2000, 4000, 8000, 16000]
    static let frequencyLabels = ["32", "64", "125", "250", "500", "1k", "2k", "4k", "8k", "16k"]
    static let builtInPresets: [AudioEqualizerPreset] = [
        .init(id: "flat", name: "", profile: .init()),
        .init(id: "bass", name: "", profile: .init(preamp: -4, bands: [4, 4, 3, 1, 0, 0, 0, 0, 0, 0], presetID: "bass")),
        .init(id: "voice", name: "", profile: .init(preamp: -3, bands: [-3, -2, -1, 0, 1, 3, 3, 1, 0, 0], presetID: "voice")),
        .init(id: "treble", name: "", profile: .init(preamp: -3, bands: [0, 0, 0, 0, 0, 0, 1, 2, 3, 3], presetID: "treble")),
    ]

    static func canProcess(featureAvailable: Bool, mixerAvailable: Bool, enabled: Bool,
                           physicalOutput: Bool, bypassed: Bool, hasAudio: Bool) -> Bool {
        featureAvailable && mixerAvailable && enabled && physicalOutput && !bypassed && hasAudio
    }
}
