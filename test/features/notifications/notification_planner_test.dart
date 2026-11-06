// ignore_for_file: avoid_redundant_argument_values, config owns these
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/features/notifications/domain/notification_planner.dart';
import 'package:migraine_tracker/features/notifications/domain/notification_types.dart';
import 'package:migraine_tracker/features/notifications/domain/planned_notification.dart';
import 'package:migraine_tracker/features/risk/domain/risk_entities.dart';
import 'package:risk_model/risk_model.dart';

void main() {
  final now = DateTime(2026, 11, 6, 9, 30);

  RiskDayEntity day(String date, RiskLevel level, {Factor? driver}) =>
      RiskDayEntity(
        date: date,
        level: level,
        score: level == RiskLevel.low ? 10 : 70,
        contributions: [
          if (driver != null)
            Contribution(
              factor: driver,
              exposure: 1,
              weight: 0.5,
              confidence: 0.4,
              points: 50,
            ),
        ],
        modelVersion: modelVersion,
        computedAt: now,
      );

  List<String> keys(List<PlannedNotification> plan) => [
    for (final n in plan) n.key,
  ];

  group('risk rising', () {
    test('fires the evening before and the morning of a rise', () {
      final plan = NotificationPlanner.plan(
        PlannerInput(
          now: now,
          enabled: const {NotificationType.riskRising},
          riskDays: [
            day('2026-11-06', RiskLevel.low),
            day('2026-11-07', RiskLevel.high, driver: Factor.pressureDrop),
            day('2026-11-08', RiskLevel.high),
          ],
        ),
      );
      expect(keys(plan), [
        'risk:2026-11-07:evening',
        'risk:2026-11-07:morning',
      ]);
      expect(plan.first.at, DateTime(2026, 11, 6, 20));
      expect(plan.last.at, DateTime(2026, 11, 7, 8));
      expect(plan.first.args, {'level': 'high', 'driver': 'pressure_drop'});
    });

    test('a rise today after the evening slot keeps only the morning when '
        'that is still ahead', () {
      final plan = NotificationPlanner.plan(
        PlannerInput(
          now: DateTime(2026, 11, 6, 7),
          enabled: const {NotificationType.riskRising},
          riskDays: [day('2026-11-06', RiskLevel.moderate)],
        ),
      );
      expect(keys(plan), ['risk:2026-11-06:morning']);
    });

    test('a missing previous day counts as low', () {
      final plan = NotificationPlanner.plan(
        PlannerInput(
          now: now,
          enabled: const {NotificationType.riskRising},
          riskDays: [day('2026-11-08', RiskLevel.moderate)],
        ),
      );
      expect(keys(plan), [
        'risk:2026-11-08:evening',
        'risk:2026-11-08:morning',
      ]);
    });

    test('switch off: nothing', () {
      final plan = NotificationPlanner.plan(
        PlannerInput(
          now: now,
          enabled: const {},
          riskDays: [day('2026-11-07', RiskLevel.high)],
        ),
      );
      expect(plan, isEmpty);
    });
  });

  group('pressure drop', () {
    final points = [
      PressureForecastPoint(hourLocal: DateTime(2026, 11, 6, 8), delta24h: -9),
      PressureForecastPoint(hourLocal: DateTime(2026, 11, 6, 14), delta24h: -3),
      PressureForecastPoint(hourLocal: DateTime(2026, 11, 6, 18), delta24h: -6),
      PressureForecastPoint(hourLocal: DateTime(2026, 11, 6, 20), delta24h: -7),
      PressureForecastPoint(hourLocal: DateTime(2026, 11, 7, 3), delta24h: -6),
    ];

    test('one alert per day at the first qualifying hour, past hours '
        'ignored, at the threshold counts', () {
      final plan = NotificationPlanner.plan(
        PlannerInput(
          now: now,
          enabled: const {NotificationType.pressureDrop},
          pressure: points,
          pressureThresholdHpa: 6,
        ),
      );
      expect(keys(plan), ['pressure:2026-11-06', 'pressure:2026-11-07']);
      expect(plan.first.args['hpa'], '6.0');
      expect(
        plan.first.args['time'],
        DateTime(2026, 11, 6, 18).toIso8601String(),
      );
      expect(plan.first.at, now.add(const Duration(minutes: 1)));
    });

    test('a higher threshold removes the alert', () {
      final plan = NotificationPlanner.plan(
        PlannerInput(
          now: now,
          enabled: const {NotificationType.pressureDrop},
          pressure: points,
          pressureThresholdHpa: 8,
        ),
      );
      expect(plan, isEmpty);
    });
  });

  group('attack over', () {
    test('due at start plus the typical duration', () {
      final plan = NotificationPlanner.plan(
        PlannerInput(
          now: now,
          enabled: const {NotificationType.attackOver},
          runningAttackId: 'a1',
          runningAttackStartedAt: DateTime(2026, 11, 6, 8),
          typicalAttackDuration: const Duration(hours: 4),
        ),
      );
      expect(keys(plan), ['attackOver:a1']);
      expect(plan.single.at, DateTime(2026, 11, 6, 12));
      expect(plan.single.payload, 'a1');
      expect(plan.single.withEndAttackAction, isTrue);
      expect(plan.single.args, {'duration': '240'});
    });

    test('an attack already past its typical length asks right away', () {
      final plan = NotificationPlanner.plan(
        PlannerInput(
          now: now,
          enabled: const {NotificationType.attackOver},
          runningAttackId: 'a1',
          runningAttackStartedAt: DateTime(2026, 11, 5, 20),
        ),
      );
      expect(plan.single.at, now.add(const Duration(minutes: 1)));
    });

    test('no running attack: nothing', () {
      final plan = NotificationPlanner.plan(
        PlannerInput(now: now, enabled: const {NotificationType.attackOver}),
      );
      expect(plan, isEmpty);
    });
  });

  group('daily reminders', () {
    test('check-in at the set time for each day ahead, skipping days that '
        'already have a check-in and times already past', () {
      final plan = NotificationPlanner.plan(
        PlannerInput(
          now: now,
          enabled: const {NotificationType.checkin},
          checkinTime: const TimeOfDay(hour: 9, minute: 0),
          checkedInDates: const {'2026-11-07'},
          horizonDays: 3,
        ),
      );
      expect(keys(plan), ['checkin:2026-11-08', 'checkin:2026-11-09']);
      expect(plan.first.at, DateTime(2026, 11, 8, 9));
    });

    test('medication at its own time, today included while ahead', () {
      final plan = NotificationPlanner.plan(
        PlannerInput(
          now: now,
          enabled: const {NotificationType.medication},
          medicationTime: const TimeOfDay(hour: 21, minute: 30),
          horizonDays: 1,
        ),
      );
      expect(keys(plan), ['medication:2026-11-06', 'medication:2026-11-07']);
      expect(plan.first.at, DateTime(2026, 11, 6, 21, 30));
    });
  });

  test('the plan is sorted by time across types', () {
    final plan = NotificationPlanner.plan(
      PlannerInput(
        now: now,
        enabled: NotificationType.values.toSet(),
        riskDays: [day('2026-11-07', RiskLevel.high)],
        runningAttackId: 'a1',
        runningAttackStartedAt: DateTime(2026, 11, 6, 9),
        horizonDays: 0,
      ),
    );
    final times = [for (final n in plan) n.at];
    expect(times, [...times]..sort());
    expect(plan.map((n) => n.type).toSet(), {
      NotificationType.riskRising,
      NotificationType.attackOver,
      NotificationType.checkin,
      NotificationType.medication,
    });
  });

  group('dedupe', () {
    final planned = [
      PlannedNotification(
        key: 'risk:2026-11-07:evening',
        type: NotificationType.riskRising,
        at: DateTime(2026, 11, 6, 20),
      ),
      PlannedNotification(
        key: 'pressure:2026-11-06',
        type: NotificationType.pressureDrop,
        at: now,
      ),
    ];

    test('a key delivered before now is dropped', () {
      final out = NotificationPlanner.dedupe(planned, {
        'pressure:2026-11-06': now.subtract(const Duration(hours: 1)),
      }, now);
      expect(keys(out), ['risk:2026-11-07:evening']);
    });

    test('a key recorded exactly at now counts as delivered', () {
      final out = NotificationPlanner.dedupe(planned, {
        'pressure:2026-11-06': now,
      }, now);
      expect(keys(out), ['risk:2026-11-07:evening']);
    });

    test('a key recorded for later was only pending: kept', () {
      final out = NotificationPlanner.dedupe(planned, {
        'risk:2026-11-07:evening': DateTime(2026, 11, 6, 20),
      }, now);
      expect(keys(out), ['risk:2026-11-07:evening', 'pressure:2026-11-06']);
    });

    test('prune keeps a week of history', () {
      final kept = NotificationPlanner.prune({
        'old': now.subtract(const Duration(days: 8)),
        'week': now.subtract(const Duration(days: 7)),
        'new': now,
      }, now);
      expect(kept.keys, ['week', 'new']);
    });
  });

  test('ids are stable and non-negative', () {
    final a = PlannedNotification(
      key: 'checkin:2026-11-06',
      type: NotificationType.checkin,
      at: now,
    );
    final b = PlannedNotification(
      key: 'checkin:2026-11-06',
      type: NotificationType.checkin,
      at: now.add(const Duration(hours: 1)),
    );
    expect(a.id, b.id);
    expect(a.id, isNonNegative);
    expect(NotificationType.fromCode('medication')!.defaultOn, isFalse);
    expect(NotificationType.fromCode('nope'), isNull);
  });
}
