// ignore_for_file: avoid_redundant_argument_values, config owns these
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/db/app_database.dart'
    hide FactorWeight, RiskDay;
import 'package:migraine_tracker/core/db/database_provider.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/settings/settings_keys.dart';
import 'package:migraine_tracker/core/settings/settings_repository.dart';
import 'package:migraine_tracker/core/units/units.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/attack_log/data/attack_repository_impl.dart';
import 'package:migraine_tracker/features/attack_log/domain/attack_entity.dart';
import 'package:migraine_tracker/features/notifications/application/notification_scheduler.dart';
import 'package:migraine_tracker/features/notifications/data/local_notification_gateway.dart';
import 'package:migraine_tracker/features/notifications/domain/notification_types.dart';
import 'package:migraine_tracker/features/notifications/domain/planned_notification.dart';
import 'package:migraine_tracker/features/risk/data/risk_repository_impl.dart';
import 'package:risk_model/risk_model.dart';

import '../../support/test_database.dart';
import '../risk/support/risk_seed.dart';
import 'support/fake_gateway.dart';

void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late RecordingGateway gateway;
  final now = DateTime(2026, 11, 6, 9, 30);

  setUp(() {
    db = newTestDatabase();
    gateway = RecordingGateway();
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        clockProvider.overrideWithValue(() => now),
        notificationGatewayProvider.overrideWithValue(gateway),
        deviceRegionProvider.overrideWithValue(null),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  NotificationScheduler scheduler() =>
      container.read(notificationSchedulerProvider);

  Future<void> storeRisk(String date, RiskLevel level) =>
      container.read(riskRepositoryProvider).saveRisk([
        DayRisk(
          date: date,
          load: level == RiskLevel.low ? 5 : 70,
          level: level,
          contributions: const [
            Contribution(
              factor: Factor.stress,
              exposure: 1,
              weight: 0.5,
              confidence: 0.3,
              points: 50,
            ),
          ],
          confidence: 0.3,
          coverage: 0.1,
          version: modelVersion,
        ),
      ], now: now);

  test('defaults: everything but medication is on', () async {
    for (final t in NotificationType.values) {
      expect(await scheduler().isEnabled(t), t != NotificationType.medication);
    }
    expect(
      await scheduler().pressureThreshold(),
      AppThresholds.defaultPressureDropAlertHpa,
    );
    expect(
      await scheduler().medicationTime(),
      AppThresholds.defaultMedicationReminder,
    );
  });

  test('settings round-trip', () async {
    await scheduler().setEnabled(NotificationType.checkin, enabled: false);
    await scheduler().setPressureThreshold(4);
    await scheduler().setMedicationTime(const TimeOfDay(hour: 7, minute: 15));
    expect(await scheduler().isEnabled(NotificationType.checkin), isFalse);
    expect(await scheduler().pressureThreshold(), 4);
    expect(
      await scheduler().medicationTime(),
      const TimeOfDay(hour: 7, minute: 15),
    );
  });

  test('reschedule cancels, plans from the stores and renders copy', () async {
    await storeRisk('2026-11-06', RiskLevel.low);
    await storeRisk('2026-11-07', RiskLevel.high);
    await seedCell(container);
    // Pressure falls 8 hPa between yesterday and today's afternoon.
    await seedHours(
      container,
      firstDay: DateTime(2026, 11, 5),
      days: 3,
      pressureAt: (i) => i < 24 ? 1015 : (i < 40 ? 1013 : 1007),
    );
    await container
        .read(attackRepositoryProvider)
        .save(AttackEntity(id: 'run', startedAt: now));
    await seedCheckin(container, '2026-11-06', stress: 2);

    final plan = await scheduler().reschedule();
    expect(gateway.cancels, 1);
    final keys = plan.map((n) => n.key).toList();
    expect(keys, contains('risk:2026-11-07:evening'));
    expect(keys, contains('risk:2026-11-07:morning'));
    expect(keys, contains('pressure:2026-11-06'));
    expect(keys, contains('attackOver:run'));
    expect(keys, isNot(contains('checkin:2026-11-06')));
    expect(keys, contains('checkin:2026-11-07'));
    expect(keys.where((k) => k.startsWith('medication')), isEmpty);
    expect(gateway.keys, keys);

    final evening = gateway.scheduled.firstWhere(
      (s) => s.$1.key == 'risk:2026-11-07:evening',
    );
    expect(evening.$2.title, "Tomorrow's level: High");
    expect(evening.$2.body, contains('Stress'));
    final pressure = gateway.scheduled.firstWhere(
      (s) => s.$1.key == 'pressure:2026-11-06',
    );
    expect(pressure.$2.body, contains('8.0 hPa'));
    final over = gateway.scheduled.firstWhere(
      (s) => s.$1.key == 'attackOver:run',
    );
    expect(over.$2.body, contains('4 h 0 min'));

    final sent = await container
        .read(settingsRepositoryProvider)
        .read<Map<String, dynamic>>(SettingsKeys.notificationSentKeys);
    expect(sent!.keys, containsAll(keys));
  });

  test('a key already delivered is not scheduled again, and the record '
      'is pruned', () async {
    await storeRisk('2026-11-07', RiskLevel.moderate);
    await container.read(settingsRepositoryProvider).write(
      SettingsKeys.notificationSentKeys,
      {
        'risk:2026-11-07:evening': now
            .subtract(const Duration(minutes: 5))
            .toIso8601String(),
        'ancient': now.subtract(const Duration(days: 30)).toIso8601String(),
      },
    );
    final plan = await scheduler().reschedule();
    expect(plan.map((n) => n.key), isNot(contains('risk:2026-11-07:evening')));
    expect(plan.map((n) => n.key), contains('risk:2026-11-07:morning'));
    final sent = await container
        .read(settingsRepositoryProvider)
        .read<Map<String, dynamic>>(SettingsKeys.notificationSentKeys);
    expect(sent!.containsKey('ancient'), isFalse);
    expect(sent.containsKey('risk:2026-11-07:evening'), isTrue);
  });

  test('every switch off gives an empty plan', () async {
    for (final t in NotificationType.values) {
      await scheduler().setEnabled(t, enabled: false);
    }
    await storeRisk('2026-11-07', RiskLevel.high);
    expect(await scheduler().reschedule(), isEmpty);
    expect(gateway.cancels, 1);
  });

  test('typical attack duration is the median once enough attacks '
      'are logged', () async {
    final repo = container.read(attackRepositoryProvider);
    expect(
      await scheduler().typicalAttackDuration(),
      AppThresholds.defaultAttackDuration,
    );
    for (var i = 0; i < AppThresholds.attacksBeforeDurationEstimate; i++) {
      final start = now.subtract(Duration(days: i + 1));
      await repo.save(
        AttackEntity(
          id: 'a$i',
          startedAt: start,
          endedAt: start.add(Duration(hours: 1 + i)),
        ),
      );
    }
    final median = await scheduler().typicalAttackDuration();
    expect(
      median.inHours,
      1 + AppThresholds.attacksBeforeDurationEstimate ~/ 2,
    );
  });

  test('concurrent reschedules run one after the other', () async {
    await storeRisk('2026-11-07', RiskLevel.high);
    final results = await Future.wait([
      scheduler().reschedule(),
      scheduler().reschedule(),
      scheduler().reschedule(),
    ]);
    expect(gateway.cancels, 3);
    // The gateway holds exactly one plan, not three interleaved ones.
    expect(gateway.keys, results.last.map((n) => n.key));
    expect(gateway.keys.toSet().length, gateway.keys.length);
  });

  test('render covers every type', () {
    final l10n = lookupAppLocalizations(AppLocales.fallback);
    for (final t in NotificationType.values) {
      final copy = NotificationScheduler.render(
        l10n,
        PlannedNotification(key: '${t.code}:x', type: t, at: now),
      );
      expect(copy.title, isNotEmpty);
      expect(copy.body, isNotEmpty);
    }
  });
}
