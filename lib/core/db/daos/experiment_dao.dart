import 'package:drift/drift.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/db/tables/experiments.dart';

part 'experiment_dao.g.dart';

/// Reads and writes experiments. Only one may be active at a time.
@DriftAccessor(tables: [Experiments])
class ExperimentDao extends DatabaseAccessor<AppDatabase>
    with _$ExperimentDaoMixin {
  ExperimentDao(super.attachedDatabase);

  Future<Experiment?> active() => (select(
    experiments,
  )..where((e) => e.status.equals('active'))).getSingleOrNull();

  Stream<Experiment?> watchActive() => (select(
    experiments,
  )..where((e) => e.status.equals('active'))).watchSingleOrNull();

  Future<List<Experiment>> all() =>
      (select(experiments)..orderBy([(e) => OrderingTerm.desc(e.start)])).get();

  /// Inserts a new experiment; throws [StateError] when one is active.
  Future<void> start(ExperimentsCompanion experiment) => transaction(() async {
    if (await active() != null) {
      throw StateError('An experiment is already active');
    }
    await into(experiments).insert(experiment);
  });

  Future<void> upsert(ExperimentsCompanion experiment) =>
      into(experiments).insertOnConflictUpdate(experiment);
}
