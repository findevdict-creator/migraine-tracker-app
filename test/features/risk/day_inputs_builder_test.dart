import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/db/database_provider.dart';
import 'package:migraine_tracker/core/settings/settings_keys.dart';
import 'package:migraine_tracker/core/settings/settings_repository.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/health/data/health_repository_impl.dart';
import 'package:migraine_tracker/features/health/domain/health_entities.dart';
import 'package:migraine_tracker/features/risk/application/day_inputs_builder.dart';
import 'package:migraine_tracker/features/weather/data/weather_repository_impl.dart';
import 'package:migraine_tracker/features/weather/domain/weather_entities.dart';

import '../../support/test_database.dart';
import '../health/support/health_fakes.dart';
import 'support/risk_seed.dart';

void main() {
  late AppDatabase db;
  late ProviderContainer container;
  final now = DateTime(2026, 11, 6, 9, 30);

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

  DayInputsBuilder builder() => container.read(dayInputsBuilderProvider);

  test('no data at all gives no days', () async {
    expect(await builder().build('2026-11-01', '2026-11-06'), isEmpty);
    expect(await builder().build('2026-11-06', '2026-11-01'), isEmpty);
  });

  test('weather hours become pressure drop, humidity and swing', () async {
    await seedCell(container);
    // Day 0: flat 1020. Day 1: falls 0.5 hPa per hour from 1020 (drop of
    // 12 over the day's 24 h vs. the same hour the day before at the
    // last hour). Day 2: flat 1008.
    await seedHours(
      container,
      firstDay: DateTime(2026, 11, 3),
      days: 3,
      pressureAt: (i) =>
          i < 24 ? 1020 : (i < 48 ? 1020 - (i - 24) * 0.5 : 1008),
      humidityAt: (d) => [50.0, 80.0, 90.0][d],
      temperatureAt: (d) => [10.0, 16.0, 16.0][d],
      uv: 4,
    );
    final days = await builder().build('2026-11-03', '2026-11-05');
    expect(days.map((d) => d.date), ['2026-11-03', '2026-11-04', '2026-11-05']);
    final first = days[0];
    expect(first.pressureDelta24h, isNull); // nothing 24 h earlier
    expect(first.humidity, 50);
    expect(first.temperatureSwing, isNull);
    expect(first.uvMax, 4);
    final second = days[1];
    expect(second.pressureDelta24h, -11.5); // hour 23 of day 1 vs day 0
    expect(second.humidity, 80);
    expect(second.temperatureSwing, 6);
    final third = days[2];
    // Day 2 vs day 1: 1008 against values from 1020 down to 1008.5, so
    // the most negative change is at hour 0: 1008 - 1020 = -12.
    expect(third.pressureDelta24h, -12);
    expect(third.temperatureSwing, 0);
  });

  test('environment day, check-in, sleep and cycle fill the rest', () async {
    await seedCell(container);
    await container.read(weatherRepositoryProvider).upsertDays([
      EnvironmentDayEntity(
        date: '2026-11-06',
        cell: testCell,
        fetchedAt: now,
        aqiUs: 120,
        pollen: const {'grass': 30, 'birch': 75},
        uvMax: 6,
      ),
    ]);
    await seedCheckin(
      container,
      '2026-11-06',
      stress: 5,
      sleepQuality: 2,
      neckTension: 4,
      caffeine: 3,
      alcohol: 1,
      hydration: 2,
      lightExposure: 4,
      screenExposure: 5,
    );
    await container.read(healthRepositoryProvider).insertAll([
      sample(
        HealthType.sleep,
        DateTime(2026, 11, 5, 23),
        const Duration(hours: 4),
        240,
      ),
      sample(
        HealthType.sleep,
        DateTime(2026, 11, 6, 3, 30),
        const Duration(hours: 3),
        180,
      ),
    ]);
    final settings = container.read(settingsRepositoryProvider);
    await settings.write(SettingsKeys.cycleTrackingEnabled, true);
    await settings.write(SettingsKeys.cyclePeriodStarts, ['2026-10-12']);

    final days = await builder().build('2026-11-06', '2026-11-06');
    final d = days.single;
    expect(d.aqiUs, 120);
    expect(d.pollenMax, 75);
    expect(d.uvMax, 6);
    expect(d.stress, 5);
    expect(d.sleepQuality, 2);
    expect(d.neckTension, 4);
    expect(d.caffeine, 3);
    expect(d.alcohol, 1);
    expect(d.hydration, 2);
    expect(d.lightExposure, 4);
    expect(d.screenExposure, 5);
    expect(d.sleepMinutes, 420);
    // 2026-10-12 + 25 days = day 26 of a default-length cycle.
    expect(d.cycleDay, 26);
    expect(d.cycleLength, isNotNull);
    expect(d.pressureDelta24h, isNull);
  });

  test('a stamped cycle day on the check-in wins; tracking off gives '
      'nothing', () async {
    await seedCheckin(container, '2026-11-06', stress: 3, cycleDay: 4);
    final settings = container.read(settingsRepositoryProvider);
    await settings.write(SettingsKeys.cycleTrackingEnabled, true);
    await settings.write(SettingsKeys.cyclePeriodStarts, ['2026-10-12']);
    var d = (await builder().build('2026-11-06', '2026-11-06')).single;
    expect(d.cycleDay, 4);
    expect(d.cycleLength, isNotNull);

    await settings.write(SettingsKeys.cycleTrackingEnabled, false);
    d = (await builder().build('2026-11-06', '2026-11-06')).single;
    expect(d.cycleDay, 4);
    expect(d.cycleLength, isNull);
  });
}
