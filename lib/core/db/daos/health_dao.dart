import 'package:drift/drift.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/db/tables/health_samples.dart';

part 'health_dao.g.dart';

/// Reads and writes imported health samples.
@DriftAccessor(tables: [HealthSamples])
class HealthDao extends DatabaseAccessor<AppDatabase> with _$HealthDaoMixin {
  HealthDao(super.attachedDatabase);

  /// Samples of one type overlapping `[from, to)`, oldest first.
  Future<List<HealthSample>> ofType(String type, DateTime from, DateTime to) =>
      (select(healthSamples)
            ..where((h) => h.type.equals(type))
            ..where((h) => h.end.isBiggerThanValue(from))
            ..where((h) => h.start.isSmallerThanValue(to))
            ..orderBy([(h) => OrderingTerm.asc(h.start)]))
          .get();

  Future<DateTime?> latestEnd(String type) async {
    final max = healthSamples.end.max();
    final row =
        await (selectOnly(healthSamples)
              ..addColumns([max])
              ..where(healthSamples.type.equals(type)))
            .getSingle();
    return row.read(max);
  }

  /// Inserts samples, ignoring ones already present (same type, window and
  /// store).
  Future<void> insertAllIgnoringDuplicates(List<HealthSamplesCompanion> rows) =>
      batch((b) {
        b.insertAll(healthSamples, rows, mode: InsertMode.insertOrIgnore);
      });

  Future<int> deleteType(String type) =>
      (delete(healthSamples)..where((h) => h.type.equals(type))).go();

  Future<List<HealthSample>> all() => (select(
    healthSamples,
  )..orderBy([(h) => OrderingTerm.asc(h.start)])).get();
}
