import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/attack_log/data/attack_repository_impl.dart';
import 'package:migraine_tracker/features/experiments/data/experiment_repository_impl.dart';
import 'package:migraine_tracker/features/experiments/domain/experiment.dart';

final activeExperimentProvider = StreamProvider<ExperimentEntity?>(
  (ref) => ref.watch(experimentRepositoryProvider).watchActive(),
);

final pastExperimentsProvider = StreamProvider<List<ExperimentEntity>>(
  (ref) => ref.watch(experimentRepositoryProvider).watchPast(),
);

/// The live comparison for the active experiment.
final experimentComparisonProvider = FutureProvider<ExperimentComparison?>((
  ref,
) async {
  final experiment = ref.watch(activeExperimentProvider).value;
  if (experiment == null) return null;
  return await ref.read(experimentActionsProvider).compare(experiment);
});

final experimentActionsProvider = Provider<ExperimentActions>(
  ExperimentActions.new,
);

class ExperimentActions {
  ExperimentActions(this._ref);

  final Ref _ref;

  DateTime get _now => _ref.read(clockProvider)();

  Future<ExperimentComparison> compare(ExperimentEntity experiment) async {
    final attacks = await _ref
        .read(attackRepositoryProvider)
        .inRange(
          experiment.start.subtract(
            const Duration(days: AppThresholds.experimentWindowDays),
          ),
          experiment.windowEnd,
        );
    return ExperimentComparison.build(experiment, attacks, _now);
  }

  Future<void> start(ExperimentChange change) =>
      _ref.read(experimentRepositoryProvider).start(change, _now);

  /// Records today's answer; answering again replaces it.
  Future<void> setAdherence(
    ExperimentEntity experiment, {
    required bool kept,
  }) => _ref
      .read(experimentRepositoryProvider)
      .save(
        experiment.copyWith(
          adherence: {...experiment.adherence, _now.dateKey: kept},
        ),
      );

  /// Ends the experiment and freezes the comparison as its result.
  Future<void> finish(ExperimentEntity experiment) => _close(
    experiment,
    experiment.isDueOn(_now)
        ? ExperimentStatus.completed
        : ExperimentStatus.abandoned,
  );

  /// Stops early; the numbers so far are kept with it.
  Future<void> stop(ExperimentEntity experiment) =>
      _close(experiment, ExperimentStatus.abandoned);

  Future<void> _close(
    ExperimentEntity experiment,
    ExperimentStatus status,
  ) async {
    final result = await compare(experiment);
    await _ref
        .read(experimentRepositoryProvider)
        .save(experiment.copyWith(status: status, end: _now, result: result));
  }
}
