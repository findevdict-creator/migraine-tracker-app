import 'package:meta/meta.dart';

/// The attack running on the phone.
@immutable
class WatchAttack {
  /// Creates the running attack summary.
  const WatchAttack({required this.startedAt, this.intensity});

  /// When it started.
  final DateTime startedAt;

  /// 0 to 10, null until answered.
  final int? intensity;

  /// Wire form.
  Map<String, Object?> toJson() => {
    'startedAt': startedAt.toUtc().toIso8601String(),
    if (intensity != null) 'intensity': intensity,
  };

  /// Parses the wire form; null when malformed.
  static WatchAttack? fromJson(Object? json) {
    if (json is! Map) return null;
    final started = json['startedAt'];
    final at = started is String ? DateTime.tryParse(started) : null;
    if (at == null) return null;
    final intensity = json['intensity'];
    return WatchAttack(
      startedAt: at,
      intensity: intensity is int ? intensity : null,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is WatchAttack &&
      other.startedAt.isAtSameMomentAs(startedAt) &&
      other.intensity == intensity;

  @override
  int get hashCode => Object.hash(startedAt.millisecondsSinceEpoch, intensity);
}

/// Everything the watch shows, as the phone last sent it. Text is already
/// in the phone's language; the watch formats nothing but the start time.
@immutable
class WatchState {
  /// Creates a state.
  const WatchState({
    required this.sentAt,
    this.level = '',
    this.levelLabel = '',
    this.headline = '',
    this.pressure = '',
    this.updated = '',
    this.levelColor,
    this.accentColor,
    this.attack,
    this.labels = const {},
    this.acks = const [],
  });

  /// When the phone built it.
  final DateTime sentAt;

  /// The level code (`low`, `moderate`, `high`), empty when none yet.
  final String level;

  /// "Level: High".
  final String levelLabel;

  /// The top factor line.
  final String headline;

  /// The pressure trend line.
  final String pressure;

  /// "Updated 09:30".
  final String updated;

  /// ARGB colour of the level on a dark background, null when none.
  final int? levelColor;

  /// ARGB brand colour for buttons, null to keep the watch default.
  final int? accentColor;

  /// The running attack, null when none.
  final WatchAttack? attack;

  /// Button and status labels, see `WatchLabels`.
  final Map<String, String> labels;

  /// Ids of the most recent commands the phone applied.
  final List<String> acks;

  /// Wire form.
  Map<String, Object?> toJson() => {
    'sentAt': sentAt.toUtc().toIso8601String(),
    'level': level,
    'levelLabel': levelLabel,
    'headline': headline,
    'pressure': pressure,
    'updated': updated,
    if (levelColor != null) 'levelColor': levelColor,
    if (accentColor != null) 'accentColor': accentColor,
    if (attack != null) 'attack': attack!.toJson(),
    'labels': labels,
    'acks': acks,
  };

  /// Parses the wire form; null when malformed.
  static WatchState? fromJson(Map<String, Object?>? json) {
    if (json == null) return null;
    final sent = json['sentAt'];
    final sentAt = sent is String ? DateTime.tryParse(sent) : null;
    if (sentAt == null) return null;
    String text(String key) => json[key] is String ? json[key]! as String : '';
    final labels = json['labels'];
    final acks = json['acks'];
    final color = json['levelColor'];
    final accent = json['accentColor'];
    return WatchState(
      sentAt: sentAt,
      level: text('level'),
      levelLabel: text('levelLabel'),
      headline: text('headline'),
      pressure: text('pressure'),
      updated: text('updated'),
      levelColor: color is int ? color : null,
      accentColor: accent is int ? accent : null,
      attack: WatchAttack.fromJson(json['attack']),
      labels: labels is Map
          ? {
              for (final e in labels.entries)
                if (e.key is String && e.value is String)
                  e.key as String: e.value as String,
            }
          : const {},
      acks: acks is List ? acks.whereType<String>().toList() : const [],
    );
  }
}
