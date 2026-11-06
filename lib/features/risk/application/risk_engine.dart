import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/settings/settings_keys.dart';
import 'package:migraine_tracker/core/settings/settings_repository.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/attack_log/data/attack_repository_impl.dart';
import 'package:migraine_tracker/features/risk/application/day_inputs_builder.dart';
import 'package:migraine_tracker/features/risk/data/risk_repository_impl.dart';
import 'package:migraine_tracker/features/risk/domain/risk_entities.dart';
import 'package:migraine_tracker/features/risk/domain/risk_repository.dart';
import 'package:migraine_tracker/features/weather/application/weather_sync.dart';
import 'package:risk_model/risk_model.dart';

final riskEngineProvider = Provider<RiskEngine>(RiskEngine.new);

/// Runs the model against the local stores: learns after each attack and
/// scores today plus the next days whenever the app opens or weather
/// arrives. Everything stays on the device.
class RiskEngine {
  RiskEngine(this._ref);

  final Ref _ref;

  RiskRepository get _repo => _ref.read(riskRepositoryProvider);
  SettingsRepository get _settings => _ref.read(settingsRepositoryProvider);
  DateTime get _now => _ref.read(clockProvider)();

  /// The app's knobs, from `AppThresholds`.
  static const LearningParams params = LearningParams(
    // ignore_for_file: avoid_redundant_argument_values, config owns these
    windowDays: AppThresholds.riskAttackWindowDays,
    shrinkage: AppThresholds.riskWeightShrinkage,
    attacksForFullConfidence: AppThresholds.attacksBeforeModelIsTuned,
    moderatePercentile: AppThresholds.riskModeratePercentile,
    highPercentile: AppThresholds.riskHighPercentile,
    minDaysForThresholds: AppThresholds.riskThresholdMinDays,
    minThresholdGap: AppThresholds.riskThresholdMinGap,
  );

  /// The weights in use: learned ones, or population before any run.
  Future<WeightTable> weights() async =>
      await _repo.weights() ?? WeightTable.population();

  /// The thresholds in use: learned ones, or population before any run.
  Future<LevelThresholds> thresholds() async {
    final raw = await _settings.read<Map<String, dynamic>>(
      SettingsKeys.riskThresholds,
    );
    if (raw == null) return const LevelThresholds.population();
    return LevelThresholds.fromJson(raw.cast<String, Object?>());
  }

  /// Re-learns weights and thresholds from the whole history, stores
  /// them and every history day's risk, then scores the days ahead.
  /// Returns null when nothing could be learned (no history at all).
  Future<LearningResult?> relearn() async {
    final now = _now;
    final today = now.dateKey;
    final from = now
        .subtract(const Duration(days: AppThresholds.riskHistoryDays))
        .dateKey;
    final days = await _ref.read(dayInputsBuilderProvider).build(from, today);
    final attacks = await _ref.read(attackRepositoryProvider).all();
    final attackDates = {for (final a in attacks) a.startedAt.dateKey};
    if (days.isEmpty) return null;
    final result = const Learner(params: params)
        .learn(days: days, attackDates: attackDates);
    await _repo.saveWeights(result.weights, now: now);
    await _settings.write(
      SettingsKeys.riskThresholds,
      result.thresholds.toJson(),
    );
    await _settings.write(
      SettingsKeys.riskLastLearnedAt,
      now.toIso8601String(),
    );
    await _repo.saveRisk(result.history, now: now);
    await scoreUpcoming();
    return result;
  }

  /// Scores today and the next [AppThresholds.riskForecastDays] days with
  /// the current weights and stores them. Days without any data are not
  /// stored.
  Future<List<DayRisk>> scoreUpcoming() async {
    final now = _now;
    final from = now.dateKey;
    final to = now
        .add(const Duration(days: AppThresholds.riskForecastDays))
        .dateKey;
    final days = await _ref.read(dayInputsBuilderProvider).build(from, to);
    final scorer = DailyLoad(
      weights: await weights(),
      thresholds: await thresholds(),
    );
    final risks = [for (final d in days) scorer.compute(d)];
    if (risks.isNotEmpty) {
      await _repo.saveRisk(risks, now: now);
      await _repo.recordShown(risks, today: from, now: now);
    }
    return risks;
  }
}

/// Scores the days ahead once weather has been refreshed. Watched by home;
/// invalidated on resume together with the weather refresh.
final riskRefreshProvider = FutureProvider<List<DayRisk>>((ref) async {
  await ref.watch(weatherRefreshProvider.future);
  return await ref.read(riskEngineProvider).scoreUpcoming();
});

/// The stored risk for one date, live.
final StreamProviderFamily<RiskDayEntity?, String> riskDayProvider =
    StreamProvider.family<RiskDayEntity?, String>(
      (ref, date) => ref
          .watch(riskRepositoryProvider)
          .watchRiskRange(date, date)
          .map((rows) => rows.firstOrNull),
    );

/// The stored risk for a date range, live.
final StreamProviderFamily<List<RiskDayEntity>, ({String from, String to})>
riskRangeProvider =
    StreamProvider.family<List<RiskDayEntity>, ({String from, String to})>(
      (ref, range) => ref
          .watch(riskRepositoryProvider)
          .watchRiskRange(range.from, range.to),
    );

/// The learned weights, live (null before the first learning run).
final riskWeightsProvider = StreamProvider<WeightTable?>(
  (ref) => ref.watch(riskRepositoryProvider).watchWeights(),
);

/// Logged attacks so far, for the "still learning" badge.
final attackCountProvider = FutureProvider<int>(
  (ref) => ref.watch(attackRepositoryProvider).count(),
);

/// Runs [RiskEngine.relearn] without letting a failure surface to the
/// caller; learning is best effort and runs again after the next attack.
Future<void> relearnQuietly(Ref ref) async {
  try {
    await ref.read(riskEngineProvider).relearn();
  } on Object catch (error, stack) {
    debugPrint('risk relearn failed: $error\n$stack');
  }
}
