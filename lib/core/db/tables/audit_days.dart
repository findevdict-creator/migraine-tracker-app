import 'package:drift/drift.dart';

/// The risk level as it was shown for each day, frozen for the accuracy
/// self-audit (phase 36). `risk_days` is rewritten with hindsight whenever
/// the model relearns; this table is not. It holds the last forecast made
/// before the day began or, when there was none, the first score on the
/// day itself.
class AuditDays extends Table {
  /// Local calendar date as `yyyy-MM-dd`.
  TextColumn get date => text().withLength(min: 10, max: 10)();

  /// `low`, `moderate` or `high`.
  TextColumn get level => text()();
  TextColumn get modelVersion => text()();
  DateTimeColumn get recordedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {date};
}
