import 'package:drift/drift.dart';

/// Key-value settings: units, reminder times, thresholds, enabled factors,
/// locale and consent flags per data type. Values are JSON-encoded.
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}
