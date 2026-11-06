import 'package:risk_model/risk_model.dart';
import 'package:test/test.dart';

import 'support.dart';

void main() {
  const load = DailyLoad();

  test('an empty day is load 0, low, no contributions', () {
    final r = load.compute(day());
    expect(r.load, 0);
    expect(r.level, RiskLevel.low);
    expect(r.contributions, isEmpty);
    expect(r.drivers(), isEmpty);
    expect(r.confidence, 0);
    expect(r.coverage, 0);
    expect(r.version, modelVersion);
    expect(r.date, '2026-01-01');
  });

  test('one factor alone gives exactly its points', () {
    final r = load.compute(day(stress: 5));
    expect(r.load, 45);
    expect(r.level, RiskLevel.moderate);
    expect(r.contributions.single.factor, Factor.stress);
    expect(r.contributions.single.points, 45);
    expect(r.contributions.single.exposure, 1);
    expect(r.contributions.single.weight, 0.45);
    expect(r.coverage, 0.071);
  });

  test('a half exposure halves the points', () {
    final r = load.compute(day(stress: 4));
    expect(r.load, 22.5);
    expect(r.level, RiskLevel.low);
  });

  test('two factors combine with noisy-or', () {
    // stress 45 and poor sleep 50: 100 * (1 - 0.55 * 0.5) = 72.5
    final r = load.compute(day(stress: 5, sleepQuality: 1));
    expect(r.load, 72.5);
    expect(r.level, RiskLevel.high);
    expect(r.drivers().map((c) => c.factor), [Factor.poorSleep, Factor.stress]);
  });

  test('the worst day is below 100 and the calm day is 0', () {
    final worst = load.compute(worstDay);
    expect(worst.load, lessThanOrEqualTo(100));
    expect(worst.load, greaterThan(95));
    expect(worst.coverage, 1);
    expect(worst.contributions.length, Factor.values.length);
    expect(worst.drivers().length, 3);
    final calm = load.compute(calmDay);
    expect(calm.load, 0);
    expect(calm.coverage, 1);
    expect(calm.drivers(), isEmpty);
    expect(calm.contributions.length, Factor.values.length);
  });

  test('order of modules does not change the load', () {
    final reversed = DailyLoad(modules: allModules.reversed.toList());
    final a = load.compute(worstDay);
    final b = reversed.compute(worstDay);
    expect(a.load, b.load);
    expect(
      a.contributions.map((c) => c.factor),
      b.contributions.map((c) => c.factor),
    );
  });

  test('ties sort by factor order', () {
    final r = load.compute(day(aqiUs: 150, pollenMax: 100));
    expect(r.contributions.map((c) => c.factor), [
      Factor.airQuality,
      Factor.pollen,
    ]);
  });

  test('drivers skip zero points and honour the count', () {
    final r = load.compute(
      day(stress: 5, sleepQuality: 5, alcohol: 5, caffeine: 5, hydration: 1),
    );
    expect(r.drivers(count: 2).length, 2);
    expect(
      r.drivers(count: 10).map((c) => c.factor),
      isNot(contains(Factor.poorSleep)),
    );
  });

  test('personal weights and confidence flow through', () {
    final weights = WeightTable.population().copyWith(
      Factor.stress,
      const FactorWeight(population: 0.45, personal: 0.85, confidence: 0.5),
    );
    final r = DailyLoad(weights: weights).compute(day(stress: 5, caffeine: 5));
    final stress = r.contributions.first;
    expect(stress.factor, Factor.stress);
    expect(stress.weight, 0.65);
    expect(stress.confidence, 0.5);
    expect(stress.points, 65);
    expect(r.confidence, 0.25);
  });

  test('custom thresholds change the level only', () {
    const tight = DailyLoad(
      thresholds: LevelThresholds(moderate: 10, high: 20),
    );
    final r = tight.compute(day(stress: 4));
    expect(r.load, 22.5);
    expect(r.level, RiskLevel.high);
  });

  test('json round trip of DayRisk', () {
    final r = load.compute(day(stress: 5, sleepQuality: 2, alcohol: 3));
    final back = DayRisk.fromJson(r.toJson());
    expect(back.toJson(), r.toJson());
    final noVersion = r.toJson()..remove('version');
    expect(DayRisk.fromJson(noVersion).version, modelVersion);
  });

  test('DayInputs json round trip', () {
    final back = DayInputs.fromJson(worstDay.toJson());
    expect(back.toJson(), worstDay.toJson());
    expect(
      DayInputs.fromJson(const {'date': '2026-01-02'}).toJson()['stress'],
      null,
    );
  });
}
