import 'package:drift/drift.dart';

/// Samples imported from HealthKit or Health Connect. Never uploaded raw.
class HealthSamples extends Table {
  TextColumn get id => text()();

  /// `sleep`, `resting_hr`, `hrv`, `steps`, `menstrual_flow`.
  TextColumn get type => text()();
  DateTimeColumn get start => dateTime()();
  DateTimeColumn get end => dateTime()();
  RealColumn get value => real()();
  TextColumn get unit => text()();

  /// `healthkit` or `health_connect`.
  TextColumn get sourceStore => text()();

  /// Writing app or device, when the store reports it.
  TextColumn get sourceName => text().nullable()();
  DateTimeColumn get importedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {type, start, end, sourceStore},
  ];
}
