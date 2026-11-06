import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/db/database_provider.dart';
import 'package:migraine_tracker/core/settings/settings_keys.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/checkin/data/checkin_repository_impl.dart';
import 'package:migraine_tracker/features/checkin/domain/checkin_entity.dart';
import 'package:migraine_tracker/features/checkin/presentation/checkin_controller.dart';

import '../../support/test_database.dart';

void main() {
  late AppDatabase db;
  late ProviderContainer container;
  final now = DateTime(2026, 11, 6, 21, 15);

  setUp(() {
    db = newTestDatabase();
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        clockProvider.overrideWithValue(() => now),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  test('back-fill dates are today and the previous six days', () {
    expect(container.read(backfillDatesProvider), [
      '2026-11-06',
      '2026-11-05',
      '2026-11-04',
      '2026-11-03',
      '2026-11-02',
      '2026-11-01',
      '2026-10-31',
    ]);
    expect(
      container.read(backfillDatesProvider).length,
      AppThresholds.checkinBackfillDays,
    );
  });

  group('CheckinEditor', () {
    test('each tap is saved as typed; same tap again clears', () async {
      await container.read(checkinEditorProvider('2026-11-06').future);
      final editor = container.read(
        checkinEditorProvider('2026-11-06').notifier,
      );
      await editor.toggleValue(CheckinField.sleepQuality, 4);
      await editor.toggleValue(CheckinField.stress, 2);
      await editor.toggleValue(CheckinField.neckTension, 1);
      var stored = (await container
          .read(checkinRepositoryProvider)
          .byDate('2026-11-06'))!;
      expect(stored.isComplete, isTrue);
      expect(stored.sources.values.toSet(), {CheckinSource.typed});

      await editor.toggleValue(CheckinField.stress, 2);
      stored = (await container
          .read(checkinRepositoryProvider)
          .byDate('2026-11-06'))!;
      expect(stored[CheckinField.stress], isNull);
      expect(stored.isComplete, isFalse);
    });

    test('edits a back-filled day without touching today', () async {
      await container.read(checkinEditorProvider('2026-11-02').future);
      await container
          .read(checkinEditorProvider('2026-11-02').notifier)
          .setValue(CheckinField.hydration, 5);
      final repo = container.read(checkinRepositoryProvider);
      expect((await repo.byDate('2026-11-02'))![CheckinField.hydration], 5);
      expect(await repo.byDate('2026-11-06'), isNull);
    });
  });

  group('CheckinReminderSetting', () {
    test('defaults to the config time and persists changes', () async {
      expect(
        await container.read(checkinReminderProvider.future),
        AppThresholds.defaultCheckinReminder,
      );
      await container
          .read(checkinReminderProvider.notifier)
          .set(const TimeOfDay(hour: 7, minute: 5));
      expect(
        await db.settingsDao.read<String>(SettingsKeys.checkinReminderTime),
        '07:05',
      );
      final fresh = ProviderContainer(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
      );
      addTearDown(fresh.dispose);
      expect(
        await fresh.read(checkinReminderProvider.future),
        const TimeOfDay(hour: 7, minute: 5),
      );
    });

    test('ignores malformed stored values', () {
      expect(CheckinReminderSetting.parseTime('25:00'), isNull);
      expect(CheckinReminderSetting.parseTime('7'), isNull);
      expect(CheckinReminderSetting.parseTime(null), isNull);
      expect(
        CheckinReminderSetting.parseTime('23:59'),
        const TimeOfDay(hour: 23, minute: 59),
      );
    });
  });
}
