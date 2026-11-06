import 'package:meta/meta.dart';

/// What the person did on the watch.
enum WatchCommandType {
  /// Start an attack (or keep the running one).
  start('start'),

  /// End the running attack.
  stop('stop'),

  /// Set the running attack's intensity, 0 to 10.
  intensity('intensity');

  WatchCommandType(this.code);

  /// Stable wire name.
  final String code;

  /// The type for [code], or null when unknown.
  static WatchCommandType? fromCode(Object? code) {
    for (final t in values) {
      if (t.code == code) return t;
    }
    return null;
  }
}

/// One action taken on the watch, with the time it was taken there.
@immutable
class WatchCommand {
  /// Creates a command. [intensity] is required for
  /// [WatchCommandType.intensity] and clamped to 0 to 10.
  WatchCommand({
    required this.id,
    required this.type,
    required this.at,
    int? intensity,
  }) : intensity = intensity?.clamp(0, 10) {
    if (type == WatchCommandType.intensity && intensity == null) {
      throw ArgumentError.value(intensity, 'intensity', 'required');
    }
  }

  /// Unique per command; the phone applies each id once.
  final String id;

  /// What to do.
  final WatchCommandType type;

  /// When it happened on the watch.
  final DateTime at;

  /// The chosen intensity for [WatchCommandType.intensity].
  final int? intensity;

  /// Wire form.
  Map<String, Object?> toJson() => {
    'id': id,
    'type': type.code,
    'at': at.toUtc().toIso8601String(),
    if (intensity != null) 'intensity': intensity,
  };

  /// Parses the wire form; null when malformed or of an unknown type.
  static WatchCommand? fromJson(Object? json) {
    if (json is! Map) return null;
    final id = json['id'];
    final type = WatchCommandType.fromCode(json['type']);
    final at = json['at'] is String
        ? DateTime.tryParse(json['at'] as String)
        : null;
    final intensity = json['intensity'];
    if (id is! String || id.isEmpty || type == null || at == null) {
      return null;
    }
    if (type == WatchCommandType.intensity && intensity is! int) return null;
    return WatchCommand(
      id: id,
      type: type,
      at: at,
      intensity: intensity is int ? intensity : null,
    );
  }

  /// Wraps a batch of commands for one message.
  static Map<String, Object?> batchToJson(Iterable<WatchCommand> commands) => {
    'commands': [for (final c in commands) c.toJson()],
  };

  /// Reads a batch; malformed entries are dropped.
  static List<WatchCommand> batchFromJson(Map<String, Object?>? json) {
    final list = json?['commands'];
    if (list is! List) return const [];
    return [for (final e in list) ?WatchCommand.fromJson(e)];
  }

  @override
  bool operator ==(Object other) =>
      other is WatchCommand &&
      other.id == id &&
      other.type == type &&
      other.at.isAtSameMomentAs(at) &&
      other.intensity == intensity;

  @override
  int get hashCode =>
      Object.hash(id, type, at.millisecondsSinceEpoch, intensity);

  @override
  String toString() => 'WatchCommand($id, ${type.code}, $at, $intensity)';
}
