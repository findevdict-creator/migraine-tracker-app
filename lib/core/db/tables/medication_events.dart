import 'package:drift/drift.dart';
import 'package:migraine_tracker/core/db/tables/attacks.dart';

/// Acute and preventive medication log. Feeds the overuse counter.
class MedicationEvents extends Table {
  TextColumn get id => text()();
  TextColumn get attackId =>
      text().nullable().references(Attacks, #id, onDelete: KeyAction.setNull)();
  TextColumn get name => text()();
  TextColumn get dose => text().nullable()();
  DateTimeColumn get takenAt => dateTime()();

  /// Relief at 2 hours: 0 none, 1 partial, 2 full. Null until answered.
  IntColumn get reliefAt2h => integer().nullable()();

  /// `acute` or `preventive`.
  TextColumn get kind => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
