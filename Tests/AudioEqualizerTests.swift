// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Vorssaint

import CoreAudio
import Foundation

enum AudioEqualizerTests {
    static func run(_ suite: TestSuite) {
        preferences(suite)
        signal(suite)
        groupedOutputRoutes(suite)
        reactivation(suite)
        AudioEqualizerReferenceTests.run(suite)
        suite.expect(!AudioEqualizerSupport.supportsSource(bundleIdentifier: "com.bitgapp.eqmac")
            && !AudioEqualizerSupport.supportsSource(bundleIdentifier: "com.bitgapp.eqMac")
            && AudioEqualizerSupport.supportsSource(bundleIdentifier: "com.spotify.client")
            && AudioEqualizerSupport.supportsSource(bundleIdentifier: nil),
            "eqMac's already processed output is excluded from a second equalization pass")
        suite.expect(!AudioEqualizerSupport.supportsOutput(uid: "EQMOutputCapture", isVirtual: false)
            && !AudioEqualizerSupport.supportsOutput(uid: "BlackHole", isVirtual: true)
            && AudioEqualizerSupport.supportsOutput(uid: "BuiltInHeadphoneOutputDevice", isVirtual: false),
            "eqMac's USB-labelled loopback is excluded while physical headphones remain supported")
        suite.expect(!AppFeature.audioEqualizer.installedByDefault
            && AppFeature.audioEqualizer.permissions == [.audioCapture],
            "the optional equalizer declares only system audio capture")
        suite.expect(SettingsBackupSupport.exportKeys().contains(DefaultsKey.audioEqualizerProfiles)
            && SettingsBackupSupport.exportKeys().contains(DefaultsKey.audioEqualizerEnabled),
            "device profiles, user presets and enable preference travel in backups")
        for language in AppLanguage.allCases {
            suite.expect(Mirror(reflecting: FeatureStrings.audioEqualizer(language)).children
                .allSatisfy { !($0.value as! String).isEmpty }, "equalizer copy covers \(language)")
            suite.expect(Mirror(reflecting: FeatureStrings.audioEqualizerPlayback(language)).children
                .allSatisfy { !($0.value as! String).isEmpty }, "equalizer playback state covers \(language)")
        }
        for bits in 0..<64 {
            let flags = (0..<6).map { bits & (1 << $0) != 0 }
            let actual = AudioEqualizerSupport.canProcess(featureAvailable: flags[0], mixerAvailable: flags[1],
                enabled: flags[2], physicalOutput: flags[3], bypassed: flags[4], hasAudio: flags[5])
            suite.expect(actual == (bits == 47), "processing honors availability, bypass and output gates (\(bits))")
        }
        let mixer = MixerUniversalRoutingContract.Mixer()
        let row = MixerUniversalRoutingContract.row(selectedUID: nil)
        suite.expect(!mixer.appNeedsEngine(row), "a unity-volume row is normally untouched")
        mixer.equalizer = AudioEqualizerProfile()
        suite.expect(mixer.appNeedsEngine(row) && mixer.rowMayBeTapped(row),
                     "an explicitly enabled equalizer can process unity-volume audio")
        var bypassed = row
        bypassed.isBypassed = true
        suite.expect(!mixer.appNeedsEngine(bypassed) && !mixer.rowMayBeTapped(bypassed),
                     "equalization never overrides call-app protection")
        mixer.equalizer = nil
        suite.expect(!mixer.appNeedsEngine(row), "disabling EQ releases an otherwise unused tap")
    }

    private static func reactivation(_ suite: TestSuite) {
        let mixer = MixerUniversalRoutingContract.Mixer()
        let row = MixerUniversalRoutingContract.row()
        mixer.apps = [row]
        mixer.equalizer = .init()
        let config = MixerEngineRecovery.Configuration(objects: row.audioObjects, outputDeviceUID: "airpods")
        _ = mixer.engineRecovery.recordFailure(row.id, configuration: config)
        _ = mixer.engineRecovery.recordFailure(row.id, configuration: config)
        mixer.configurationRepairs[row.id] = 100
        let oldBuild = mixer.builds.begin(row.id)!
        mixer.equalizerDidChange()
        suite.expect(!mixer.engineRecovery.allowsBuild(row.id, configuration: config)
            && mixer.builds.isCurrent(row.id, token: oldBuild),
            "moving EQ sliders cannot restart a failed capture loop")
        mixer.equalizer = nil
        mixer.equalizerDidChange(retryFailedEngines: true)
        suite.expect(mixer.engineRecovery.allowsBuild(row.id, configuration: config)
            && mixer.configurationRepairs.isEmpty && !mixer.builds.isCurrent(row.id, token: oldBuild),
            "turning EQ off clears exhausted retries even after the failed engine was removed")
        mixer.equalizer = .init()
        mixer.equalizerDidChange(retryFailedEngines: true)
        suite.expect(mixer.appNeedsEngine(row) && mixer.engineRecovery.allowsBuild(row.id, configuration: config)
            && mixer.reconcileCount == 3 && mixer.refreshCount == 3,
            "reactivation starts a fresh attempt and refreshes the current output routes")
    }

    private static func groupedOutputRoutes(_ suite: TestSuite) {
        typealias Contract = MixerUniversalRoutingContract
        var main = Contract.row("com.spotify.client", objects: [100])
        main.observedOutputDeviceUIDs = ["airpods"]
        var helper = Contract.row("com.spotify.client", objects: [101])
        for routes in [[], ["airpods"], ["speakers"], ["speakers", "airpods"]] {
            helper.observedOutputDeviceUIDs = routes
            for rows in [[main, helper], [helper, main]] {
                let merged = Contract.Mixer.coalescingAppsWithDuplicateIDs(rows)
                suite.expect(merged.count == 1 && merged[0].audioObjects == [100, 101]
                    && Set(merged[0].observedOutputDeviceUIDs) == Set(["airpods"] + routes),
                    "combining an app's processes retains every observed EQ output, including silent helpers")
                suite.expect((Set(merged[0].observedOutputDeviceUIDs) == ["airpods"])
                    == !routes.contains("speakers"),
                    "grouping preserves eligibility for one output without hiding separately routed audio")
            }
        }
    }

    private static func preferences(_ suite: TestSuite) {
        var settings = AudioEqualizerPreferences()
        let bass = AudioEqualizerSupport.builtInPresets.first { $0.id == "bass" }!.profile
        settings.save(bass, for: "headphones-A")
        suite.expect(settings.profile(for: "headphones-A") == bass
            && settings.profile(for: "speakers").bands.allSatisfy { $0 == 0 },
            "each output retains its own profile and new outputs start flat")
        suite.expect(settings.savePreset(name: "  My headphones  ", for: "headphones-A"),
                     "a custom preset saves the device's gain and preamp")
        let saved = settings.presets[0]
        suite.expect(saved.name == "My headphones" && saved.profile.bands == bass.bands
            && saved.profile.preamp == bass.preamp, "named presets preserve all eleven gains")
        let restored = AudioEqualizerPreferences(rawValue: settings.rawValue)
        suite.expect(restored == settings, "profiles and presets survive restart and backup round trips")
        settings.deletePreset(saved.id)
        suite.expect(settings.presets.isEmpty && settings.profile(for: "headphones-A").bands == bass.bands
            && settings.profile(for: "headphones-A").presetID == "custom", "deleting a name preserves the current sound")
        suite.expect(!settings.savePreset(name: " \n ", for: "speakers"), "blank preset names are rejected")
        let invalid = AudioEqualizerProfile(preamp: .infinity, bands: [.nan, 100, -100]).sanitized
        suite.expect(invalid.preamp == 0 && invalid.bands.count == 10
            && invalid.bands.prefix(3).elementsEqual([0, 12, -12]), "invalid imported gains are finite and bounded")
        suite.expect(AudioEqualizerPreferences(rawValue: "invalid").devices.isEmpty,
                     "corrupt settings safely return to flat")
        let legacy = #"{"devices":{"headphones":{"preamp":0,"bands":[1,2,3,0,0,0,0,0,0,0],"presetID":"custom"}},"presets":[]}"#
        suite.expect(AudioEqualizerPreferences(rawValue: legacy).profile(for: "headphones").bands[2] == 3
            && !AudioEqualizerPreferences(rawValue: legacy).profile(for: "headphones").autoPreamp,
            "existing profiles retain their exact gain and manual preamp when automatic headroom is introduced")
        settings.save(.init(preamp: -2, autoPreamp: true), for: "auto")
        suite.expect(AudioEqualizerPreferences(rawValue: settings.rawValue).profile(for: "auto").autoPreamp,
                     "automatic preamp follows device profiles and backup round trips")
    }

    private static func render(_ dsp: AudioEqualizerDSP, _ input: [[Float]], planar: Bool = false) -> [[Float]] {
        let channels = input.count, frames = input[0].count
        let list = AudioBufferList.allocate(maximumBuffers: planar ? channels : 1)
        let data = UnsafeMutablePointer<Float>.allocate(capacity: channels * frames)
        defer { data.deallocate(); free(list.unsafeMutablePointer) }
        if planar {
            for c in 0..<channels {
                (data + c * frames).update(from: input[c], count: frames)
                list[c] = AudioBuffer(mNumberChannels: 1, mDataByteSize: UInt32(frames * 4), mData: data + c * frames)
            }
        } else {
            for f in 0..<frames { for c in 0..<channels { data[f * channels + c] = input[c][f] } }
            list[0] = AudioBuffer(mNumberChannels: UInt32(channels), mDataByteSize: UInt32(frames * channels * 4), mData: data)
        }
        dsp.process(list)
        return (0..<channels).map { c in (0..<frames).map { data[planar ? c * frames + $0 : $0 * channels + c] } }
    }

    private static func signal(_ suite: TestSuite) {
        for rate in [16_000.0, 44_100, 48_000, 96_000] {
            for frequency in AudioEqualizerSupport.frequencies where frequency < rate * 0.49 {
                for gain in [-12.0, 6, 12] {
                    let c = AudioEqualizerDSP.Coefficients.peak(frequency: frequency, gain: gain, sampleRate: rate)
                    let w = 2 * Double.pi * frequency / rate
                    let nr = c.b0 + c.b1 * cos(w) + c.b2 * cos(2 * w)
                    let ni = -c.b1 * sin(w) - c.b2 * sin(2 * w)
                    let dr = 1 + c.a1 * cos(w) + c.a2 * cos(2 * w)
                    let di = -c.a1 * sin(w) - c.a2 * sin(2 * w)
                    let db = 10 * log10((nr * nr + ni * ni) / (dr * dr + di * di))
                    suite.expect(abs(db - gain) < 0.001, "band center gain matches its dB setting (\(frequency), \(rate), \(gain))")
                }
            }
        }
        let frames = 12_000
        let wave = (0..<frames).map { Float(0.1 * sin(2 * Double.pi * 1000 * Double($0) / 48000)) }
        let silence = Array(repeating: Float.zero, count: frames)
        for planar in [false, true] {
            let flat = AudioEqualizerDSP(sampleRate: 48000, channelCapacity: 2, profile: .init())
            suite.expect(render(flat, [wave, silence], planar: planar) == [wave, silence],
                         "flat is transparent without stereo crosstalk (planar: \(planar))")
            let quiet = AudioEqualizerDSP(sampleRate: 48000, channelCapacity: 2,
                profile: .init(preamp: -6))
            let quieter = render(quiet, [wave, silence], planar: planar)
            let error = zip(quieter[0], wave).map { abs(Double($0) - Double($1) * pow(10, -6.0 / 20)) }.max()!
            suite.expect(error < 0.000001 && quieter[1] == silence, "preamp applies dB gain to the correct channels")
            var boosted = AudioEqualizerProfile()
            boosted.bands[5] = 6
            let dsp = AudioEqualizerDSP(sampleRate: 48000, channelCapacity: 2, profile: boosted)
            let actual = render(dsp, [wave, silence], planar: planar)
            func energy(_ samples: ArraySlice<Float>) -> Double { samples.reduce(0) { $0 + Double($1 * $1) } }
            let db = 10 * log10(energy(actual[0].suffix(6000)) / energy(wave.suffix(6000)))
            suite.expect(abs(db - 6) < 0.03 && actual[1] == silence,
                         "the render path produces measured +6 dB at 1 kHz without crosstalk")
            dsp.update(nil)
            suite.expect(render(dsp, [wave, silence], planar: planar) == [wave, silence],
                         "bypass immediately returns dry samples and discards filter history")
        }
        let dsp = AudioEqualizerDSP(sampleRate: 48000, channelCapacity: 2, profile: .init())
        let short = Array(wave.prefix(256))
        for step in 0..<32 {
            dsp.update(.init(preamp: step % 2 == 0 ? -24 : 12,
                bands: Array(repeating: step % 2 == 0 ? -12 : 12, count: 10)))
            suite.expect(render(dsp, [short, short]).flatMap { $0 }.allSatisfy(\.isFinite),
                         "rapid preset changes remain finite (\(step))")
        }
        let nan = render(dsp, [[.nan, .infinity, -.infinity], [0, 0, 0]])
        suite.expect(nan.flatMap { $0 }.allSatisfy(\.isFinite), "invalid input samples do not poison filter state")
        // An explicit EQ preamp must remain linear through the production IO
        // callback, without an extra limiter or its lookahead delay.
        let renderer = MixerRenderContinuityTests.Renderer()
        renderer.equalizer.update(.init(preamp: -6))
        let output = renderer.render(Array(repeating: 0.2, count: 1024), frames: 512, layout: [2])
        suite.expect(output.allSatisfy { abs($0 - 0.2 * Float(pow(10, -6.0 / 20))) < 0.00001 },
            "production IO preserves the EQ's preamp without extra dynamics processing")
    }
}
