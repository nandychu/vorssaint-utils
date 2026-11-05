// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Vorssaint

import Combine
import CryptoKit
import Foundation

@MainActor
final class CPUStressService: ObservableObject {
    enum State: Equatable {
        case idle, running, stopping, completed, stopped, thermalLimit
    }

    static let shared = CPUStressService()
    static let maximumWorkers = max(1, ProcessInfo.processInfo.activeProcessorCount)

    @Published private(set) var state: State = .idle
    @Published private(set) var elapsed: TimeInterval = 0
    @Published private(set) var cpuUsage: Double?
    @Published private(set) var peakCPUUsage: Double?

    private(set) var duration = 30
    private let available: () -> Bool
    private let thermalState: () -> ProcessInfo.ThermalState
    private let sampler = CPUCoreSampler()
    private var monitorTask: Task<Void, Never>?
    private var run: Workload?
    private var stopReason: State?

    var isActive: Bool { state == .running || state == .stopping }

    init(available: @escaping () -> Bool = { AppFeature.cpuStress.isAvailable },
         thermalState: @escaping () -> ProcessInfo.ThermalState = { ProcessInfo.processInfo.thermalState }) {
        self.available = available
        self.thermalState = thermalState
    }

    deinit {
        monitorTask?.cancel()
        run?.cancel()
    }

    func start(duration: Int, workers: Int) {
        guard available(), !isActive else { return }
        self.duration = min(max(duration, 1), 300)
        elapsed = 0
        cpuUsage = nil
        peakCPUUsage = nil
        guard !isTooHot else { state = .thermalLimit; return }

        sampler.reset()
        let started = ProcessInfo.processInfo.systemUptime
        _ = sampler.sample(now: started)
        let work = Workload(started: started, duration: self.duration)
        run = work
        stopReason = nil
        state = .running

        let group = DispatchGroup()
        for _ in 0..<min(max(workers, 1), Self.maximumWorkers) {
            DispatchQueue.global(qos: .userInitiated).async(group: group) { work.perform() }
        }
        group.notify(queue: .main) { [weak self] in self?.finish(work) }
        monitorTask = Task { [weak self] in
            while !Task.isCancelled {
                do { try await Task.sleep(for: .milliseconds(250)) } catch { break }
                guard let self, self.state == .running else { break }
                self.refresh(work)
            }
        }
    }

    func stop() {
        requestStop(.stopped)
    }

    private var isTooHot: Bool {
        let thermal = thermalState()
        return thermal == .serious || thermal == .critical
    }

    private func refresh(_ work: Workload) {
        if !available() { stop(); return }
        if isTooHot { requestStop(.thermalLimit); return }
        updateProgress(work)
    }

    private func updateProgress(_ work: Workload) {
        let now = ProcessInfo.processInfo.systemUptime
        let updated = min(Double(duration), now - work.started)
        if Int(updated) > Int(elapsed) {
            let readings = sampler.sample(now: now).compactMap { $0 }
            let usage = readings.isEmpty ? nil : readings.reduce(0, +) / Double(readings.count)
            cpuUsage = usage
            if let usage { peakCPUUsage = max(peakCPUUsage ?? 0, usage) }
        }
        elapsed = updated
    }

    private func requestStop(_ reason: State) {
        guard state == .running, let run else { return }
        run.cancel()
        stopReason = reason
        updateProgress(run)
        state = .stopping
    }

    private func finish(_ work: Workload) {
        guard run === work else { return }
        monitorTask?.cancel()
        monitorTask = nil
        if stopReason == nil { updateProgress(work) }
        run = nil
        state = stopReason ?? .completed
    }

    private final class Workload: @unchecked Sendable {
        let started: TimeInterval
        private let deadline: TimeInterval
        private let lock = NSLock()
        private var cancelled = false

        init(started: TimeInterval, duration: Int) {
            self.started = started
            deadline = started + Double(duration)
        }

        func cancel() {
            lock.withLock { cancelled = true }
        }

        func perform() {
            let block = Data(repeating: 0xA5, count: 64 * 1024)
            // Every worker enforces the deadline, even if the UI cannot tick.
            while ProcessInfo.processInfo.systemUptime < deadline && !lock.withLock({ cancelled }) {
                for _ in 0..<8 { _ = SHA256.hash(data: block) }
            }
        }
    }
}
