// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Vorssaint

import Combine
import Foundation

final class AudioEqualizerSettings: ObservableObject {
    static let shared = AudioEqualizerSettings()
    @Published private(set) var preferences = AudioEqualizerPreferences()
    @Published private(set) var enabled = false
    private var observer: NSObjectProtocol?

    private init() {
        read()
        observer = NotificationCenter.default.addObserver(forName: UserDefaults.didChangeNotification,
            object: nil, queue: .main) { [weak self] _ in self?.syncWithPreferences() }
    }

    @discardableResult private func read() -> Bool {
        let defaults = UserDefaults.standard
        let next = AudioEqualizerPreferences(rawValue: defaults.string(forKey: DefaultsKey.audioEqualizerProfiles) ?? "")
        let on = defaults.bool(forKey: DefaultsKey.audioEqualizerEnabled)
        let changed = next != preferences || on != enabled
        if next != preferences { preferences = next }
        if on != enabled { enabled = on }
        return changed
    }

    func syncWithPreferences(force: Bool = false) {
        let wasEnabled = enabled
        if read() || force {
            AppVolumeMixer.shared.equalizerDidChange(retryFailedEngines: wasEnabled != enabled)
        }
    }

    func setEnabled(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: DefaultsKey.audioEqualizerEnabled)
        syncWithPreferences(force: true)
    }

    func edit(_ change: (inout AudioEqualizerPreferences) -> Void) {
        var next = preferences
        change(&next)
        UserDefaults.standard.set(next.rawValue, forKey: DefaultsKey.audioEqualizerProfiles)
        syncWithPreferences(force: true)
    }
}
