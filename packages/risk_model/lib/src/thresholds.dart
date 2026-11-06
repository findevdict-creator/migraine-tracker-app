import 'package:meta/meta.dart';

/// The three levels the app shows.
enum RiskLevel {
  /// Below the moderate threshold.
  low('low'),

  /// Between the two thresholds.
  moderate('moderate'),

  /// At or above the high threshold.
  high('high');

  RiskLevel(this.id);

  /// Stable storage id.
  final String id;

  /// The level with this id; unknown ids read as low.
  static RiskLevel fromId(String id) =>
      values.firstWhere((l) => l.id == id, orElse: () => RiskLevel.low);
}

/// Load values at which the level becomes moderate and high. Population
/// defaults until phase 17 fits them to the person's own distribution.
@immutable
class LevelThresholds {
  /// Explicit thresholds.
  const LevelThresholds({required this.moderate, required this.high})
    : assert(moderate < high, 'moderate must be below high');

  /// The population defaults.
  const LevelThresholds.population() : this(moderate: 35, high: 60);

  /// Reads [toJson].
  factory LevelThresholds.fromJson(Map<String, Object?> json) =>
      LevelThresholds(
        moderate: (json['moderate']! as num).toDouble(),
        high: (json['high']! as num).toDouble(),
      );

  /// Load at or above which the level is moderate.
  final double moderate;

  /// Load at or above which the level is high.
  final double high;

  /// The level for a load.
  RiskLevel levelFor(double load) {
    if (load >= high) return RiskLevel.high;
    if (load >= moderate) return RiskLevel.moderate;
    return RiskLevel.low;
  }

  /// Storage shape.
  Map<String, Object?> toJson() => {'moderate': moderate, 'high': high};
}
