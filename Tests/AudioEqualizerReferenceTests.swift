// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Vorssaint

import AVFoundation
import Foundation

/// Offline reference: eqMac 1.9.2's ten-band AVAudioUnitEQ configuration.
/// Its arm64 AdvancedEqualizer initializer passes 10 at 0x1000c2bd4 to
/// 0x1000a6e8c, which sets each parametric band's bandwidth to 1.0 at
/// 0x1000a6f40 (setBandwidth: stub 0x100219ee0). Public 1.3.2 used 0.5.
/// Never opens an audio device or captures a user.
enum AudioEqualizerReferenceTests {
    static func run(_ suite: TestSuite) {
        let profile = AudioEqualizerProfile(bands: [9.860738255, 6.317114094, 5.350671141,
            0, 0, -0.770134228, -1.414429530, 5.028523490, 8.572147651, 10.505033557])
        do {
            for rate in [44100.0, 48000, 96000] {
                let frames = Int(rate / 2)
                // Strong low-frequency bursts under a continuous mid tone
                // reveal envelope pumping that a quiet sine sweep misses.
                let input = (0..<frames).map { frame -> Float in
                    let t = Double(frame) / rate
                    let bass = frame % Int(rate / 8) < Int(rate / 16) ? 0.65 : 0.12
                    return Float(bass * sin(2 * .pi * 32 * t) + 0.12 * sin(2 * .pi * 1000 * t))
                }
                let reference = try native(input, profile: profile, rate: rate)
                let actual = direct(input, profile: profile, rate: rate)
                suite.expect(relativeError(actual, reference) < 0.0001,
                             "rendered EQ matches AVAudioUnitEQ including transients at \(rate) Hz")
                let quiet = direct(input.map { $0 * 0.1 }, profile: profile, rate: rate)
                suite.expect(relativeError(quiet, actual.map { $0 * 0.1 }) < 0.00001,
                             "EQ dynamics remain linear at different input levels (\(rate) Hz)")
                // Also cover the spaces between bands and the high-frequency
                // response where changing the octave width matters most.
                let frequencies = [24.0, 45, 90, 180, 350, 700, 1400, 2800, 5600, 11000, 16000, 20000]
                let broadband = (0..<frames).map { frame -> Float in
                    let t = Double(frame) / rate
                    return Float(frequencies.reduce(0.0) { $0 + 0.01 * sin(2 * .pi * $1 * t) })
                }
                let wideReference = try native(broadband, profile: profile, rate: rate)
                suite.expect(relativeError(direct(broadband, profile: profile, rate: rate), wideReference) < 0.0001,
                             "one-octave response matches installed eqMac across the audible range (\(rate) Hz)")
                var automatic = profile
                automatic.autoPreamp = true
                let headroom = AudioEqualizerDSP.headroom(for: profile.bands, sampleRate: rate)
                var lowered = profile
                lowered.preamp = -headroom
                let clean = direct(input, profile: automatic, rate: rate)
                let cleanReference = try native(input, profile: lowered, rate: rate)
                suite.expect(headroom > 10 && relativeError(clean, cleanReference) < 0.0001,
                             "automatic headroom is a fixed gain matching the native EQ preamp")
                suite.expect(clean.allSatisfy { $0.isFinite && abs($0) < 1 },
                             "automatic preamp leaves headroom for the boosted test program")
                if rate == 48000 {
                    let renderer = MixerRenderContinuityTests.Renderer()
                    renderer.equalizer.update(profile)
                    let stereo = input.flatMap { [$0, $0] }
                    let rendered = renderer.render(stereo, frames: frames, layout: [2])
                    let left = stride(from: 0, to: rendered.count, by: 2).map { rendered[$0] }
                    suite.expect(relativeError(left, reference) < 0.0001,
                                 "the actual mixer callback matches the native EQ without extra limiting")
                    suite.expect(left.map { abs($0) }.max()! > 1,
                                 "manual EQ preserves Float32 headroom rather than compressing boosted bands")
                    renderer.equalizer.update(nil)
                    let dry = renderer.render(Array(repeating: 2, count: 8192), frames: 4096, layout: [2])
                    suite.expect(dry.allSatisfy { abs($0) <= 1 },
                                 "the volume mixer's original limiter is restored when EQ is disabled")
                }
            }
        } catch {
            suite.expect(false, "native EQ reference renders offline: \(error)")
        }
    }

    private static func relativeError(_ actual: [Float], _ reference: [Float]) -> Double {
        guard actual.count == reference.count else { return .infinity }
        var difference = 0.0, energy = 0.0
        for (a, b) in zip(actual, reference) {
            difference += pow(Double(a) - Double(b), 2)
            energy += Double(b) * Double(b)
        }
        return sqrt(difference / max(1e-20, energy))
    }

    private static func direct(_ input: [Float], profile: AudioEqualizerProfile, rate: Double) -> [Float] {
        let format = AVAudioFormat(standardFormatWithSampleRate: rate, channels: 2)!
        let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: UInt32(input.count))!
        buffer.frameLength = buffer.frameCapacity
        for channel in 0..<2 { buffer.floatChannelData![channel].update(from: input, count: input.count) }
        let dsp = AudioEqualizerDSP(sampleRate: rate, channelCapacity: 2, profile: profile)
        dsp.process(UnsafeMutableAudioBufferListPointer(buffer.mutableAudioBufferList))
        return Array(UnsafeBufferPointer(start: buffer.floatChannelData![0], count: input.count))
    }

    private static func native(_ input: [Float], profile: AudioEqualizerProfile, rate: Double) throws -> [Float] {
        let engine = AVAudioEngine(), player = AVAudioPlayerNode(), eq = AVAudioUnitEQ(numberOfBands: 10)
        let format = AVAudioFormat(standardFormatWithSampleRate: rate, channels: 2)!
        eq.globalGain = Float(profile.preamp)
        for (index, band) in eq.bands.enumerated() {
            band.filterType = .parametric
            band.frequency = Float(AudioEqualizerSupport.frequencies[index])
            band.bandwidth = 1.0
            band.gain = Float(profile.bands[index])
            band.bypass = false
        }
        engine.attach(player); engine.attach(eq)
        engine.connect(player, to: eq, format: format)
        engine.connect(eq, to: engine.mainMixerNode, format: format)
        try engine.enableManualRenderingMode(.offline, format: format, maximumFrameCount: 4096)
        let source = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: UInt32(input.count))!
        source.frameLength = source.frameCapacity
        for channel in 0..<2 { source.floatChannelData![channel].update(from: input, count: input.count) }
        player.scheduleBuffer(source)
        try engine.start(); player.play()
        defer { engine.stop() }
        let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: 4096)!
        var samples: [Float] = []
        while samples.count < input.count {
            let count = min(4096, input.count - samples.count)
            let status = try engine.renderOffline(UInt32(count), to: buffer)
            guard status == .success else { throw NSError(domain: "EQReference", code: Int(status.rawValue)) }
            samples.append(contentsOf: UnsafeBufferPointer(start: buffer.floatChannelData![0], count: count))
        }
        return samples
    }
}
