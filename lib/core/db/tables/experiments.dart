import 'package:drift/drift.dart';
import 'package:migraine_tracker/core/db/converters.dart';

/// Two-week experiments. One active at a time (enforced by the DAO).
class Experiments extends Table {
  TextColumn get id => text()();

  /// The single change under test, for example `cut_caffeine`.
  TextColumn get change => text()();
  DateTimeColumn get start => dateTime()();
  DateTimeColumn get end => dateTime().nullable()();

  /// Date to adherence (`true`/`false`).
  TextColumn get adherence =>
      text().map(const JsonMapConverter()).withDefault(const Constant('{}'))();
  TextColumn get result => text().map(const JsonMapConverter()).nullable()();

  /// `active`, `completed` or `abandoned`.
  TextColumn get status => text().withDefault(const Constant('active'))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
