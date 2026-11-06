import 'package:drift/drift.dart';

/// Hourly weather per 0.1-degree cell. Rolling 14 days, except hours pinned
/// to an attack, which are kept forever.
class WeatherHours extends Table {
  /// Cell key, for example `51.5,-0.1`.
  TextColumn get cell => text()();
  DateTimeColumn get hourUtc => dateTime()();
  RealColumn get pressureMsl => real().nullable()();
  RealColumn get surfacePressure => real().nullable()();
  RealColumn get temperature => real().nullable()();
  RealColumn get humidity => real().nullable()();
  RealColumn get precipitation => real().nullable()();
  RealColumn get wind => real().nullable()();
  RealColumn get cloud => real().nullable()();
  IntColumn get weatherCode => integer().nullable()();
  RealColumn get uv => real().nullable()();
  TextColumn get source => text().withDefault(const Constant('open-meteo'))();
  DateTimeColumn get fetchedAt => dateTime()();
  BoolColumn get pinned => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {cell, hourUtc};
}
