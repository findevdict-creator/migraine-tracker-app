import 'package:flutter/foundation.dart';
import 'package:risk_model/risk_model.dart';

/// One stored day of risk output (the `risk_days` row).
@immutable
class RiskDayEntity {
  const RiskDayEntity({
    required this.date,
    required this.level,
    required this.score,
    required this.contributions,
    required this.modelVersion,
    required this.computedAt,
  });

  /// From the model's output.
  RiskDayEntity.fromRisk(DayRisk risk, {required DateTime computedAt})
    : this(
        date: risk.date,
        level: risk.level,
        score: risk.load,
        contributions: risk.contributions,
        modelVersion: risk.version,
        computedAt: computedAt,
      );

  final String date;
  final RiskLevel level;

  /// The load, 0 to 100.
  final double score;

  /// Every factor that had data, strongest first.
  final List<Contribution> contributions;
  final String modelVersion;
  final DateTime computedAt;

  /// Mean weight confidence over the factors that had data, 0 to 1.
  double get confidence {
    if (contributions.isEmpty) return 0;
    final sum = contributions.fold<double>(0, (a, c) => a + c.confidence);
    return sum / contributions.length;
  }

  /// The strongest contributions with points, at most [count].
  List<Contribution> drivers({int count = 3}) =>
      contributions.where((c) => c.points > 0).take(count).toList();
}

/// The level shown for one day, frozen for the self-audit (`audit_days`).
@immutable
class ShownRisk {
  const ShownRisk({
    required this.date,
    required this.level,
    required this.modelVersion,
  });

  final String date;
  final RiskLevel level;
  final String modelVersion;
}
