import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/db/database_provider.dart';
import 'package:migraine_tracker/features/health/domain/health_entities.dart';
import 'package:migraine_tracker/features/health/domain/health_repository.dart';

final healthRepositoryProvider = Provider<HealthRepository>(
  (ref) => DriftHealthRepository(ref.watch(appDatabaseProvider)),
);

/// Drift-backed [HealthRepository] over the `health_samples` table.
class DriftHealthRepository implements HealthRepository {
  DriftHealthRepository(this._db);

  final AppDatabase _db;

  static HealthSampleEntity? _entity(HealthSample r) {
    final type = HealthType.fromCode(r.type);
    final store = HealthStore.fromCode(r.sourceStore);
    if (type == null || store == null) return null;
    return HealthSampleEntity(
      id: r.id,
      type: type,
      start: r.start.toUtc(),
      end: r.end.toUtc(),
      value: r.value,
      store: store,
      sourceName: r.sourceName,
      importedAt: r.importedAt.toUtc(),
    );
  }

  @override
  Future<void> insertAll(List<HealthSampleEntity> samples) async {
    if (samples.isEmpty) return;
    await _db.healthDao.insertAllIgnoringDuplicates([
      for (final s in samples)
        HealthSamplesCompanion.insert(
          id: s.id,
          type: s.type.code,
          start: s.start.toUtc(),
          end: s.end.toUtc(),
          value: s.value,
          unit: s.type.unit,
          sourceStore: s.store.code,
          sourceName: Value(s.sourceName),
          importedAt: s.importedAt.toUtc(),
        ),
    ]);
  }

  @override
  Future<DateTime?> latestEnd(HealthType type) async =>
      (await _db.healthDao.latestEnd(type.code))?.toUtc();

  @override
  Future<List<HealthSampleEntity>> ofType(
    HealthType type,
    DateTime from,
    DateTime to,
  ) async => (await _db.healthDao.ofType(
    type.code,
    from.toUtc(),
    to.toUtc(),
  )).map(_entity).nonNulls.toList();

  @override
  Future<int> deleteType(HealthType type) =>
      _db.healthDao.deleteType(type.code);
}
