import Foundation

/// The attack running on the phone.
public struct WatchAttack: Equatable {
    public let startedAt: Date
    public let intensity: Int?

    public init(startedAt: Date, intensity: Int? = nil) {
        self.startedAt = startedAt
        self.intensity = intensity
    }

    public init?(json: Any?) {
        guard
            let map = json as? [String: Any],
            let startedAt = ISODate.parse(map["startedAt"])
        else { return nil }
        self.init(
            startedAt: startedAt,
            intensity: (map["intensity"] as? NSNumber)?.intValue)
    }

    public var json: [String: Any] {
        var out: [String: Any] = ["startedAt": ISODate.format(startedAt)]
        if let intensity = intensity { out["intensity"] = intensity }
        return out
    }
}

/// Everything the watch shows, as the phone last sent it. Mirrors
/// `WatchState` in the Dart package.
public struct WatchState: Equatable {
    public let sentAt: Date
    public let level: String
    public let levelLabel: String
    public let headline: String
    public let pressure: String
    public let updated: String
    public let levelColor: UInt32?
    public let accentColor: UInt32?
    public let attack: WatchAttack?
    public let labels: [String: String]
    public let acks: [String]

    public init(
        sentAt: Date,
        level: String = "",
        levelLabel: String = "",
        headline: String = "",
        pressure: String = "",
        updated: String = "",
        levelColor: UInt32? = nil,
        accentColor: UInt32? = nil,
        attack: WatchAttack? = nil,
        labels: [String: String] = [:],
        acks: [String] = []
    ) {
        self.sentAt = sentAt
        self.level = level
        self.levelLabel = levelLabel
        self.headline = headline
        self.pressure = pressure
        self.updated = updated
        self.levelColor = levelColor
        self.accentColor = accentColor
        self.attack = attack
        self.labels = labels
        self.acks = acks
    }

    public init?(json: [String: Any]?) {
        guard let json = json, let sentAt = ISODate.parse(json["sentAt"]) else {
            return nil
        }
        func text(_ key: String) -> String { json[key] as? String ?? "" }
        var labels: [String: String] = [:]
        for (key, value) in json["labels"] as? [String: Any] ?? [:] {
            if let value = value as? String { labels[key] = value }
        }
        self.init(
            sentAt: sentAt,
            level: text("level"),
            levelLabel: text("levelLabel"),
            headline: text("headline"),
            pressure: text("pressure"),
            updated: text("updated"),
            levelColor: argb(json["levelColor"]),
            accentColor: argb(json["accentColor"]),
            attack: WatchAttack(json: json["attack"]),
            labels: labels,
            acks: (json["acks"] as? [Any] ?? []).compactMap { $0 as? String })
    }

    public var json: [String: Any] {
        var out: [String: Any] = [
            "sentAt": ISODate.format(sentAt),
            "level": level,
            "levelLabel": levelLabel,
            "headline": headline,
            "pressure": pressure,
            "updated": updated,
            "labels": labels,
            "acks": acks,
        ]
        if let levelColor = levelColor { out["levelColor"] = Int64(levelColor) }
        if let accentColor = accentColor { out["accentColor"] = Int64(accentColor) }
        if let attack = attack { out["attack"] = attack.json }
        return out
    }
}
