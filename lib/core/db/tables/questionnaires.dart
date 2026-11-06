import 'package:drift/drift.dart';
import 'package:migraine_tracker/core/db/converters.dart';

/// MIDAS and HIT-6 responses, charted over time.
class Questionnaires extends Table {
  TextColumn get id => text()();

  /// `midas` or `hit6`.
  TextColumn get type => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get answers => text().map(const JsonMapConverter())();
  IntColumn get score => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
