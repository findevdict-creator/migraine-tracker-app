import 'package:flutter/foundation.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:risk_model/risk_model.dart';

/// FR-11 buckets. [protector] and [trigger] are peers: fewer attacks
/// after a factor is as useful to know as more.
enum InsightBucket { trigger, protector, neutral, notEnoughData }

/// One factor's standing in the person's own log.
@immutable
class FactorInsight {
  const FactorInsight({
    required this.factor,
    required this.bucket,
    required this.exposures,
    required this.attacksAfter,
    required this.lift,
  });

  /// Sorts a learned weight into a bucket. Below
  /// [AppThresholds.minExposuresForInsight] exposure days it is not
  /// enough data whatever the ratio. [lift] is the learned weight over
  /// the population weight, 1 meaning the usual rate.
  factory FactorInsight.from(Factor factor, FactorWeight weight) {
    final raw = weight.population == 0
        ? 1.0
        : weight.personal / weight.population;
    // Three decimals: enough to show, and keeps 0.8 × w / w at 0.8.
    final lift = (raw * 1000).roundToDouble() / 1000;
    final InsightBucket bucket;
    if (weight.nExposures < AppThresholds.minExposuresForInsight) {
      bucket = InsightBucket.notEnoughData;
    } else if (lift >= AppThresholds.insightTriggerLift) {
      bucket = InsightBucket.trigger;
    } else if (lift <= AppThresholds.insightProtectorLift) {
      bucket = InsightBucket.protector;
    } else {
      bucket = InsightBucket.neutral;
    }
    return FactorInsight(
      factor: factor,
      bucket: bucket,
      exposures: weight.nExposures,
      attacksAfter: weight.nAttacksAfter,
      lift: lift,
    );
  }

  final Factor factor;
  final InsightBucket bucket;

  /// Days the factor was present.
  final int exposures;

  /// Of those, days followed by an attack within the window.
  final int attacksAfter;

  /// Learned weight over population weight; 1 is the usual rate.
  final double lift;
}

/// Every factor sorted into buckets, strongest effect first within each.
List<FactorInsight> factorInsights(WeightTable? weights) {
  final table = weights ?? WeightTable.population();
  final out = [for (final f in Factor.values) FactorInsight.from(f, table[f])]
    ..sort((a, b) {
      final byBucket = a.bucket.index.compareTo(b.bucket.index);
      if (byBucket != 0) return byBucket;
      final byEffect = (b.lift - 1).abs().compareTo((a.lift - 1).abs());
      return byEffect != 0
          ? byEffect
          : a.factor.index.compareTo(b.factor.index);
    });
  return out;
}
