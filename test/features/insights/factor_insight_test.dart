import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/features/insights/domain/factor_insight.dart';
import 'package:risk_model/risk_model.dart';

FactorWeight weight({
  required double lift,
  required int exposures,
  double population = 0.4,
  int attacksAfter = 0,
}) => FactorWeight(
  population: population,
  personal: population * lift,
  confidence: 0.5,
  nExposures: exposures,
  nAttacksAfter: attacksAfter,
);

void main() {
  const needed = AppThresholds.minExposuresForInsight;

  test('the exposure floor: 4 days is not enough, 5 is sorted', () {
    final four = FactorInsight.from(
      Factor.stress,
      weight(lift: 2, exposures: needed - 1, attacksAfter: 3),
    );
    expect(four.bucket, InsightBucket.notEnoughData);
    expect(four.exposures, 4);
    expect(four.attacksAfter, 3);
    expect(four.lift, 2);

    final five = FactorInsight.from(
      Factor.stress,
      weight(lift: 2, exposures: needed, attacksAfter: 4),
    );
    expect(five.bucket, InsightBucket.trigger);
    expect(five.exposures, 5);
  });

  test('lift boundaries', () {
    InsightBucket at(double lift) => FactorInsight.from(
      Factor.alcohol,
      weight(lift: lift, exposures: 9),
    ).bucket;
    expect(at(AppThresholds.insightTriggerLift), InsightBucket.trigger);
    expect(at(AppThresholds.insightTriggerLift - 0.01), InsightBucket.neutral);
    expect(at(1), InsightBucket.neutral);
    expect(
      at(AppThresholds.insightProtectorLift + 0.01),
      InsightBucket.neutral,
    );
    expect(at(AppThresholds.insightProtectorLift), InsightBucket.protector);
    expect(at(0), InsightBucket.protector);
  });

  test('a zero population weight is the usual rate', () {
    final i = FactorInsight.from(
      Factor.pollen,
      const FactorWeight(
        population: 0,
        personal: 0,
        confidence: 0,
        nExposures: 20,
      ),
    );
    expect(i.lift, 1);
    expect(i.bucket, InsightBucket.neutral);
  });

  test('factorInsights sorts by bucket then by strength of effect', () {
    final table = WeightTable.population()
        .copyWith(
          Factor.stress,
          weight(population: 0.45, lift: 1.5, exposures: 10),
        )
        .copyWith(
          Factor.alcohol,
          weight(population: 0.35, lift: 2.2, exposures: 10),
        )
        .copyWith(
          Factor.caffeine,
          weight(population: 0.25, lift: 0.5, exposures: 10),
        )
        .copyWith(
          Factor.pollen,
          weight(population: 0.2, lift: 1, exposures: 10),
        );
    final list = factorInsights(table);
    expect(list.length, Factor.values.length);
    expect(list[0].factor, Factor.alcohol);
    expect(list[0].bucket, InsightBucket.trigger);
    expect(list[1].factor, Factor.stress);
    expect(list[2].factor, Factor.caffeine);
    expect(list[2].bucket, InsightBucket.protector);
    expect(list[3].factor, Factor.pollen);
    expect(list[3].bucket, InsightBucket.neutral);
    expect(
      list.skip(4).every((i) => i.bucket == InsightBucket.notEnoughData),
      isTrue,
    );
  });

  test('no weights at all means not enough data everywhere', () {
    final list = factorInsights(null);
    expect(list.every((i) => i.bucket == InsightBucket.notEnoughData), isTrue);
    expect(list.every((i) => i.exposures == 0), isTrue);
  });
}
