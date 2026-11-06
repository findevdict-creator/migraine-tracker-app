import 'package:drift/drift.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/db/tables/checkins.dart';

part 'checkin_dao.g.dart';

/// Reads and writes daily check-ins. Dates are `yyyy-MM-dd` strings.
@DriftAccessor(tables: [Checkins])
class CheckinDao extends DatabaseAccessor<AppDatabase> with _$CheckinDaoMixin {
  CheckinDao(super.attachedDatabase);

  Future<Checkin?> byDate(String date) =>
      (select(checkins)..where((c) => c.date.equals(date))).getSingleOrNull();

  Stream<Checkin?> watchByDate(String date) =>
      (select(checkins)..where((c) => c.date.equals(date))).watchSingleOrNull();

  /// Check-ins with `from <= date <= to`, oldest first.
  Future<List<Checkin>> inRange(String from, String to) =>
      (select(checkins)
            ..where((c) => c.date.isBetweenValues(from, to))
            ..orderBy([(c) => OrderingTerm.asc(c.date)]))
          .get();

  Stream<List<Checkin>> watchRange(String from, String to) =>
      (select(checkins)
            ..where((c) => c.date.isBetweenValues(from, to))
            ..orderBy([(c) => OrderingTerm.asc(c.date)]))
          .watch();

  Future<List<Checkin>> all() =>
      (select(checkins)..orderBy([(c) => OrderingTerm.asc(c.date)])).get();

  Future<void> upsert(CheckinsCompanion checkin) =>
      into(checkins).insertOnConflictUpdate(checkin);

  Future<int> deleteByDate(String date) =>
      (delete(checkins)..where((c) => c.date.equals(date))).go();
}
