import Foundation

/// Watch settings. The shared values mirror `WatchConfig` in
/// packages/watch_protocol/lib/src/watch_config.dart; the app group
/// mirrors `AppHomeWidgets.iosAppGroup` in lib/config/app_config.dart.
public enum WatchConfig {
    /// App group shared by the watch app and its complication.
    public static let appGroup = "group.app.aurawell.mobile"

    /// WidgetKit kind of the complication.
    public static let complicationKind = "RiskComplication"

    /// How often the complication redraws from the stored state.
    public static let complicationRefresh: TimeInterval = 30 * 60

    /// How often unacknowledged commands are resent while the app is open.
    public static let resendEvery: TimeInterval = 30

    /// Storage keys, the same names as the Wear OS app uses.
    public static let storedState = "watch.state"
    public static let storedQueue = "watch.queue"
}

/// The watch's stored state and queue, shared with the complication
/// through the app group.
public struct WatchStorage {
    private let defaults: UserDefaults

    public init(defaults: UserDefaults? = UserDefaults(suiteName: WatchConfig.appGroup)) {
        self.defaults = defaults ?? .standard
    }

    public func loadState() -> WatchState? {
        guard let text = defaults.string(forKey: WatchConfig.storedState) else { return nil }
        return WatchState(json: WatchWire.unwrap([WatchWire.payloadKey: text]))
    }

    public func save(_ state: WatchState) {
        if let text = WatchWire.wrap(state.json)[WatchWire.payloadKey] as? String {
            defaults.set(text, forKey: WatchConfig.storedState)
        }
    }

    public func loadQueue() -> CommandQueue {
        guard
            let text = defaults.string(forKey: WatchConfig.storedQueue),
            let data = text.data(using: .utf8),
            let json = try? JSONSerialization.jsonObject(with: data)
        else { return CommandQueue() }
        return CommandQueue(json: json)
    }

    public func save(_ queue: CommandQueue) {
        guard
            let data = try? JSONSerialization.data(withJSONObject: queue.json),
            let text = String(data: data, encoding: .utf8)
        else { return }
        defaults.set(text, forKey: WatchConfig.storedQueue)
    }
}
