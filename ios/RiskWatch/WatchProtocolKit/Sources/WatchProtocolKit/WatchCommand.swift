import Foundation

/// What the person did on the watch.
public enum WatchCommandType: String {
    case start
    case stop
    case intensity
}

/// One action taken on the watch, with the time it was taken there.
/// Mirrors `WatchCommand` in the Dart package.
public struct WatchCommand: Equatable {
    public let id: String
    public let type: WatchCommandType
    public let at: Date
    public let intensity: Int?

    public init(id: String, type: WatchCommandType, at: Date, intensity: Int? = nil) {
        self.id = id
        self.type = type
        self.at = at
        self.intensity = intensity.map { min(max($0, 0), 10) }
    }

    public init?(json: Any?) {
        guard
            let map = json as? [String: Any],
            let id = map["id"] as? String, !id.isEmpty,
            let raw = map["type"] as? String,
            let type = WatchCommandType(rawValue: raw),
            let at = ISODate.parse(map["at"])
        else { return nil }
        let intensity = (map["intensity"] as? NSNumber)?.intValue
        if type == .intensity && intensity == nil { return nil }
        self.init(id: id, type: type, at: at, intensity: intensity)
    }

    public var json: [String: Any] {
        var out: [String: Any] = [
            "id": id,
            "type": type.rawValue,
            "at": ISODate.format(at),
        ]
        if let intensity = intensity { out["intensity"] = intensity }
        return out
    }

    /// Wraps a batch for one message.
    public static func batchJSON(_ commands: [WatchCommand]) -> [String: Any] {
        ["commands": commands.map { $0.json }]
    }

    /// Reads a batch; malformed entries are dropped.
    public static func batch(from json: [String: Any]?) -> [WatchCommand] {
        guard let list = json?["commands"] as? [Any] else { return [] }
        return list.compactMap { WatchCommand(json: $0) }
    }
}
