import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/db/database_provider.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/attack_log/data/attack_mapper.dart';
import 'package:migraine_tracker/features/attack_log/domain/attack_entity.dart';
import 'package:migraine_tracker/features/attack_log/domain/attack_repository.dart';

final attackRepositoryProvider = Provider<AttackRepository>(
  (ref) => DriftAttackRepository(
    ref.watch(appDatabaseProvider),
    clock: ref.watch(clockProvider),
  ),
);

final pressureStampSourceProvider = Provider<PressureStampSource>(
  (_) => const NoPressureStamp(),
);

/// Drift-backed [AttackRepository].
class DriftAttackRepository implements AttackRepository {
  DriftAttackRepository(this._db, {required this.clock});

  final AppDatabase _db;

  /// Source of "now" for `updatedAt` stamps.
  final DateTime Function() clock;

  @override
  Stream<AttackEntity?> watchRunning() => _db.attackDao.watchRunning().map(
    (row) => row == null ? null : AttackMapper.toEntity(row),
  );

  @override
  Future<AttackEntity?> running() async {
    final row = await _db.attackDao.running();
    return row == null ? null : AttackMapper.toEntity(row);
  }

  @override
  Future<AttackEntity?> byId(String id) async {
    final row = await _db.attackDao.byId(id);
    return row == null ? null : AttackMapper.toEntity(row);
  }

  @override
  Stream<List<AttackEntity>> watchAll() => _db.attackDao.watchAll().map(
    (rows) => rows.map(AttackMapper.toEntity).toList(),
  );

  @override
  Future<List<AttackEntity>> all() async =>
      (await _db.attackDao.all()).map(AttackMapper.toEntity).toList();

  @override
  Future<List<AttackEntity>> inRange(DateTime from, DateTime to) async =>
      (await _db.attackDao.inRange(
        from,
        to,
      )).map(AttackMapper.toEntity).toList();

  @override
  Future<List<AttackEntity>> completed() async =>
      (await _db.attackDao.completed()).map(AttackMapper.toEntity).toList();

  @override
  Future<int> count() => _db.attackDao.count();

  @override
  Future<void> save(AttackEntity attack) => _db.transaction(() async {
    final existing = await _db.attackDao.byId(attack.id);
    await _db.attackDao.upsert(
      AttackMapper.toCompanion(
        attack,
        now: clock().toUtc(),
        createdAt: existing?.createdAt,
      ),
    );
  });

  @override
  Future<void> delete(String id) async {
    await _db.attackDao.deleteById(id);
  }
}
