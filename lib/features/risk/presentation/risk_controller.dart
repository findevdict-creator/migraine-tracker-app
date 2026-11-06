import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/risk/application/risk_engine.dart';
import 'package:migraine_tracker/features/risk/data/risk_repository_impl.dart';
import 'package:migraine_tracker/features/risk/domain/risk_entities.dart';

/// Today's date key, re-read on each build.
final riskTodayProvider = Provider<String>(
  (ref) => ref.watch(clockProvider)().dateKey,
);

/// Stored risk for today and the next [AppThresholds.riskForecastDays]
/// days, in date order. Reads the local store only, so it works offline.
final upcomingRiskProvider = StreamProvider<List<RiskDayEntity>>((ref) {
  final now = ref.watch(clockProvider)();
  return ref
      .watch(riskRepositoryProvider)
      .watchRiskRange(
        now.dateKey,
        now.add(const Duration(days: AppThresholds.riskForecastDays)).dateKey,
      );
});

/// How many attacks are logged and whether the badge still shows.
final learningStatusProvider = FutureProvider<LearningStatus>((ref) async {
  final count = await ref.watch(attackCountProvider.future);
  return LearningStatus(
    attacks: count,
    needed: AppThresholds.attacksBeforeModelIsTuned,
  );
});

/// Attacks logged against the number the model wants before it counts
/// as tuned.
class LearningStatus {
  const LearningStatus({required this.attacks, required this.needed});

  final int attacks;
  final int needed;

  bool get stillLearning => attacks < needed;
}
