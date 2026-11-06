import 'package:meta/meta.dart';
import 'package:risk_model/src/factor.dart';
import 'package:risk_model/src/model_version.dart';
import 'package:risk_model/src/thresholds.dart';

/// One factor's share of a day's load.
@immutable
class Contribution {
  /// All fields required.
  const Contribution({
    required this.factor,
    required this.exposure,
    required this.weight,
    required this.confidence,
    required this.points,
  });

  /// Reads [toJson].
  factory Contribution.fromJson(Map<String, Object?> json) => Contribution(
    factor: Factor.fromId(json['factor']! as String)!,
    exposure: (json['exposure']! as num).toDouble(),
    weight: (json['weight']! as num).toDouble(),
    confidence: (json['confidence']! as num).toDouble(),
    points: (json['points']! as num).toDouble(),
  );

  /// Which factor.
  final Factor factor;

  /// 0 to 1 from the factor module.
  final double exposure;

  /// The effective weight used.
  final double weight;

  /// The weight's confidence, 0 to 1.
  final double confidence;

  /// 0 to 100: what this factor alone would put on the load.
  final double points;

  /// Storage shape.
  Map<String, Object?> toJson() => {
    'factor': factor.id,
    'exposure': exposure,
    'weight': weight,
    'confidence': confidence,
    'points': points,
  };
}

/// The model's output for one day.
@immutable
class DayRisk {
  /// [version] defaults to the running model.
  const DayRisk({
    required this.date,
    required this.load,
    required this.level,
    required this.contributions,
    required this.confidence,
    required this.coverage,
    this.version = modelVersion,
  });

  /// Reads [toJson].
  factory DayRisk.fromJson(Map<String, Object?> json) => DayRisk(
    date: json['date']! as String,
    load: (json['load']! as num).toDouble(),
    level: RiskLevel.fromId(json['level']! as String),
    contributions: [
      for (final c in json['contributions']! as List)
        Contribution.fromJson((c as Map).cast<String, Object?>()),
    ],
    confidence: (json['confidence']! as num).toDouble(),
    coverage: (json['coverage']! as num).toDouble(),
    version: json['version'] as String? ?? modelVersion,
  );

  /// `yyyy-MM-dd`.
  final String date;

  /// 0 to 100, one decimal.
  final double load;

  /// The level [load] falls in.
  final RiskLevel level;

  /// Every factor that had data, strongest first.
  final List<Contribution> contributions;

  /// Mean weight confidence over the factors that had data, 0 to 1.
  final double confidence;

  /// Share of the fourteen factors that had data, 0 to 1.
  final double coverage;

  /// The [modelVersion] that produced this.
  final String version;

  /// The strongest contributions with any points, at most [count].
  List<Contribution> drivers({int count = 3}) =>
      contributions.where((c) => c.points > 0).take(count).toList();

  /// Storage shape.
  Map<String, Object?> toJson() => {
    'date': date,
    'load': load,
    'level': level.id,
    'contributions': [for (final c in contributions) c.toJson()],
    'confidence': confidence,
    'coverage': coverage,
    'version': version,
  };
}
