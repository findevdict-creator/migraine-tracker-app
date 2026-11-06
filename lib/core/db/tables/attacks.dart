import 'package:drift/drift.dart';
import 'package:migraine_tracker/core/db/converters.dart';

/// One row per attack event. Phases are columns, never separate rows.
class Attacks extends Table {
  TextColumn get id => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();

  /// 0 to 10. Null until the user answers.
  IntColumn get intensity => integer().nullable()();

  /// Head map region codes, for example `["left_temple", "behind_eyes"]`.
  TextColumn get headLocations => text()
      .map(const StringListConverter())
      .withDefault(const Constant('[]'))();

  /// Phase timestamps as ISO-8601 strings keyed by phase name
  /// (`prodrome`, `aura`, `attack`, `postdrome`).
  TextColumn get phases =>
      text().map(const JsonMapConverter()).withDefault(const Constant('{}'))();

  /// Symptom chips with their own tap timestamps:
  /// `[{"code": "aura", "at": "2026-11-06T08:00:00Z"}]`.
  TextColumn get symptoms =>
      text().map(const JsonListConverter()).withDefault(const Constant('[]'))();

  TextColumn get notes => text().nullable()();

  /// Phone barometer reading at start, hPa. Null without a sensor.
  RealColumn get pressureSensorHpa => real().nullable()();

  /// Nearest-station (feed) pressure at start, hPa.
  RealColumn get pressureStationHpa => real().nullable()();

  /// Snapshot of the hour's weather attached at save time.
  TextColumn get weather => text().map(const JsonMapConverter()).nullable()();

  /// True while the user chose "finish later" and has not completed the log.
  BoolColumn get finishLater => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
