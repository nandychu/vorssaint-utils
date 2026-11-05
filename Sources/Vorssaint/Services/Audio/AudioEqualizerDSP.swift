// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Vorssaint

import CoreAudio
import Darwin

/// Ten linear peaking filters, each one octave wide. Coefficients follow
/// the RBJ peaking-EQ equations and match AVAudioUnitEQ's parametric bands:
/// https://www.w3.org/TR/audio-eq-cookbook/
/// Storage is allocated at engine creation. The audio callback takes no lock,
/// allocates nothing, and reads parameters through atomic scalar exchanges.
final class AudioEqualizerDSP {
    struct Coefficients {
        var b0 = 1.0, b1 = 0.0, b2 = 0.0, a1 = 0.0, a2 = 0.0

        static func peak(frequency: Double, gain: Double, sampleRate: Double) -> Self {
            guard sampleRate.isFinite, sampleRate >= 8000, frequency > 0,
                  frequency < sampleRate * 0.49, gain.isFinite, abs(gain) > 0.00001 else { return Self() }
            let gain = AudioEqualizerProfile.clamp(gain, -12...12)
            let amplitude = pow(10, gain / 40)
            let omega = 2 * Double.pi * frequency / sampleRate
            let alpha = sin(omega) * sinh(log(2) / 2 * AudioEqualizerSupport.bandwidthOctaves * omega / sin(omega))
            let a0 = 1 + alpha / amplitude
            return Self(b0: (1 + alpha * amplitude) / a0,
                        b1: -2 * cos(omega) / a0,
                        b2: (1 - alpha * amplitude) / a0,
                        a1: -2 * cos(omega) / a0,
                        a2: (1 - alpha / amplitude) / a0)
        }

        mutating func approach(_ target: Self, amount: Double) {
            b0 += (target.b0 - b0) * amount
            b1 += (target.b1 - b1) * amount
            b2 += (target.b2 - b2) * amount
            a1 += (target.a1 - a1) * amount
            a2 += (target.a2 - a2) * amount
        }
    }

    private struct State {
        var z1 = 0.0, z2 = 0.0
        mutating func sample(_ input: Double, coefficients c: Coefficients) -> Double {
            let output = c.b0 * input + z1
            guard output.isFinite else { z1 = 0; z2 = 0; return 0 }
            z1 = c.b1 * input - c.a1 * output + z2
            z2 = c.b2 * input - c.a2 * output
            if abs(z1) < 1e-24 { z1 = 0 }
            if abs(z2) < 1e-24 { z2 = 0 }
            return output
        }
    }

    private let parameters = UnsafeMutablePointer<Int32>.allocate(capacity: 12)
    private let coefficients = UnsafeMutablePointer<Coefficients>.allocate(capacity: 10)
    private let targets = UnsafeMutablePointer<Coefficients>.allocate(capacity: 10)
    private let states: UnsafeMutablePointer<State>
    private let channelCapacity: Int
    private let sampleRate: Double
    private let smoothing: Double
    private var appliedPreamp = 1.0
    private var wasActive = false
    private var neutralFilters = true

    init(sampleRate: Double, channelCapacity: Int, profile: AudioEqualizerProfile? = nil) {
        self.sampleRate = sampleRate.isFinite && sampleRate >= 8000 ? sampleRate : 48000
        self.channelCapacity = max(1, min(256, channelCapacity))
        smoothing = 1 - exp(-1 / (self.sampleRate * 0.02))
        states = .allocate(capacity: self.channelCapacity * 10)
        states.initialize(repeating: State(), count: self.channelCapacity * 10)
        parameters.initialize(repeating: 0, count: 12)
        coefficients.initialize(repeating: Coefficients(), count: 10)
        targets.initialize(repeating: Coefficients(), count: 10)
        update(profile)
    }

    deinit {
        parameters.deallocate(); coefficients.deallocate(); targets.deallocate(); states.deallocate()
    }

    /// Called off the audio thread. Nil makes the existing mixer path dry.
    func update(_ profile: AudioEqualizerProfile?) {
        let clean = profile?.sanitized ?? AudioEqualizerProfile()
        for index in 0..<10 { store(Float(clean.bands[index]), at: index) }
        let preamp = clean.autoPreamp
            ? min(clean.preamp, -Self.headroom(for: clean.bands, sampleRate: sampleRate)) : clean.preamp
        store(Float(preamp), at: 10)
        store(profile == nil ? 0 : 1, at: 11)
    }

    /// Control thread only. Fixed attenuation preserves dynamics; it does not
    /// ride the music's envelope like a limiter. Sample the combined response,
    /// including interactions between bands, with a small margin for the grid.
    static func headroom(for gains: [Double], sampleRate: Double) -> Double {
        guard gains.contains(where: { $0 > 0 }) else { return 0 }
        let rate = max(8000, sampleRate)
        let filters = zip(AudioEqualizerSupport.frequencies, gains).map {
            Coefficients.peak(frequency: $0.0, gain: $0.1, sampleRate: rate)
        }
        let frequencies = (0...1024).map { 10 * pow(rate * 0.049, Double($0) / 1024) }
            + AudioEqualizerSupport.frequencies.filter { $0 < rate * 0.49 }
        var peak = 0.0
        for frequency in frequencies {
            let w = 2 * Double.pi * frequency / rate
            let c1 = cos(w), c2 = cos(2 * w), s1 = sin(w), s2 = sin(2 * w)
            let db = filters.reduce(0.0) { sum, c in
                let nr = c.b0 + c.b1 * c1 + c.b2 * c2, ni = -c.b1 * s1 - c.b2 * s2
                let dr = 1 + c.a1 * c1 + c.a2 * c2, di = -c.a1 * s1 - c.a2 * s2
                return sum + 10 * log10((nr * nr + ni * ni) / (dr * dr + di * di))
            }
            peak = max(peak, db)
        }
        return peak > 0 ? peak + 0.5 : 0
    }

    private func store(_ value: Float, at index: Int) {
        let replacement = Int32(bitPattern: value.bitPattern)
        while true {
            let current = OSAtomicAdd32Barrier(0, parameters + index)
            if OSAtomicCompareAndSwap32Barrier(current, replacement, parameters + index) { return }
        }
    }

    private func load(_ index: Int) -> Double {
        Double(Float(bitPattern: UInt32(bitPattern: OSAtomicAdd32Barrier(0, parameters + index))))
    }

    /// Audio-thread only, including format suspension and a missing tap.
    func reset() {
        states.update(repeating: State(), count: channelCapacity * 10)
        wasActive = false
        neutralFilters = true
    }

    @discardableResult
    func process(_ output: UnsafeMutableAudioBufferListPointer) -> Bool {
        guard load(11) != 0 else {
            if wasActive { reset() }
            return false
        }
        var channels = 0, frames = Int.max
        for buffer in output {
            channels += Int(buffer.mNumberChannels)
            guard buffer.mNumberChannels > 0, buffer.mData != nil else { continue }
            frames = min(frames, Int(buffer.mDataByteSize) / (4 * Int(buffer.mNumberChannels)))
        }
        guard channels > 0, channels <= channelCapacity, frames > 0, frames < Int.max else { return true }
        var flat = true
        for band in 0..<10 {
            let gain = load(band)
            if abs(gain) > 0.00001 { flat = false }
            targets[band] = .peak(frequency: AudioEqualizerSupport.frequencies[band],
                                  gain: gain, sampleRate: sampleRate)
            if !wasActive { coefficients[band] = targets[band] }
        }
        if !flat { neutralFilters = false }
        let preamp = pow(10, load(10) / 20)
        if !wasActive { appliedPreamp = preamp; wasActive = true }
        // The common first-use profile is flat. Do not spend ten filter
        // passes per channel on what should be a transparent path.
        if neutralFilters && preamp == 1 && appliedPreamp == 1 { return true }
        for frame in 0..<frames {
            appliedPreamp += (preamp - appliedPreamp) * smoothing
            if !neutralFilters {
                for band in 0..<10 { coefficients[band].approach(targets[band], amount: smoothing) }
            }
            var offset = 0
            for buffer in output {
                let count = Int(buffer.mNumberChannels)
                defer { offset += count }
                guard let samples = buffer.mData?.assumingMemoryBound(to: Float.self) else { continue }
                for channel in 0..<count {
                    let index = frame * count + channel
                    var sample = samples[index].isFinite ? Double(samples[index]) * appliedPreamp : 0
                    if !neutralFilters {
                        for band in 0..<10 {
                            sample = states[(offset + channel) * 10 + band].sample(sample, coefficients: coefficients[band])
                        }
                    }
                    samples[index] = sample.isFinite && abs(sample) <= Double(Float.greatestFiniteMagnitude) ? Float(sample) : 0
                }
            }
        }
        return true
    }
}
