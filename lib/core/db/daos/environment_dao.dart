import 'package:drift/drift.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/db/tables/environment_days.dart';

part 'environment_dao.g.dart';

/// Reads and writes daily environment factors.
@DriftAccessor(tables: [EnvironmentDays])
class EnvironmentDao extends DatabaseAccessor<AppDatabase>
    with _$EnvironmentDaoMixin {
  EnvironmentDao(super.attachedDatabase);

  Future<EnvironmentDay?> byDate(String date) => (select(
    environmentDays,
  )..where((e) => e.date.equals(date))).getSingleOrNull();

  Future<List<EnvironmentDay>> inRange(String from, String to) =>
      (select(environmentDays)
            ..where((e) => e.date.isBetweenValues(from, to))
            ..orderBy([(e) => OrderingTerm.asc(e.date)]))
          .get();

  Stream<List<EnvironmentDay>> watchRange(String from, String to) =>
      (select(environmentDays)
            ..where((e) => e.date.isBetweenValues(from, to))
            ..orderBy([(e) => OrderingTerm.asc(e.date)]))
          .watch();

  Future<void> upsertAll(List<EnvironmentDaysCompanion> rows) => batch((b) {
    b.insertAllOnConflictUpdate(environmentDays, rows);
  });

  Future<List<EnvironmentDay>> all() => (select(
    environmentDays,
  )..orderBy([(e) => OrderingTerm.asc(e.date)])).get();
}
