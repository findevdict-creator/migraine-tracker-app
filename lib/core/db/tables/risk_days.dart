import 'package:drift/drift.dart';
import 'package:migraine_tracker/core/db/converters.dart';

/// Daily risk output, stored so the self-audit can compare it with what
/// happened.
class RiskDays extends Table {
  /// Local calendar date as `yyyy-MM-dd`.
  TextColumn get date => text().withLength(min: 10, max: 10)();

  /// `low`, `moderate` or `high`.
  TextColumn get level => text()();
  RealColumn get score => real()();

  /// Top drivers: `[{"factor": "pressure_drop", "contribution": 62}]`.
  TextColumn get drivers =>
      text().map(const JsonListConverter()).withDefault(const Constant('[]'))();
  TextColumn get modelVersion => text()();
  DateTimeColumn get computedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {date};
}
