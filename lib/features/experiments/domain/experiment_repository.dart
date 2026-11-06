import 'package:migraine_tracker/features/experiments/domain/experiment.dart';

abstract interface class ExperimentRepository {
  Future<ExperimentEntity?> active();
  Stream<ExperimentEntity?> watchActive();
  Stream<List<ExperimentEntity>> watchPast();

  /// Starts [change] on the day of [now]; throws [StateError] when one is
  /// already active.
  Future<ExperimentEntity> start(ExperimentChange change, DateTime now);

  Future<void> save(ExperimentEntity experiment);
}
