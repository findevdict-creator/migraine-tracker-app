import Foundation

/// Framing shared by every message on the wire. Mirrors `WatchWire` in
/// packages/watch_protocol/lib/src/watch_wire.dart.
public enum WatchWire {
    /// Payloads with a newer version are ignored.
    public static let version = 1

    /// The single key that carries the JSON payload as a string.
    public static let payloadKey = "mt"

    /// Wraps `json` for the transport.
    public static func wrap(_ json: [String: Any]) -> [String: Any] {
        var body = json
        body["v"] = version
        guard
            let data = try? JSONSerialization.data(
                withJSONObject: body, options: [.sortedKeys]),
            let text = String(data: data, encoding: .utf8)
        else { return [:] }
        return [payloadKey: text]
    }

    /// Unwraps a transport map; nil for anything foreign, malformed or newer.
    public static func unwrap(_ message: [String: Any]?) -> [String: Any]? {
        guard
            let raw = message?[payloadKey] as? String,
            let data = raw.data(using: .utf8),
            let object = try? JSONSerialization.jsonObject(with: data),
            let json = object as? [String: Any],
            let v = (json["v"] as? NSNumber)?.intValue,
            v <= version
        else { return nil }
        return json
    }
}

/// ISO 8601 in UTC with milliseconds, as Dart's `toIso8601String` writes.
enum ISODate {
    private static let fractional: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return f
    }()

    private static let plain: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime]
        return f
    }()

    static func parse(_ value: Any?) -> Date? {
        guard let text = value as? String else { return nil }
        return fractional.date(from: text) ?? plain.date(from: text)
    }

    static func format(_ date: Date) -> String {
        fractional.string(from: date)
    }
}

/// Reads a 32-bit ARGB colour from a JSON number. Uses 64-bit arithmetic
/// because `Int` is 32 bits on some Apple Watch models.
func argb(_ value: Any?) -> UInt32? {
    guard let number = value as? NSNumber else { return nil }
    return UInt32(truncatingIfNeeded: number.int64Value)
}
