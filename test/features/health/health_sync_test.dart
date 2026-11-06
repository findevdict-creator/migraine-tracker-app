import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/db/database_provider.dart';
import 'package:migraine_tracker/core/settings/settings_keys.dart';
import 'package:migraine_tracker/core/settings/settings_repository.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/attack_log/presentation/attack_log_controller.dart';
import 'package:migraine_tracker/features/checkin/data/checkin_repository_impl.dart';
import 'package:migraine_tracker/features/checkin/domain/checkin_entity.dart';
import 'package:migraine_tracker/features/cycle/presentation/cycle_controller.dart';
import 'package:migraine_tracker/features/health/application/health_sync.dart';
import 'package:migraine_tracker/features/health/data/health_repository_impl.dart';
import 'package:migraine_tracker/features/health/data/health_source_impl.dart';
import 'package:migraine_tracker/features/health/domain/health_entities.dart';

import '../../support/test_database.dart';
import 'support/health_fakes.dart';

void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late FakeHealthSource source;
  // 2026-11-06 09:30 local; the test machine runs in UTC.
  var now = DateTime(2026, 11, 6, 9, 30);

  setUp(() {
    now = DateTime(2026, 11, 6, 9, 30);
    db = newTestDatabase();
    source = FakeHealthSource();
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        clockProvider.overrideWithValue(() => now),
        healthSourceProvider.overrideWithValue(source),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  HealthSync sync() => container.read(healthSyncProvider);
  SettingsRepository settings() => container.read(settingsRepositoryProvider);

  // Seven hours asleep last night (23:00 to 06:00) and five the night before.
  void seedSleep() {
    source.samples
      ..add(
        sample(
          HealthType.sleep,
          DateTime(2026, 11, 5, 23),
          const Duration(hours: 7),
          420,
        ),
      )
      ..add(
        sample(
          HealthType.sleep,
          DateTime(2026, 11, 4, 23),
          const Duration(hours: 5),
          300,
        ),
      );
  }

  test('consent asks the store, imports history once and stores it', () async {
    seedSleep();
    expect(await sync().setConsent(HealthType.sleep, allowed: true), isTrue);
    expect(source.readRequests, [
      {HealthType.sleep},
    ]);
    expect(source.historyRequests, 1);
    expect((await sync().consent()).allows(HealthType.sleep), isTrue);
    final (types, from, _) = source.reads.single;
    expect(types, {HealthType.sleep});
    expect(
      from,
      now.toUtc().subtract(
        const Duration(days: AppThresholds.healthImportDays),
      ),
    );
    final repo = container.read(healthRepositoryProvider);
    expect(
      await repo.ofType(HealthType.sleep, DateTime(2026), DateTime(2027)),
      hasLength(2),
    );
    expect(
      await settings().read<String>(SettingsKeys.healthLastImport),
      isNotNull,
    );
  });

  test('a denied request leaves consent off', () async {
    source.grantRead = false;
    expect(await sync().setConsent(HealthType.steps, allowed: true), isFalse);
    expect((await sync().consent()).any, isFalse);
    expect(source.reads, isEmpty);
  });

  test(
    'later imports start where the last sample ended and skip duplicates',
    () async {
      seedSleep();
      await sync().setConsent(HealthType.sleep, allowed: true);
      now = now.add(const Duration(days: 1));
      source.samples.add(
        sample(
          HealthType.sleep,
          DateTime(2026, 11, 6, 23),
          const Duration(hours: 6),
          360,
        ),
      );
      final result = await sync().sync();
      expect(source.reads.last.$2, DateTime(2026, 11, 6, 6).toUtc());
      // The fake returns overlapping samples; the store ignores known ones.
      expect(result.imported, greaterThanOrEqualTo(1));
      final repo = container.read(healthRepositoryProvider);
      expect(
        await repo.ofType(HealthType.sleep, DateTime(2026), DateTime(2027)),
        hasLength(3),
      );
    },
  );

  test(
    'sleep pre-fills the check-in with the store as source, never over typed',
    () async {
      seedSleep();
      final checkins = container.read(checkinRepositoryProvider);
      // Yesterday was typed by hand.
      await checkins.save(
        const CheckinEntity(date: '2026-11-05')
            .withValue(CheckinField.sleepQuality, 5, CheckinSource.typed),
      );
      final result = await sync()
          .setConsent(HealthType.sleep, allowed: true)
          .then((_) => sync().sync());
      expect(
        result.prefilledDays,
        0,
        reason: 'already filled by the consent call',
      );
      final today = await checkins.byDate('2026-11-06');
      expect(today?[CheckinField.sleepQuality], 3, reason: '420 min is band 3');
      expect(
        today?.sources[CheckinField.sleepQuality],
        CheckinSource.healthConnect,
      );
      final yesterday = await checkins.byDate('2026-11-05');
      expect(yesterday?[CheckinField.sleepQuality], 5);
      expect(
        yesterday?.sources[CheckinField.sleepQuality],
        CheckinSource.typed,
      );
    },
  );

  test('menstrual flow adds period starts when cycle tracking is on', () async {
    await container.read(cycleLogProvider).setEnabled(enabled: true);
    for (final day in [1, 2, 3, 20, 21]) {
      source.samples.add(
        sample(
          HealthType.menstrualFlow,
          DateTime(2026, 11, day, 8),
          const Duration(hours: 1),
          2,
        ),
      );
    }
    source.samples.add(
      sample(
        HealthType.menstrualFlow,
        DateTime(2026, 11, 4, 8),
        const Duration(hours: 1),
        0,
      ),
    );
    await sync().setConsent(HealthType.menstrualFlow, allowed: true);
    final starts = await settings().read<List<dynamic>>(
      SettingsKeys.cyclePeriodStarts,
    );
    expect(starts, ['2026-11-01']);
    // Idempotent on the next import.
    final again = await sync().sync();
    expect(again.periodStartsAdded, 0);
  });

  test('switching a type off deletes what was imported', () async {
    seedSleep();
    await sync().setConsent(HealthType.sleep, allowed: true);
    await sync().setConsent(HealthType.sleep, allowed: false);
    final repo = container.read(healthRepositoryProvider);
    expect(
      await repo.ofType(HealthType.sleep, DateTime(2026), DateTime(2027)),
      isEmpty,
    );
    expect((await sync().consent()).any, isFalse);
  });

  test('a failing store keeps what is there and reports the error', () async {
    seedSleep();
    await sync().setConsent(HealthType.sleep, allowed: true);
    source.readError = Exception('store busy');
    final result = await sync().sync();
    expect(result.error, contains('store busy'));
    final repo = container.read(healthRepositoryProvider);
    expect(
      await repo.ofType(HealthType.sleep, DateTime(2026), DateTime(2027)),
      hasLength(2),
    );
  });

  test('ending an attack writes a headache event only when opted in', () async {
    final starter = container.read(attackStarterProvider);
    var id = await starter.start();
    var editor = container.read(attackEditorProvider(id).notifier);
    await container.read(attackEditorProvider(id).future);
    await editor.end();
    expect(source.headaches, isEmpty);

    expect(await sync().setWriteHeadaches(enabled: true), isTrue);
    expect(source.writeRequests, 1);
    now = now.add(const Duration(hours: 2));
    id = await starter.start();
    editor = container.read(attackEditorProvider(id).notifier);
    await container.read(attackEditorProvider(id).future);
    await editor.setIntensity(8);
    now = now.add(const Duration(hours: 3));
    await editor.end();
    await editor.end();
    expect(source.headaches, hasLength(1));
    expect(source.headaches.single.$3, 8);
    expect(
      source.headaches.single.$2.difference(source.headaches.single.$1),
      const Duration(hours: 3),
    );
  });

  test('write-back stays off when the store refuses', () async {
    source.grantWrite = false;
    expect(await sync().setWriteHeadaches(enabled: true), isFalse);
    expect(
      await settings().read<bool>(SettingsKeys.healthWriteHeadaches),
      isFalse,
    );
  });
}
