import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/features/attack_log/domain/attack_entity.dart';
import 'package:migraine_tracker/features/experiments/domain/experiment.dart';

void main() {
  final start = DateTime(2026, 11);
  final experiment = ExperimentEntity(
    id: 'e',
    change: ExperimentChange.cutCaffeine,
    start: start,
  );

  AttackEntity attack(
    String id,
    DateTime at, {
    int? intensity,
    Duration? lasted,
  }) => AttackEntity(
    id: id,
    startedAt: at,
    endedAt: lasted == null ? null : at.add(lasted),
    intensity: intensity,
  );

  test('splits attacks by start time into before and during', () {
    final attacks = [
      // Outside the before window: ignored.
      attack('old', start.subtract(const Duration(days: 15))),
      attack(
        'b1',
        start.subtract(const Duration(days: 14)),
        intensity: 8,
        lasted: const Duration(hours: 10),
      ),
      attack(
        'b2',
        start.subtract(const Duration(days: 7)),
        intensity: 6,
        lasted: const Duration(hours: 4),
      ),
      attack(
        'b3',
        start.subtract(const Duration(minutes: 1)),
        lasted: const Duration(hours: 6),
      ),
      attack('d1', start, intensity: 3, lasted: const Duration(hours: 2)),
      attack('d2', start.add(const Duration(days: 5)), intensity: 5),
      // After the window: ignored.
      attack('late', start.add(const Duration(days: 14))),
    ];
    final c = ExperimentComparison.build(
      experiment,
      attacks,
      start.add(const Duration(days: 20)),
    );
    expect(c.before.attacks, 3);
    expect(c.before.days, 14);
    expect(c.before.perWeek, 1.5);
    expect(c.before.meanIntensity, 7);
    expect(c.before.intensityCount, 2);
    // Median of 4, 6 and 10 hours.
    expect(c.before.medianDuration, const Duration(hours: 6));
    expect(c.before.durationCount, 3);

    expect(c.during.attacks, 2);
    expect(c.during.days, 14);
    expect(c.during.perWeek, 1);
    expect(c.during.meanIntensity, 4);
    // A running attack has no duration yet.
    expect(c.during.medianDuration, const Duration(hours: 2));
    expect(c.during.durationCount, 1);
    expect(c.small, isTrue);
  });

  test('mid-experiment, "during" covers only the days so far', () {
    final c = ExperimentComparison.build(experiment, [
      attack('d1', start.add(const Duration(days: 1))),
    ], start.add(const Duration(days: 3, hours: 2)));
    expect(c.during.days, 4);
    expect(c.during.perWeek, closeTo(1.75, 1e-9));
    expect(
      ExperimentComparison.build(experiment, const [], start).during.perWeek,
      isNull,
    );
  });

  test('even counts take the middle two for the median', () {
    final stats = PeriodStats.of([
      attack('a', start, lasted: const Duration(hours: 2)),
      attack('b', start, lasted: const Duration(hours: 5)),
    ], 14);
    expect(stats.medianDuration, const Duration(minutes: 210));
    expect(stats.meanIntensity, isNull);
  });

  test('"too few" below the threshold in either period', () {
    final many = [
      for (var i = 0; i < AppThresholds.experimentMinAttacks; i++)
        attack('$i', start.subtract(Duration(days: i + 1))),
    ];
    final during = [
      for (var i = 0; i < AppThresholds.experimentMinAttacks; i++)
        attack('d$i', start.add(Duration(days: i))),
    ];
    final now = start.add(const Duration(days: 14));
    expect(
      ExperimentComparison.build(experiment, [...many, ...during], now).small,
      isFalse,
    );
    expect(ExperimentComparison.build(experiment, many, now).small, isTrue);
  });

  test('a result survives storage', () {
    final c = ExperimentComparison.build(experiment, [
      attack(
        'b',
        start.subtract(const Duration(days: 2)),
        intensity: 7,
        lasted: const Duration(hours: 3),
      ),
    ], start.add(const Duration(days: 14)));
    final back = ExperimentComparison.fromJson(c.toJson());
    expect(back.before.attacks, 1);
    expect(back.before.meanIntensity, 7);
    expect(back.before.medianDuration, const Duration(hours: 3));
    expect(back.during.days, 14);
    expect(back.during.medianDuration, isNull);
  });

  test('day counter, due date and adherence', () {
    final e = experiment.copyWith(
      adherence: {'2026-11-01': true, '2026-11-02': false, '2026-11-03': true},
    );
    expect(e.dayOn(DateTime(2026, 11, 1, 23)), 1);
    expect(e.dayOn(DateTime(2026, 11, 3, 8)), 3);
    expect(e.dayOn(DateTime(2026, 12)), AppThresholds.experimentWindowDays);
    expect(e.isDueOn(DateTime(2026, 11, 14, 23)), isFalse);
    expect(e.isDueOn(DateTime(2026, 11, 15)), isTrue);
    expect(e.daysKept, 2);
    expect(ExperimentChange.fromCode('cut_caffeine'), e.change);
    expect(ExperimentStatus.fromCode('weird'), ExperimentStatus.abandoned);
  });
}
