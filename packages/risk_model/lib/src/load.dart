import 'package:risk_model/src/day_inputs.dart';
import 'package:risk_model/src/day_risk.dart';
import 'package:risk_model/src/factor.dart';
import 'package:risk_model/src/factor_module.dart';
import 'package:risk_model/src/factors/factors.dart';
import 'package:risk_model/src/thresholds.dart';
import 'package:risk_model/src/weights.dart';

/// Computes the daily load.
///
/// Each factor with data contributes `points = 100 * exposure * weight`.
/// The load combines them as `100 * (1 - prod(1 - points / 100))`, so one
/// strong factor alone reaches its own points, several stack without
/// ever exceeding 100, and the order of factors does not matter.
/// Points, load and coverage are rounded to one decimal and the factor
/// details to three, so the same inputs always give the same stored
/// numbers.
class DailyLoad {
  /// Null [weights] means population rules.
  const DailyLoad({
    this.weights,
    this.thresholds = const LevelThresholds.population(),
    this.modules = allModules,
  });

  /// Weights in use, null for population.
  final WeightTable? weights;

  /// Level cut points.
  final LevelThresholds thresholds;

  /// The factor modules to run, [allModules] by default.
  final List<FactorModule> modules;

  /// Scores one day.
  DayRisk compute(DayInputs day) {
    final table = weights ?? WeightTable.population();
    final contributions = <Contribution>[];
    var survival = 1.0;
    var confidenceSum = 0.0;
    for (final module in modules) {
      final exposure = module.exposure(day);
      if (exposure == null) continue;
      final weight = table[module.factor];
      final points = _round(100 * exposure * weight.effective);
      survival *= 1 - points / 100;
      confidenceSum += weight.confidence;
      contributions.add(
        Contribution(
          factor: module.factor,
          exposure: _round3(exposure),
          weight: _round3(weight.effective),
          confidence: _round3(weight.confidence),
          points: points,
        ),
      );
    }
    contributions.sort((a, b) {
      final byPoints = b.points.compareTo(a.points);
      return byPoints != 0
          ? byPoints
          : a.factor.index.compareTo(b.factor.index);
    });
    final load = contributions.isEmpty ? 0.0 : _round(100 * (1 - survival));
    final n = contributions.length;
    return DayRisk(
      date: day.date,
      load: load,
      level: thresholds.levelFor(load),
      contributions: contributions,
      confidence: n == 0 ? 0 : _round3(confidenceSum / n),
      coverage: _round3(n / Factor.values.length),
    );
  }

  static double _round(double v) => (v * 10).roundToDouble() / 10;
  static double _round3(double v) => (v * 1000).roundToDouble() / 1000;
}
