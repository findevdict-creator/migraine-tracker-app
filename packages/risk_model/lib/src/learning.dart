import 'package:meta/meta.dart';
import 'package:risk_model/src/day_inputs.dart';
import 'package:risk_model/src/day_risk.dart';
import 'package:risk_model/src/factor_module.dart';
import 'package:risk_model/src/factors/factors.dart';
import 'package:risk_model/src/load.dart';
import 'package:risk_model/src/thresholds.dart';
import 'package:risk_model/src/weights.dart';

/// Knobs of the learning step. The app passes its configured values.
@immutable
class LearningParams {
  /// All fields have the population defaults.
  const LearningParams({
    this.windowDays = 2,
    this.shrinkage = 10,
    this.attacksForFullConfidence = 10,
    this.moderatePercentile = 0.6,
    this.highPercentile = 0.85,
    this.minDaysForThresholds = 30,
    this.minThresholdGap = 5,
  }) : assert(windowDays >= 1, 'window must cover at least the day itself'),
       assert(
         moderatePercentile < highPercentile,
         'moderate percentile must be below high',
       );

  /// An exposure on day D counts as followed by an attack when one starts
  /// on D or within the next `windowDays - 1` days (2 = the 24 to 48 h
  /// before an attack).
  final int windowDays;

  /// Exposure days needed before confidence reaches one half.
  final int shrinkage;

  /// Attacks needed before confidence can reach one.
  final int attacksForFullConfidence;

  /// Where on the person's own load distribution Moderate starts.
  final double moderatePercentile;

  /// Where on the person's own load distribution High starts.
  final double highPercentile;

  /// Days of history needed before the thresholds are fitted at all.
  final int minDaysForThresholds;

  /// Fitted thresholds closer than this fall back to population.
  final double minThresholdGap;
}

/// What a learning run produced.
@immutable
class LearningResult {
  /// All fields required.
  const LearningResult({
    required this.weights,
    required this.thresholds,
    required this.attackCount,
    required this.dayCount,
    required this.history,
  });

  /// Weights after this run.
  final WeightTable weights;

  /// Thresholds after this run (population while history is short).
  final LevelThresholds thresholds;

  /// Attacks that fell inside the days learned from.
  final int attackCount;

  /// Days learned from.
  final int dayCount;

  /// Every input day scored with the new weights and thresholds, in
  /// date order, so the app can store them.
  final List<DayRisk> history;
}

/// Learns personal weights and thresholds from a person's history.
///
/// For each factor: `lift = P(attack follows | exposed) / P(attack
/// follows)`, with one pseudo-observation at the base rate so a factor
/// never seen keeps lift 1. `personal = clamp(population × lift, 0, 1)`.
/// `confidence = n / (n + shrinkage) × min(1, attacks / attacksForFull)`
/// where n is the number of exposure days, so a weight moves only as
/// evidence accumulates. Thresholds are the configured percentiles of
/// the person's own loads once enough days exist.
class Learner {
  /// [modules] defaults to all fourteen.
  const Learner({
    this.params = const LearningParams(),
    this.modules = allModules,
  });

  /// The knobs.
  final LearningParams params;

  /// Modules to learn for.
  final List<FactorModule> modules;

  /// Runs over [days] (any order, one per date) with the dates on which
  /// attacks started.
  LearningResult learn({
    required List<DayInputs> days,
    required Set<String> attackDates,
  }) {
    final sorted = [...days]..sort((a, b) => a.date.compareTo(b.date));
    final followed = _followedDates(attackDates);
    final attacks = sorted.isEmpty
        ? 0
        : attackDates
              .where(
                (d) =>
                    d.compareTo(sorted.first.date) >= 0 &&
                    d.compareTo(sorted.last.date) <= 0,
              )
              .length;
    final nFollowed = sorted.where((d) => followed.contains(d.date)).length;
    final baseRate = (nFollowed + 1) / (sorted.length + 2);
    final attackFactor = params.attacksForFullConfidence == 0
        ? 1.0
        : (attacks / params.attacksForFullConfidence).clamp(0.0, 1.0);

    var table = WeightTable.population();
    for (final module in modules) {
      var expSum = 0.0;
      var attackSum = 0.0;
      var nExposures = 0;
      var nAttacksAfter = 0;
      for (final day in sorted) {
        final e = module.exposure(day);
        if (e == null || e <= 0) continue;
        final after = followed.contains(day.date);
        expSum += e;
        nExposures++;
        if (after) {
          attackSum += e;
          nAttacksAfter++;
        }
      }
      final rate = (attackSum + baseRate) / (expSum + 1);
      final lift = rate / baseRate;
      final population = module.populationWeight;
      final personal = _round3((population * lift).clamp(0.0, 1.0));
      final confidence = _round3(
        nExposures / (nExposures + params.shrinkage) * attackFactor,
      );
      table = table.copyWith(
        module.factor,
        FactorWeight(
          population: population,
          personal: personal,
          confidence: confidence,
          nExposures: nExposures,
          nAttacksAfter: nAttacksAfter,
        ),
      );
    }

    final scorer = DailyLoad(weights: table, modules: modules);
    final loads = [for (final d in sorted) scorer.compute(d).load];
    final thresholds = _fitThresholds(loads);
    final finalScorer = DailyLoad(
      weights: table,
      thresholds: thresholds,
      modules: modules,
    );
    return LearningResult(
      weights: table,
      thresholds: thresholds,
      attackCount: attacks,
      dayCount: sorted.length,
      history: [for (final d in sorted) finalScorer.compute(d)],
    );
  }

  /// Dates whose exposures count as followed by an attack: each attack
  /// date and the `windowDays - 1` dates before it.
  Set<String> _followedDates(Set<String> attackDates) {
    final out = <String>{};
    for (final a in attackDates) {
      final date = DateTime.parse(a);
      for (var k = 0; k < params.windowDays; k++) {
        out.add(_key(date.subtract(Duration(days: k))));
      }
    }
    return out;
  }

  LevelThresholds _fitThresholds(List<double> loads) {
    const population = LevelThresholds.population();
    if (loads.length < params.minDaysForThresholds) return population;
    final sorted = [...loads]..sort();
    final moderate = _round1(_percentile(sorted, params.moderatePercentile));
    final high = _round1(_percentile(sorted, params.highPercentile));
    if (high - moderate < params.minThresholdGap || moderate <= 0) {
      return population;
    }
    return LevelThresholds(moderate: moderate, high: high);
  }

  static double _percentile(List<double> sorted, double p) {
    final pos = p * (sorted.length - 1);
    final lo = pos.floor();
    final hi = pos.ceil();
    if (lo == hi) return sorted[lo];
    return sorted[lo] + (sorted[hi] - sorted[lo]) * (pos - lo);
  }

  static String _key(DateTime d) {
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '${d.year}-$m-$day';
  }

  static double _round3(double v) => (v * 1000).roundToDouble() / 1000;
  static double _round1(double v) => (v * 10).roundToDouble() / 10;
}
