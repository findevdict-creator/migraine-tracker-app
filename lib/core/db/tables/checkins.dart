import 'package:drift/drift.dart';
import 'package:migraine_tracker/core/db/converters.dart';

/// One row per calendar day. Mandatory fields are 1 to 5; the optional row is
/// nullable. `sources` marks each field as typed or imported.
class Checkins extends Table {
  /// Local calendar date as `yyyy-MM-dd`.
  TextColumn get date => text().withLength(min: 10, max: 10)();
  IntColumn get sleepQuality => integer().nullable()();
  IntColumn get stress => integer().nullable()();
  IntColumn get neckTension => integer().nullable()();
  IntColumn get caffeine => integer().nullable()();
  IntColumn get hydration => integer().nullable()();
  IntColumn get alcohol => integer().nullable()();
  IntColumn get cycleDay => integer().nullable()();
  IntColumn get lightExposure => integer().nullable()();
  IntColumn get screenExposure => integer().nullable()();

  /// Field name to source (`typed`, `healthkit`, `health_connect`).
  TextColumn get sources =>
      text().map(const JsonMapConverter()).withDefault(const Constant('{}'))();

  /// Snapshot of the hour's weather attached at save time.
  TextColumn get weather => text().map(const JsonMapConverter()).nullable()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {date};
}
