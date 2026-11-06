import 'package:drift/drift.dart';
import 'package:migraine_tracker/core/db/converters.dart';

/// Daily environment factors (air quality, pollen, UV, daylight).
class EnvironmentDays extends Table {
  /// Local calendar date as `yyyy-MM-dd`.
  TextColumn get date => text().withLength(min: 10, max: 10)();
  TextColumn get cell => text()();
  RealColumn get aqiUs => real().nullable()();
  RealColumn get aqiEu => real().nullable()();
  RealColumn get pm25 => real().nullable()();
  RealColumn get pm10 => real().nullable()();
  RealColumn get ozone => real().nullable()();

  /// Pollen counts keyed by species; null outside Europe.
  TextColumn get pollen => text().map(const JsonMapConverter()).nullable()();
  RealColumn get uvMax => real().nullable()();
  IntColumn get daylightMinutes => integer().nullable()();
  DateTimeColumn get sunrise => dateTime().nullable()();
  DateTimeColumn get sunset => dateTime().nullable()();
  DateTimeColumn get fetchedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {date};
}
