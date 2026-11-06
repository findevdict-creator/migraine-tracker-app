import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/db/database_provider.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/medication/domain/medication_entity.dart';
import 'package:migraine_tracker/features/medication/domain/medication_repository.dart';

final medicationRepositoryProvider = Provider<MedicationRepository>(
  (ref) => DriftMedicationRepository(
    ref.watch(appDatabaseProvider),
    clock: ref.watch(clockProvider),
  ),
);

/// Row to entity and back.
abstract final class MedicationMapper {
  static MedicationEntity toEntity(MedicationEvent row) => MedicationEntity(
    id: row.id,
    attackId: row.attackId,
    name: row.name,
    dose: row.dose,
    takenAt: row.takenAt,
    reliefAt2h: Relief.fromCode(row.reliefAt2h),
    kind: MedicationKind.fromCode(row.kind),
  );

  static MedicationEventsCompanion toCompanion(
    MedicationEntity e, {
    required DateTime now,
    DateTime? createdAt,
  }) => MedicationEventsCompanion(
    id: Value(e.id),
    attackId: Value(e.attackId),
    name: Value(e.name),
    dose: Value(e.dose),
    takenAt: Value(e.takenAt),
    reliefAt2h: Value(e.reliefAt2h?.code),
    kind: Value(e.kind.name),
    createdAt: Value(createdAt ?? now),
  );
}

/// Drift-backed [MedicationRepository].
class DriftMedicationRepository implements MedicationRepository {
  DriftMedicationRepository(this._db, {required this.clock});

  final AppDatabase _db;
  final DateTime Function() clock;

  List<MedicationEntity> _map(List<MedicationEvent> rows) =>
      rows.map(MedicationMapper.toEntity).toList();

  @override
  Future<MedicationEntity?> byId(String id) async {
    final row = await _db.medicationDao.byId(id);
    return row == null ? null : MedicationMapper.toEntity(row);
  }

  @override
  Future<List<MedicationEntity>> forAttack(String attackId) async =>
      _map(await _db.medicationDao.forAttack(attackId));

  @override
  Stream<List<MedicationEntity>> watchForAttack(String attackId) =>
      _db.medicationDao.watchForAttack(attackId).map(_map);

  @override
  Future<List<MedicationEntity>> inRange(DateTime from, DateTime to) async =>
      _map(await _db.medicationDao.inRange(from, to));

  @override
  Stream<List<MedicationEntity>> watchRange(DateTime from, DateTime to) =>
      _db.medicationDao.watchRange(from, to).map(_map);

  @override
  Future<List<MedicationEntity>> all() async =>
      _map(await _db.medicationDao.all());

  @override
  Stream<List<MedicationEntity>> watchAll() =>
      _db.medicationDao.watchAll().map(_map);

  @override
  Future<List<String>> recentNames({int limit = 10}) =>
      _db.medicationDao.recentNames(limit: limit);

  @override
  Future<void> save(MedicationEntity event) => _db.transaction(() async {
    final existing = await _db.medicationDao.byId(event.id);
    await _db.medicationDao.upsert(
      MedicationMapper.toCompanion(
        event,
        now: clock().toUtc(),
        createdAt: existing?.createdAt,
      ),
    );
  });

  @override
  Future<void> delete(String id) async {
    await _db.medicationDao.deleteById(id);
  }
}
