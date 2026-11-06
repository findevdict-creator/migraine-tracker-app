import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/db/database_provider.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/attack_log/data/attack_repository_impl.dart';
import 'package:migraine_tracker/features/attack_log/presentation/attack_log_controller.dart';
import 'package:migraine_tracker/features/barometer/application/barometer_sampler.dart';
import 'package:migraine_tracker/features/barometer/data/barometer_repository_impl.dart';
import 'package:migraine_tracker/features/barometer/data/barometer_sources.dart';
import 'package:migraine_tracker/features/barometer/domain/barometer_entities.dart';
import 'package:migraine_tracker/features/barometer/domain/barometer_source.dart';
import 'package:migraine_tracker/features/barometer/presentation/barometer_controller.dart';
import 'package:migraine_tracker/features/weather/application/weather_sync.dart';
import 'package:migraine_tracker/features/weather/data/weather_sources.dart';
import 'package:migraine_tracker/features/weather/domain/weather_repository.dart';

import '../../support/test_database.dart';
import '../weather/support/weather_fakes.dart';
import 'support/barometer_fakes.dart';

void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late FakeBarometer barometer;
  var now = DateTime.utc(2026, 11, 6, 9, 30);

  setUp(() {
    now = DateTime.utc(2026, 11, 6, 9, 30);
    db = newTestDatabase();
    barometer = FakeBarometer();
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        clockProvider.overrideWithValue(() => now),
        barometerSourceProvider.overrideWithValue(barometer),
        weatherSourceProvider.overrideWithValue(
          FakeWeatherSource(weatherPayload(now: now)),
        ),
        locationSourceProvider.overrideWithValue(
          FakeLocationSource(const LocationFix(lat: 51.5, lon: -0.1)),
        ),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await barometer.close();
    await db.close();
  });

  Future<void> settle() =>
      Future<void>.delayed(const Duration(milliseconds: 20));

  test('sampler stores one reading per interval and prunes old ones', () async {
    // Watching the live provider starts the sampler.
    container.listen(liveReadingProvider, (_, _) {});
    final repo = container.read(barometerRepositoryProvider);
    barometer.emit(PressureReading(at: now, hpa: 1000));
    await settle();
    barometer.emit(
      PressureReading(at: now.add(const Duration(minutes: 1)), hpa: 1000.2),
    );
    await settle();
    expect(
      await repo.series(DateTime.utc(2026), DateTime.utc(2027)),
      hasLength(1),
    );

    final later = now.add(AppThresholds.barometerSampleInterval);
    barometer.emit(PressureReading(at: later, hpa: 1001));
    await settle();
    expect(
      await repo.series(DateTime.utc(2026), DateTime.utc(2027)),
      hasLength(2),
    );
    expect(container.read(liveReadingProvider).value?.hpa, 1001);

    // Jump past retention: the next sample prunes the old ones.
    now = now.add(AppThresholds.barometerRetention + const Duration(hours: 1));
    barometer.emit(PressureReading(at: now, hpa: 1002));
    await settle();
    final left = await repo.series(DateTime.utc(2026), DateTime.utc(2027));
    expect(left.map((r) => r.hpa), [1002]);
  });

  test('a device without a barometer leaves the live reading null', () async {
    final c = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        clockProvider.overrideWithValue(() => now),
        barometerSourceProvider.overrideWithValue(const NoBarometer()),
      ],
    );
    addTearDown(c.dispose);
    c
      ..listen(liveReadingProvider, (_, _) {})
      ..listen(barometerStateProvider, (_, _) {});
    await settle();
    expect(c.read(liveReadingProvider).value, isNull);
    final state = c.read(barometerStateProvider).value;
    expect(state?.origin, PressureOrigin.none);
  });

  test(
    'starting an attack stamps the live sensor and the station hour',
    () async {
      await container.read(weatherSyncProvider).refresh();
      container.listen(liveReadingProvider, (_, _) {});
      barometer.emit(PressureReading(at: now, hpa: 1001.4));
      await settle();

      final id = await container.read(attackStarterProvider).start();
      final attack = await container.read(attackRepositoryProvider).byId(id);
      expect(attack?.pressureSensorHpa, 1001.4);
      // Station value for 09:00 UTC in the fixture is 1013 + 48 * 0.5.
      expect(attack?.pressureStationHpa, 1037.0);
    },
  );

  test(
    'without a live reading a recent stored sample is used, a stale one is not',
    () async {
      final repo = container.read(barometerRepositoryProvider);
      await repo.add(
        PressureReading(
          at: now.subtract(const Duration(minutes: 10)),
          hpa: 999,
        ),
      );
      var id = await container.read(attackStarterProvider).start();
      var attack = await container.read(attackRepositoryProvider).byId(id);
      expect(attack?.pressureSensorHpa, 999);
      expect(attack?.pressureStationHpa, isNull);
      await container.read(attackRepositoryProvider).delete(id);

      now = now.add(
        AppThresholds.barometerStampMaxAge + const Duration(minutes: 1),
      );
      id = await container.read(attackStarterProvider).start();
      attack = await container.read(attackRepositoryProvider).byId(id);
      expect(attack?.pressureSensorHpa, isNull);
    },
  );

  test('state falls back to the station when the sensor is silent', () async {
    await container.read(weatherSyncProvider).refresh();
    container.listen(barometerStateProvider, (_, _) {});
    await settle();
    final state = container.read(barometerStateProvider).value;
    expect(state?.origin, PressureOrigin.station);
    expect(state?.displayHpa, 1037.0);
    expect(state?.calibration.isCalibrated, isFalse);
  });

  test('state calibrates the sensor once enough hourly pairs exist', () async {
    await container.read(weatherSyncProvider).refresh();
    final repo = container.read(barometerRepositoryProvider);
    // Station at 06, 07, 08 UTC is 1035.5, 1036, 1036.5; the sensor reads
    // 10 hPa low each hour.
    for (var h = 1; h <= 3; h++) {
      final at = now.subtract(Duration(hours: h));
      await repo.add(PressureReading(at: at, hpa: 1037 - h * 0.5 - 10));
    }
    container.listen(barometerStateProvider, (_, _) {});
    await settle();
    barometer.emit(PressureReading(at: now, hpa: 1027));
    await settle();
    final state = container.read(barometerStateProvider).value;
    expect(state?.origin, PressureOrigin.sensor);
    expect(state?.calibration.offset, 10.0);
    expect(state?.displayHpa, 1037.0);
    expect(state?.trend.length, greaterThanOrEqualTo(3));
  });
}
