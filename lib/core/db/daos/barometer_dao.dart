import 'package:drift/drift.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/db/tables/barometer_readings.dart';

part 'barometer_dao.g.dart';

/// Reads and writes barometer samples.
@DriftAccessor(tables: [BarometerReadings])
class BarometerDao extends DatabaseAccessor<AppDatabase>
    with _$BarometerDaoMixin {
  BarometerDao(super.attachedDatabase);

  Future<void> insert(DateTime at, double hpa) => into(
    barometerReadings,
  ).insertOnConflictUpdate(BarometerReadingsCompanion.insert(at: at, hpa: hpa));

  Future<BarometerReading?> latest() =>
      (select(barometerReadings)
            ..orderBy([(r) => OrderingTerm.desc(r.at)])
            ..limit(1))
          .getSingleOrNull();

  /// Samples inside `[from, to)`, oldest first.
  Future<List<BarometerReading>> series(DateTime from, DateTime to) =>
      (select(barometerReadings)
            ..where((r) => r.at.isBiggerOrEqualValue(from))
            ..where((r) => r.at.isSmallerThanValue(to))
            ..orderBy([(r) => OrderingTerm.asc(r.at)]))
          .get();

  Stream<List<BarometerReading>> watchSeries(DateTime from, DateTime to) =>
      (select(barometerReadings)
            ..where((r) => r.at.isBiggerOrEqualValue(from))
            ..where((r) => r.at.isSmallerThanValue(to))
            ..orderBy([(r) => OrderingTerm.asc(r.at)]))
          .watch();

  Future<int> prune(DateTime before) => (delete(
    barometerReadings,
  )..where((r) => r.at.isSmallerThanValue(before))).go();
}
