import 'dart:convert';

/// Framing shared by every message on the wire.
abstract final class WatchWire {
  /// Bump when a field changes meaning. Each side ignores payloads with a
  /// newer major version than it understands.
  static const int version = 1;

  /// The single map key that carries the JSON payload. The Wear OS data
  /// layer carries flat maps only, so the JSON travels as one string.
  static const String payloadKey = 'mt';

  /// Wraps [json] for the transport.
  static Map<String, Object> wrap(Map<String, Object?> json) => {
    payloadKey: jsonEncode({'v': version, ...json}),
  };

  /// Unwraps a transport map. Returns null for anything that is not ours or
  /// comes from a newer protocol version.
  static Map<String, Object?>? unwrap(Map<String, dynamic>? message) {
    final raw = message?[payloadKey];
    if (raw is! String) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, Object?>) return null;
      final v = decoded['v'];
      if (v is! int || v > version) return null;
      return decoded;
    } on FormatException {
      return null;
    }
  }
}
