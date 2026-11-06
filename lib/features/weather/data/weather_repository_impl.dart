import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/db/database_provider.dart';
import 'package:migraine_tracker/features/weather/domain/weather_entities.dart';
import 'package:migraine_tracker/features/weather/domain/weather_repository.dart';

final weatherRepositoryProvider = Provider<WeatherRepository>(
  (ref) => DriftWeatherRepository(ref.watch(appDatabaseProvider)),
);

/// Drift-backed [WeatherRepository].
class DriftWeatherRepository implements WeatherRepository {
  DriftWeatherRepository(this._db);

  final AppDatabase _db;

  static WeatherHourEntity _hour(WeatherHour r) => WeatherHourEntity(
    cell: r.cell,
    hourUtc: r.hourUtc.toUtc(),
    fetchedAt: r.fetchedAt.toUtc(),
    pressureMsl: r.pressureMsl,
    surfacePressure: r.surfacePressure,
    temperature: r.temperature,
    humidity: r.humidity,
    precipitation: r.precipitation,
    wind: r.wind,
    cloud: r.cloud,
    weatherCode: r.weatherCode,
    uv: r.uv,
    pinned: r.pinned,
  );

  static EnvironmentDayEntity _day(EnvironmentDay r) => EnvironmentDayEntity(
    date: r.date,
    cell: r.cell,
    fetchedAt: r.fetchedAt.toUtc(),
    aqiUs: r.aqiUs,
    aqiEu: r.aqiEu,
    pm25: r.pm25,
    pm10: r.pm10,
    ozone: r.ozone,
    pollen: r.pollen?.map((k, v) => MapEntry(k, (v as num).toDouble())),
    uvMax: r.uvMax,
    daylightMinutes: r.daylightMinutes,
    sunrise: r.sunrise?.toUtc(),
    sunset: r.sunset?.toUtc(),
  );

  @override
  Future<void> upsertHours(List<WeatherHourEntity> hours) async {
    if (hours.isEmpty) return;
    // Keep an existing pin: insertOnConflictUpdate would reset it.
    final pinned = <DateTime>{};
    for (final h in hours) {
      final existing = await _db.weatherDao.at(h.cell, h.hourUtc);
      if (existing?.pinned ?? false) pinned.add(h.hourUtc);
    }
    await _db.weatherDao.upsertAll([
      for (final h in hours)
        WeatherHoursCompanion(
          cell: Value(h.cell),
          hourUtc: Value(h.hourUtc.toUtc()),
          pressureMsl: Value(h.pressureMsl),
          surfacePressure: Value(h.surfacePressure),
          temperature: Value(h.temperature),
          humidity: Value(h.humidity),
          precipitation: Value(h.precipitation),
          wind: Value(h.wind),
          cloud: Value(h.cloud),
          weatherCode: Value(h.weatherCode),
          uv: Value(h.uv),
          fetchedAt: Value(h.fetchedAt.toUtc()),
          pinned: Value(h.pinned || pinned.contains(h.hourUtc)),
        ),
    ]);
  }

  @override
  Future<List<WeatherHourEntity>> hours(
    String cell,
    DateTime from,
    DateTime to,
  ) async => (await _db.weatherDao.series(
    cell,
    from.toUtc(),
    to.toUtc(),
  )).map(_hour).toList();

  @override
  Stream<List<WeatherHourEntity>> watchHours(
    String cell,
    DateTime from,
    DateTime to,
  ) => _db.weatherDao
      .watchSeries(cell, from.toUtc(), to.toUtc())
      .map((rows) => rows.map(_hour).toList());

  @override
  Future<WeatherHourEntity?> hourAt(String cell, DateTime hourUtc) async {
    final row = await _db.weatherDao.at(cell, hourUtc.toUtc());
    return row == null ? null : _hour(row);
  }

  @override
  Future<DateTime?> lastFetchedAt(String cell) async =>
      (await _db.weatherDao.lastFetchedAt(cell))?.toUtc();

  @override
  Future<void> pin(String cell, DateTime hourUtc) async {
    await _db.weatherDao.pin(cell, hourUtc.toUtc());
  }

  @override
  Future<int> prune(DateTime before) => _db.weatherDao.prune(before.toUtc());

  @override
  Future<void> upsertDays(List<EnvironmentDayEntity> days) async {
    if (days.isEmpty) return;
    await _db.environmentDao.upsertAll([
      for (final d in days)
        EnvironmentDaysCompanion(
          date: Value(d.date),
          cell: Value(d.cell),
          aqiUs: Value(d.aqiUs),
          aqiEu: Value(d.aqiEu),
          pm25: Value(d.pm25),
          pm10: Value(d.pm10),
          ozone: Value(d.ozone),
          pollen: Value(d.pollen),
          uvMax: Value(d.uvMax),
          daylightMinutes: Value(d.daylightMinutes),
          sunrise: Value(d.sunrise?.toUtc()),
          sunset: Value(d.sunset?.toUtc()),
          fetchedAt: Value(d.fetchedAt.toUtc()),
        ),
    ]);
  }

  @override
  Future<List<EnvironmentDayEntity>> days(String from, String to) async =>
      (await _db.environmentDao.inRange(from, to)).map(_day).toList();

  @override
  Stream<List<EnvironmentDayEntity>> watchDays(String from, String to) => _db
      .environmentDao
      .watchRange(from, to)
      .map((rows) => rows.map(_day).toList());
}
