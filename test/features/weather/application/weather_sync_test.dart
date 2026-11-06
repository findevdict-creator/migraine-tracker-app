import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/db/database_provider.dart';
import 'package:migraine_tracker/core/settings/settings_keys.dart';
import 'package:migraine_tracker/core/settings/settings_repository.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/weather/application/weather_sync.dart';
import 'package:migraine_tracker/features/weather/data/weather_repository_impl.dart';
import 'package:migraine_tracker/features/weather/data/weather_sources.dart';
import 'package:migraine_tracker/features/weather/domain/location_cell.dart';
import 'package:migraine_tracker/features/weather/domain/weather_repository.dart';

import '../../../support/test_database.dart';
import '../support/weather_fakes.dart';

void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late FakeWeatherSource source;
  late FakeLocationSource location;
  var now = DateTime.utc(2026, 11, 6, 9, 30);

  setUp(() {
    now = DateTime.utc(2026, 11, 6, 9, 30);
    db = newTestDatabase();
    source = FakeWeatherSource(weatherPayload(now: now));
    location = FakeLocationSource(
      const LocationFix(lat: 51.5074, lon: -0.1278),
    );
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        clockProvider.overrideWithValue(() => now),
        weatherSourceProvider.overrideWithValue(source),
        locationSourceProvider.overrideWithValue(location),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  WeatherSync sync() => container.read(weatherSyncProvider);
  WeatherRepository repo() => container.read(weatherRepositoryProvider);
  SettingsRepository settings() => container.read(settingsRepositoryProvider);

  test(
    'first refresh sends the rounded cell and stores hours and days',
    () async {
      final result = await sync().refresh();
      expect(result.fetched, isTrue);
      expect(result.mode, LocationMode.gps);
      expect(result.cell?.key, '51.5,-0.1');
      // Only the rounded cell ever leaves the device.
      expect(source.calls, [(51.5, -0.1)]);
      expect(
        await settings().read<String>(SettingsKeys.weatherLastCell),
        '51.5,-0.1',
      );
      final hours = await repo().hours(
        '51.5,-0.1',
        now.subtract(const Duration(days: 3)),
        now.add(const Duration(days: 3)),
      );
      expect(hours, hasLength(96));
      expect(await repo().days('2026-11-06', '2026-11-07'), hasLength(2));
      expect(await repo().lastFetchedAt('51.5,-0.1'), now);
    },
  );

  test(
    'skips the fetch while the cache is inside the foreground window',
    () async {
      await sync().refresh();
      now = now.add(
        AppThresholds.weatherForegroundRefresh - const Duration(minutes: 1),
      );
      final result = await sync().refresh();
      expect(result.fetched, isFalse);
      expect(result.error, isNull);
      expect(source.calls, hasLength(1));

      now = now.add(const Duration(minutes: 2));
      expect((await sync().refresh()).fetched, isTrue);
      expect(source.calls, hasLength(2));
    },
  );

  test('force refreshes inside the window', () async {
    await sync().refresh();
    expect((await sync().refresh(force: true)).fetched, isTrue);
    expect(source.calls, hasLength(2));
  });

  test('a failed fetch keeps the cached data and reports the error', () async {
    await sync().refresh();
    now = now.add(const Duration(hours: 4));
    source.error = Exception('airplane mode');
    final result = await sync().refresh();
    expect(result.fetched, isFalse);
    expect(result.error, contains('airplane mode'));
    final hours = await repo().hours(
      '51.5,-0.1',
      now.subtract(const Duration(days: 3)),
      now.add(const Duration(days: 3)),
    );
    expect(hours, hasLength(96));
  });

  test('prunes hours past retention but keeps pinned ones', () async {
    await sync().refresh();
    const cell = '51.5,-0.1';
    final oldHour = now.utcHour.subtract(const Duration(hours: 40));
    await repo().pin(cell, oldHour);
    // Move past retention; the new payload covers only recent hours.
    now = now.add(const Duration(days: AppThresholds.weatherRetentionDays + 1));
    source.payload = weatherPayload(now: now);
    await sync().refresh();
    final all = await repo().hours(
      cell,
      DateTime.utc(2026),
      DateTime.utc(2027),
    );
    final old = all.where(
      (h) => h.hourUtc.isBefore(
        now.subtract(const Duration(days: AppThresholds.weatherRetentionDays)),
      ),
    );
    expect(old.map((h) => h.hourUtc), [oldHour]);
    expect(old.single.pinned, isTrue);
  });

  test('re-fetching an hour keeps its pin', () async {
    await sync().refresh();
    const cell = '51.5,-0.1';
    await repo().pin(cell, now.utcHour);
    await sync().refresh(force: true);
    expect((await repo().hourAt(cell, now.utcHour))?.pinned, isTrue);
  });

  test('a manual city wins over the device location', () async {
    await sync().setManualLocation(
      ManualLocation(name: 'Paris', cell: LocationCell.from(48.8566, 2.3522)),
    );
    source.payload = weatherPayload(now: now, cell: '48.9,2.4');
    final result = await sync().refresh();
    expect(result.mode, LocationMode.manual);
    expect(source.calls, [(48.9, 2.4)]);
    expect((await sync().resolveLocation()).name, 'Paris');

    await sync().useDeviceLocation();
    expect((await sync().resolveLocation()).mode, LocationMode.gps);
  });

  test('without any fix or stored cell nothing is fetched', () async {
    location.fix = null;
    final result = await sync().refresh();
    expect(result.mode, LocationMode.none);
    expect(result.cell, isNull);
    expect(source.calls, isEmpty);
  });

  test('without a fix the last cell is reused so cached data stays', () async {
    await sync().refresh();
    location.fix = null;
    now = now.add(const Duration(hours: 4));
    final result = await sync().refresh();
    expect(result.mode, LocationMode.none);
    expect(result.cell?.key, '51.5,-0.1');
    expect(source.calls, hasLength(2));
  });
}
