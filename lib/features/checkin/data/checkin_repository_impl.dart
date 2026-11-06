import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/db/database_provider.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/checkin/data/checkin_mapper.dart';
import 'package:migraine_tracker/features/checkin/domain/checkin_entity.dart';
import 'package:migraine_tracker/features/checkin/domain/checkin_repository.dart';

final checkinRepositoryProvider = Provider<CheckinRepository>(
  (ref) => DriftCheckinRepository(
    ref.watch(appDatabaseProvider),
    clock: ref.watch(clockProvider),
  ),
);

/// Drift-backed [CheckinRepository].
class DriftCheckinRepository implements CheckinRepository {
  DriftCheckinRepository(this._db, {required this.clock});

  final AppDatabase _db;
  final DateTime Function() clock;

  @override
  Future<CheckinEntity?> byDate(String date) async {
    final row = await _db.checkinDao.byDate(date);
    return row == null ? null : CheckinMapper.toEntity(row);
  }

  @override
  Stream<CheckinEntity?> watchByDate(String date) => _db.checkinDao
      .watchByDate(date)
      .map((row) => row == null ? null : CheckinMapper.toEntity(row));

  @override
  Future<List<CheckinEntity>> inRange(String from, String to) async =>
      (await _db.checkinDao.inRange(
        from,
        to,
      )).map(CheckinMapper.toEntity).toList();

  @override
  Stream<List<CheckinEntity>> watchRange(String from, String to) => _db
      .checkinDao
      .watchRange(from, to)
      .map((rows) => rows.map(CheckinMapper.toEntity).toList());

  @override
  Future<List<CheckinEntity>> all() async =>
      (await _db.checkinDao.all()).map(CheckinMapper.toEntity).toList();

  @override
  Future<void> save(CheckinEntity checkin) => _db.transaction(() async {
    final existing = await _db.checkinDao.byDate(checkin.date);
    await _db.checkinDao.upsert(
      CheckinMapper.toCompanion(
        checkin,
        now: clock().toUtc(),
        createdAt: existing?.createdAt,
      ),
    );
  });

  @override
  Future<void> delete(String date) async {
    await _db.checkinDao.deleteByDate(date);
  }
}
