import Foundation

/// Label keys and the English fallbacks used before the phone has sent its
/// own. Mirrors `WatchLabels` in the Dart package.
public enum WatchLabels {
    public static let start = "start"
    public static let stop = "stop"
    public static let intensity = "intensity"
    public static let since = "since"
    public static let pending = "pending"
    public static let noPhone = "noPhone"

    public static let fallback: [String: String] = [
        start: "Start attack",
        stop: "End attack",
        intensity: "Intensity",
        since: "Since {time}",
        pending: "Saved on the watch. Sends when your phone is near.",
        noPhone: "Open the app on your phone once to connect the watch.",
    ]

    public static func resolve(_ labels: [String: String]?) -> [String: String] {
        fallback.merging(labels ?? [:]) { _, phone in phone }
    }
}
