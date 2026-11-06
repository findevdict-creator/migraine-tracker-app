import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/core/settings/settings_keys.dart';
import 'package:migraine_tracker/core/settings/settings_repository.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/checkin/data/checkin_repository_impl.dart';
import 'package:migraine_tracker/features/checkin/domain/checkin_entity.dart';
import 'package:migraine_tracker/features/weather/data/weather_repository_impl.dart';
import 'package:migraine_tracker/features/weather/domain/weather_entities.dart';

const String testCell = '51.5,-0.1';

/// Points the weather store at [testCell].
Future<void> seedCell(ProviderContainer c) => c
    .read(settingsRepositoryProvider)
    .write(SettingsKeys.weatherLastCell, testCell);

/// Hourly weather for [days] local days starting at [firstDay] (local
/// midnight). Pressure follows [pressureAt]; humidity and temperature
/// follow the given per-day functions.
Future<void> seedHours(
  ProviderContainer c, {
  required DateTime firstDay,
  required int days,
  required double Function(int hourIndex) pressureAt,
  double Function(int dayIndex)? humidityAt,
  double Function(int dayIndex)? temperatureAt,
  double? uv,
}) async {
  final hours = <WeatherHourEntity>[];
  for (var i = 0; i < days * 24; i++) {
    final at = firstDay.add(Duration(hours: i));
    hours.add(
      WeatherHourEntity(
        cell: testCell,
        hourUtc: at.utcHour,
        fetchedAt: firstDay,
        pressureMsl: pressureAt(i),
        humidity: humidityAt?.call(i ~/ 24),
        temperature: temperatureAt?.call(i ~/ 24),
        uv: uv,
      ),
    );
  }
  await c.read(weatherRepositoryProvider).upsertHours(hours);
}

Future<void> seedCheckin(
  ProviderContainer c,
  String date, {
  int? stress,
  int? sleepQuality,
  int? neckTension,
  int? caffeine,
  int? alcohol,
  int? hydration,
  int? lightExposure,
  int? screenExposure,
  int? cycleDay,
}) {
  final values = <CheckinField, int>{
    CheckinField.stress: ?stress,
    CheckinField.sleepQuality: ?sleepQuality,
    CheckinField.neckTension: ?neckTension,
    CheckinField.caffeine: ?caffeine,
    CheckinField.alcohol: ?alcohol,
    CheckinField.hydration: ?hydration,
    CheckinField.lightExposure: ?lightExposure,
    CheckinField.screenExposure: ?screenExposure,
  };
  return c
      .read(checkinRepositoryProvider)
      .save(
        CheckinEntity(
          date: date,
          values: values,
          sources: {for (final f in values.keys) f: CheckinSource.typed},
          cycleDay: cycleDay,
        ),
      );
}
