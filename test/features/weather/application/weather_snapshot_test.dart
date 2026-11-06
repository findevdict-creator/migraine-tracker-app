import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/db/database_provider.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/attack_log/data/attack_repository_impl.dart';
import 'package:migraine_tracker/features/attack_log/presentation/attack_log_controller.dart';
import 'package:migraine_tracker/features/checkin/data/checkin_repository_impl.dart';
import 'package:migraine_tracker/features/checkin/domain/checkin_entity.dart';
import 'package:migraine_tracker/features/checkin/presentation/checkin_controller.dart';
import 'package:migraine_tracker/features/weather/application/weather_snapshot.dart';
import 'package:migraine_tracker/features/weather/application/weather_sync.dart';
import 'package:migraine_tracker/features/weather/data/weather_repository_impl.dart';
import 'package:migraine_tracker/features/weather/data/weather_sources.dart';
import 'package:migraine_tracker/features/weather/domain/weather_entities.dart';
import 'package:migraine_tracker/features/weather/domain/weather_repository.dart';

import '../../../support/test_database.dart';
import '../support/weather_fakes.dart';

void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late FakeWeatherSource source;
  final now = DateTime.utc(2026, 11, 6, 9, 30);

  setUp(() {
    db = newTestDatabase();
    source = FakeWeatherSource(weatherPayload(now: now));
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        clockProvider.overrideWithValue(() => now),
        weatherSourceProvider.overrideWithValue(source),
        locationSourceProvider.overrideWithValue(
          FakeLocationSource(const LocationFix(lat: 51.5, lon: -0.1)),
        ),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  test('snapshot is null until weather is cached', () async {
    expect(await container.read(weatherSnapshotProvider).now(), isNull);
  });

  test('snapshot carries the hour values and the deltas', () async {
    await container.read(weatherSyncProvider).refresh();
    final snap = await container.read(weatherSnapshotProvider).now();
    expect(snap, isNotNull);
    expect(snap!['cell'], '51.5,-0.1');
    expect(snap['hourUtc'], '2026-11-06T09:00:00.000Z');
    expect(snap['pressureMsl'], 1037.0);
    expect(snap['pressureNow'], 1037.0);
    expect(snap['delta3h'], 1.5);
    expect(snap['delta24h'], 12.0);
    expect(snap['temperature'], 10.0);
    expect(snap['fetchedAt'], now.toIso8601String());
  });

  test('starting an attack attaches the weather and pins the hour', () async {
    await container.read(weatherSyncProvider).refresh();
    final id = await container.read(attackStarterProvider).start();
    final attack = await container.read(attackRepositoryProvider).byId(id);
    expect(attack?.weather?['pressureMsl'], 1037.0);
    expect(attack?.weather?['delta6h'], 3.0);
    final hour = await container
        .read(weatherRepositoryProvider)
        .hourAt('51.5,-0.1', now.utcHour);
    expect(hour?.pinned, isTrue);
  });

  test('starting an attack with no cache leaves weather null', () async {
    final id = await container.read(attackStarterProvider).start();
    final attack = await container.read(attackRepositoryProvider).byId(id);
    expect(attack?.weather, isNull);
  });

  test('a check-in is stamped once, on its first save', () async {
    await container.read(weatherSyncProvider).refresh();
    final editor = container.read(checkinEditorProvider('2026-11-06').notifier);
    await container.read(checkinEditorProvider('2026-11-06').future);
    await editor.setValue(CheckinField.stress, 3);
    final first = await container
        .read(checkinRepositoryProvider)
        .byDate('2026-11-06');
    expect(first?.weather?['pressureMsl'], 1037.0);

    // Later edits keep the original stamp even if the cache moved on.
    await container.read(weatherRepositoryProvider).upsertHours([
      WeatherHourEntity(
        cell: '51.5,-0.1',
        hourUtc: now.utcHour,
        fetchedAt: now,
        pressureMsl: 999,
      ),
    ]);
    await editor.setValue(CheckinField.sleepQuality, 4);
    final second = await container
        .read(checkinRepositoryProvider)
        .byDate('2026-11-06');
    expect(second?.weather, first?.weather);
  });
}
