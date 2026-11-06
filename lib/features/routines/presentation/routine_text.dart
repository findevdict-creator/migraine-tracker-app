import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/features/routines/domain/routine.dart';

/// Localized content for each routine.
extension RoutineText on Routine {
  String title(AppLocalizations l10n) => switch (this) {
    Routine.stretches => l10n.routineStretchesTitle,
    Routine.breathing => l10n.routineBreathingTitle,
    Routine.lowLight => l10n.routineLowLightTitle,
    Routine.hydration => l10n.routineHydrationTitle,
    Routine.caffeine => l10n.routineCaffeineTitle,
    Routine.sleep => l10n.routineSleepTitle,
  };

  String summary(AppLocalizations l10n) => switch (this) {
    Routine.stretches => l10n.routineStretchesSummary,
    Routine.breathing => l10n.routineBreathingSummary,
    Routine.lowLight => l10n.routineLowLightSummary,
    Routine.hydration => l10n.routineHydrationSummary,
    Routine.caffeine => l10n.routineCaffeineSummary,
    Routine.sleep => l10n.routineSleepSummary,
  };

  /// The steps, one per line in the ARB.
  List<String> steps(AppLocalizations l10n) => switch (this) {
    Routine.stretches => l10n.routineStretchesSteps,
    Routine.breathing => l10n.routineBreathingSteps,
    Routine.lowLight => l10n.routineLowLightSteps,
    Routine.hydration => l10n.routineHydrationSteps,
    Routine.caffeine => l10n.routineCaffeineSteps,
    Routine.sleep => l10n.routineSleepSteps,
  }.split('\n').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
}

extension SuggestionReasonText on SuggestionReason {
  String label(AppLocalizations l10n) => switch (this) {
    SuggestionReason.highDay => l10n.routineReasonHighDay,
    SuggestionReason.neckTension => l10n.routineReasonNeckTension,
    SuggestionReason.stress => l10n.routineReasonStress,
  };
}
