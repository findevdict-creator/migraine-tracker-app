import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/db/database_provider.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/experiments/domain/experiment.dart';
import 'package:migraine_tracker/features/experiments/domain/experiment_repository.dart';

final experimentRepositoryProvider = Provider<ExperimentRepository>(
  (ref) => DriftExperimentRepository(
    ref.watch(appDatabaseProvider),
    newId: ref.watch(idGeneratorProvider),
  ),
);

class DriftExperimentRepository implements ExperimentRepository {
  DriftExperimentRepository(this._db, {required this._newId});

  final AppDatabase _db;
  final String Function() _newId;

  @override
  Future<ExperimentEntity?> active() async {
    final row = await _db.experimentDao.active();
    return row == null ? null : _map(row);
  }

  @override
  Stream<ExperimentEntity?> watchActive() => _db.experimentDao
      .watchActive()
      .map((row) => row == null ? null : _map(row));

  @override
  Stream<List<ExperimentEntity>> watchPast() =>
      (_db.select(_db.experiments)
            ..where((e) => e.status.equals('active').not())
            ..orderBy([(e) => OrderingTerm.desc(e.start)]))
          .watch()
          .map((rows) => rows.map(_map).nonNulls.toList());

  @override
  Future<ExperimentEntity> start(ExperimentChange change, DateTime now) async {
    final experiment = ExperimentEntity(
      id: _newId(),
      change: change,
      start: now.startOfDay,
    );
    await _db.experimentDao.start(_companion(experiment));
    return experiment;
  }

  @override
  Future<void> save(ExperimentEntity experiment) =>
      _db.experimentDao.upsert(_companion(experiment));

  ExperimentsCompanion _companion(ExperimentEntity e) =>
      ExperimentsCompanion.insert(
        id: e.id,
        change: e.change.code,
        start: e.start,
        end: Value(e.end),
        adherence: Value(e.adherence),
        result: Value(e.result?.toJson()),
        status: Value(e.status.name),
      );

  ExperimentEntity? _map(Experiment row) {
    final change = ExperimentChange.fromCode(row.change);
    if (change == null) return null;
    final result = row.result;
    return ExperimentEntity(
      id: row.id,
      change: change,
      start: row.start.toLocal(),
      end: row.end?.toLocal(),
      adherence: {
        for (final e in row.adherence.entries)
          if (e.value is bool) e.key: e.value! as bool,
      },
      status: ExperimentStatus.fromCode(row.status),
      result: result == null ? null : ExperimentComparison.fromJson(result),
    );
  }
}
