import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/core/settings/settings_keys.dart';
import 'package:migraine_tracker/core/settings/settings_repository.dart';
import 'package:migraine_tracker/features/checkin/presentation/checkin_controller.dart';
import 'package:migraine_tracker/features/risk/application/risk_engine.dart';
import 'package:migraine_tracker/features/routines/domain/routine.dart';

/// What is dismissed, live.
final routineDismissalsProvider = StreamProvider<RoutineDismissals>(
  (ref) => ref
      .watch(settingsRepositoryProvider)
      .watch<Object>(SettingsKeys.routinesDismissed)
      .map(RoutineDismissals.fromJson),
);

/// Today's suggestions from today's level and check-in, minus dismissals.
final routineSuggestionsProvider = Provider<List<RoutineSuggestion>>((ref) {
  final today = ref.watch(todayKeyProvider);
  final dismissals = ref.watch(routineDismissalsProvider).value;
  if (dismissals == null) return const [];
  return RoutineSuggester.suggest(
    level: ref.watch(riskDayProvider(today)).value?.level,
    checkin: ref.watch(todayCheckinProvider).value,
    dismissed: dismissals.forDate(today),
  );
});

final routineDismisserProvider = Provider<RoutineDismisser>(
  RoutineDismisser.new,
);

/// "Not today": hides the given routines until tomorrow.
class RoutineDismisser {
  RoutineDismisser(this._ref);

  final Ref _ref;

  Future<void> dismiss(Iterable<Routine> routines) async {
    final settings = _ref.read(settingsRepositoryProvider);
    final today = _ref.read(todayKeyProvider);
    final current = RoutineDismissals.fromJson(
      await settings.read<Object>(SettingsKeys.routinesDismissed),
    );
    await settings.write(
      SettingsKeys.routinesDismissed,
      current.add(today, routines).toJson(),
    );
  }
}
