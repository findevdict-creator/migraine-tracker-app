import 'dart:math';

import 'package:risk_model/risk_model.dart';
import 'package:test/test.dart';

import 'support.dart';

String key(DateTime d) {
  final m = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  return '${d.year}-$m-$day';
}

/// Days where stress is high every third day and attacks follow stress
/// days, so stress should gain weight and the untouched factors lose it.
({List<DayInputs> days, Set<String> attacks}) stressDriven(int n) {
  final start = DateTime.utc(2025);
  final days = <DayInputs>[];
  final attacks = <String>{};
  for (var i = 0; i < n; i++) {
    final d = start.add(Duration(days: i));
    final stressed = i % 3 == 0;
    days.add(
      day(
        date: key(d),
        stress: stressed ? 5 : 2,
        caffeine: i.isEven ? 5 : 1,
        humidity: 80,
      ),
    );
    if (stressed) attacks.add(key(d.add(const Duration(days: 1))));
  }
  return (days: days, attacks: attacks);
}

void main() {
  const learner = Learner();

  test('no history keeps population weights and thresholds', () {
    final r = learner.learn(days: const [], attackDates: const {});
    expect(r.attackCount, 0);
    expect(r.dayCount, 0);
    expect(r.history, isEmpty);
    expect(r.thresholds.moderate, 35);
    for (final f in Factor.values) {
      expect(r.weights[f].confidence, 0);
      expect(r.weights[f].effective, moduleFor(f).populationWeight);
    }
  });

  test('a factor that precedes attacks gains weight, one that does not '
      'loses it, and confidence grows with exposures and attacks', () {
    final data = stressDriven(90);
    final r = learner.learn(days: data.days, attackDates: data.attacks);
    final stress = r.weights[Factor.stress];
    final caffeine = r.weights[Factor.caffeine];
    final humidity = r.weights[Factor.humidity];
    // Base rate: 60 of 90 days are followed by an attack (the stress day
    // and the attack day), so lift = (30.663 / 31) / (61 / 92) = 1.49.
    expect(stress.personal, greaterThan(stress.population));
    expect(stress.personal, closeTo(0.671, 1e-3));
    expect(stress.nExposures, 30);
    expect(stress.nAttacksAfter, 30);
    expect(stress.confidence, closeTo(30 / 40, 1e-9));
    // Caffeine is independent of attacks: lift near 1.
    expect(caffeine.personal, closeTo(caffeine.population, 0.1));
    expect(caffeine.nExposures, 45);
    // Humidity is on every day: lift exactly the base rate, personal
    // close to population, confidence 90/100.
    expect(humidity.confidence, 0.9);
    expect(r.attackCount, 30);
    expect(r.dayCount, 90);
    expect(r.history.length, 90);
    expect(r.history.first.date, '2025-01-01');
    expect(r.history.last.version, modelVersion);
  });

  test('attacks on days outside the history are not counted', () {
    final data = stressDriven(10);
    final r = learner.learn(
      days: data.days,
      attackDates: {...data.attacks, '2030-01-01'},
    );
    expect(r.attackCount, 3);
  });

  test('confidence is capped by the attack count', () {
    final data = stressDriven(9); // 3 attacks
    final r = learner.learn(days: data.days, attackDates: data.attacks);
    final stress = r.weights[Factor.stress];
    expect(stress.nExposures, 3);
    expect(stress.confidence, closeTo(3 / 13 * 3 / 10, 1e-3));
    const noCap = Learner(params: LearningParams(attacksForFullConfidence: 0));
    final r2 = noCap.learn(days: data.days, attackDates: data.attacks);
    expect(r2.weights[Factor.stress].confidence, closeTo(3 / 13, 1e-3));
  });

  test('a factor never followed by an attack drops towards zero', () {
    final start = DateTime.utc(2025);
    final days = [
      for (var i = 0; i < 60; i++)
        day(
          date: key(start.add(Duration(days: i))),
          alcohol: i.isEven ? 5 : 0,
          stress: i % 5 == 0 ? 5 : 1,
        ),
    ];
    // Attacks only on odd days (never on or after an alcohol day within
    // the window? alcohol days are even, window covers day and next, so
    // attacks on odd days do follow alcohol). Use a 1-day window.
    final attacks = {
      for (var i = 1; i < 60; i += 2) key(start.add(Duration(days: i))),
    };
    const oneDay = Learner(params: LearningParams(windowDays: 1));
    final r = oneDay.learn(days: days, attackDates: attacks);
    final alcohol = r.weights[Factor.alcohol];
    expect(alcohol.nAttacksAfter, 0);
    expect(alcohol.personal, lessThan(0.05));
  });

  group('thresholds', () {
    test('population while the history is short', () {
      final data = stressDriven(29);
      final r = learner.learn(days: data.days, attackDates: data.attacks);
      expect(r.thresholds.moderate, 35);
      expect(r.thresholds.high, 60);
    });

    test('fitted to the load distribution once long enough', () {
      final rng = Random(7);
      final start = DateTime.utc(2025);
      final days = [
        for (var i = 0; i < 120; i++)
          day(
            date: key(start.add(Duration(days: i))),
            stress: 1 + rng.nextInt(5),
            sleepQuality: 1 + rng.nextInt(5),
            pressureDelta24h: -8 + rng.nextDouble() * 10,
            alcohol: rng.nextInt(6),
          ),
      ];
      final attacks = {
        for (var i = 0; i < 120; i += 7) key(start.add(Duration(days: i))),
      };
      final r = learner.learn(days: days, attackDates: attacks);
      expect(r.thresholds.moderate, isNot(35));
      expect(r.thresholds.high, greaterThan(r.thresholds.moderate + 4.9));
      final loads = r.history.map((h) => h.load).toList()..sort();
      final below = loads.where((l) => l < r.thresholds.moderate).length;
      expect(below / loads.length, closeTo(0.6, 0.05));
      for (final h in r.history) {
        expect(h.level, r.thresholds.levelFor(h.load));
      }
    });

    test('falls back when the distribution is flat', () {
      final start = DateTime.utc(2025);
      final days = [
        for (var i = 0; i < 60; i++)
          day(date: key(start.add(Duration(days: i))), stress: 1),
      ];
      final r = learner.learn(days: days, attackDates: const {});
      expect(r.thresholds.moderate, 35);
    });

    test('percentile interpolates between samples', () {
      final start = DateTime.utc(2025);
      // 40 days: 20 calm, 20 with alternating stress 4 / 5, no attacks.
      final days = [
        for (var i = 0; i < 40; i++)
          day(
            date: key(start.add(Duration(days: i))),
            stress: i < 20 ? 1 : (i.isEven ? 4 : 5),
          ),
      ];
      const p = Learner(
        params: LearningParams(
          moderatePercentile: 0.5,
          highPercentile: 0.9,
          minDaysForThresholds: 10,
          minThresholdGap: 1,
        ),
      );
      final r = p.learn(days: days, attackDates: const {});
      expect(r.thresholds.moderate, greaterThan(0));
      expect(r.thresholds.high, greaterThan(r.thresholds.moderate));
    });
  });

  test('LearningParams asserts', () {
    expect(() => LearningParams(windowDays: 0), throwsA(isA<AssertionError>()));
    expect(
      () => LearningParams(moderatePercentile: 0.9, highPercentile: 0.5),
      throwsA(isA<AssertionError>()),
    );
  });

  test('benchmark: two years of history learns in under a second', () {
    final rng = Random(11);
    final start = DateTime.utc(2024);
    final days = <DayInputs>[];
    final attacks = <String>{};
    for (var i = 0; i < 730; i++) {
      final d = start.add(Duration(days: i));
      days.add(
        DayInputs(
          date: key(d),
          pressureDelta24h: -8 + rng.nextDouble() * 12,
          humidity: 30 + rng.nextDouble() * 65,
          temperatureSwing: rng.nextDouble() * 10,
          aqiUs: rng.nextDouble() * 180,
          pollenMax: rng.nextDouble() * 150,
          uvMax: rng.nextDouble() * 11,
          lightExposure: 1 + rng.nextInt(5),
          screenExposure: 1 + rng.nextInt(5),
          sleepQuality: 1 + rng.nextInt(5),
          sleepMinutes: 240 + rng.nextInt(300),
          stress: 1 + rng.nextInt(5),
          neckTension: 1 + rng.nextInt(5),
          caffeine: rng.nextInt(6),
          alcohol: rng.nextInt(6),
          hydration: 1 + rng.nextInt(5),
          cycleDay: i % 28 + 1,
          cycleLength: 28,
        ),
      );
      if (rng.nextInt(8) == 0) attacks.add(key(d));
    }
    // Warm up once, then time.
    learner.learn(days: days, attackDates: attacks);
    final watch = Stopwatch()..start();
    final r = learner.learn(days: days, attackDates: attacks);
    watch.stop();
    expect(r.history.length, 730);
    expect(
      watch.elapsedMilliseconds,
      lessThan(1000),
      reason: 'took ${watch.elapsedMilliseconds} ms',
    );
  });
}
