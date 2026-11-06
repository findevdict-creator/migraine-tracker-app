import 'package:drift/drift.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/db/tables/attacks.dart';

part 'attack_dao.g.dart';

/// Reads and writes attack events.
@DriftAccessor(tables: [Attacks])
class AttackDao extends DatabaseAccessor<AppDatabase> with _$AttackDaoMixin {
  AttackDao(super.attachedDatabase);

  Future<Attack?> byId(String id) =>
      (select(attacks)..where((a) => a.id.equals(id))).getSingleOrNull();

  /// The attack that has started and not ended, if any.
  Future<Attack?> running() =>
      (select(attacks)
            ..where((a) => a.endedAt.isNull())
            ..orderBy([(a) => OrderingTerm.desc(a.startedAt)])
            ..limit(1))
          .getSingleOrNull();

  Stream<Attack?> watchRunning() =>
      (select(attacks)
            ..where((a) => a.endedAt.isNull())
            ..orderBy([(a) => OrderingTerm.desc(a.startedAt)])
            ..limit(1))
          .watchSingleOrNull();

  /// Attacks whose start falls inside `[from, to)`, newest first.
  Future<List<Attack>> inRange(DateTime from, DateTime to) =>
      (select(attacks)
            ..where((a) => a.startedAt.isBiggerOrEqualValue(from))
            ..where((a) => a.startedAt.isSmallerThanValue(to))
            ..orderBy([(a) => OrderingTerm.desc(a.startedAt)]))
          .get();

  Stream<List<Attack>> watchAll() => (select(
    attacks,
  )..orderBy([(a) => OrderingTerm.desc(a.startedAt)])).watch();

  Future<List<Attack>> all() =>
      (select(attacks)..orderBy([(a) => OrderingTerm.desc(a.startedAt)])).get();

  /// Completed attacks (with an end time), newest first.
  Future<List<Attack>> completed() =>
      (select(attacks)
            ..where((a) => a.endedAt.isNotNull())
            ..orderBy([(a) => OrderingTerm.desc(a.startedAt)]))
          .get();

  Future<int> count() {
    final c = attacks.id.count();
    return (selectOnly(
      attacks,
    )..addColumns([c])).getSingle().then((row) => row.read(c) ?? 0);
  }

  Future<void> upsert(AttacksCompanion attack) =>
      into(attacks).insertOnConflictUpdate(attack);

  Future<int> deleteById(String id) =>
      (delete(attacks)..where((a) => a.id.equals(id))).go();
}
