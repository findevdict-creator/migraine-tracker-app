import 'package:drift/drift.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/db/tables/medication_events.dart';

part 'medication_dao.g.dart';

/// Reads and writes medication events.
@DriftAccessor(tables: [MedicationEvents])
class MedicationDao extends DatabaseAccessor<AppDatabase>
    with _$MedicationDaoMixin {
  MedicationDao(super.attachedDatabase);

  Future<MedicationEvent?> byId(String id) => (select(
    medicationEvents,
  )..where((m) => m.id.equals(id))).getSingleOrNull();

  Future<List<MedicationEvent>> forAttack(String attackId) =>
      (select(medicationEvents)
            ..where((m) => m.attackId.equals(attackId))
            ..orderBy([(m) => OrderingTerm.asc(m.takenAt)]))
          .get();

  Stream<List<MedicationEvent>> watchForAttack(String attackId) =>
      (select(medicationEvents)
            ..where((m) => m.attackId.equals(attackId))
            ..orderBy([(m) => OrderingTerm.asc(m.takenAt)]))
          .watch();

  Stream<List<MedicationEvent>> watchRange(DateTime from, DateTime to) =>
      (select(medicationEvents)
            ..where((m) => m.takenAt.isBiggerOrEqualValue(from))
            ..where((m) => m.takenAt.isSmallerThanValue(to))
            ..orderBy([(m) => OrderingTerm.asc(m.takenAt)]))
          .watch();

  Stream<List<MedicationEvent>> watchAll() => (select(
    medicationEvents,
  )..orderBy([(m) => OrderingTerm.desc(m.takenAt)])).watch();

  /// Events taken inside `[from, to)`, oldest first.
  Future<List<MedicationEvent>> inRange(DateTime from, DateTime to) =>
      (select(medicationEvents)
            ..where((m) => m.takenAt.isBiggerOrEqualValue(from))
            ..where((m) => m.takenAt.isSmallerThanValue(to))
            ..orderBy([(m) => OrderingTerm.asc(m.takenAt)]))
          .get();

  Future<List<MedicationEvent>> all() => (select(
    medicationEvents,
  )..orderBy([(m) => OrderingTerm.desc(m.takenAt)])).get();

  /// Distinct medication names, most recently used first, for suggestions.
  Future<List<String>> recentNames({int limit = 10}) async {
    final rows =
        await (selectOnly(medicationEvents, distinct: true)
              ..addColumns([
                medicationEvents.name,
                medicationEvents.takenAt.max(),
              ])
              ..groupBy([medicationEvents.name])
              ..orderBy([OrderingTerm.desc(medicationEvents.takenAt.max())])
              ..limit(limit))
            .get();
    return rows.map((r) => r.read(medicationEvents.name)!).toList();
  }

  Future<void> upsert(MedicationEventsCompanion event) =>
      into(medicationEvents).insertOnConflictUpdate(event);

  Future<int> deleteById(String id) =>
      (delete(medicationEvents)..where((m) => m.id.equals(id))).go();
}
