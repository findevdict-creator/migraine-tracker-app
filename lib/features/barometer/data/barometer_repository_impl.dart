import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/db/database_provider.dart';
import 'package:migraine_tracker/features/barometer/domain/barometer_entities.dart';
import 'package:migraine_tracker/features/barometer/domain/barometer_repository.dart';

final barometerRepositoryProvider = Provider<BarometerRepository>(
  (ref) => DriftBarometerRepository(ref.watch(appDatabaseProvider)),
);

/// Drift-backed [BarometerRepository].
class DriftBarometerRepository implements BarometerRepository {
  DriftBarometerRepository(this._db);

  final AppDatabase _db;

  static PressureReading _reading(BarometerReading r) =>
      PressureReading(at: r.at.toUtc(), hpa: r.hpa);

  @override
  Future<void> add(PressureReading reading) =>
      _db.barometerDao.insert(reading.at.toUtc(), reading.hpa);

  @override
  Future<PressureReading?> latest() async {
    final row = await _db.barometerDao.latest();
    return row == null ? null : _reading(row);
  }

  @override
  Future<List<PressureReading>> series(DateTime from, DateTime to) async =>
      (await _db.barometerDao.series(
        from.toUtc(),
        to.toUtc(),
      )).map(_reading).toList();

  @override
  Stream<List<PressureReading>> watchSeries(DateTime from, DateTime to) => _db
      .barometerDao
      .watchSeries(from.toUtc(), to.toUtc())
      .map((rows) => rows.map(_reading).toList());

  @override
  Future<int> prune(DateTime before) => _db.barometerDao.prune(before.toUtc());
}
