import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/settings/settings_keys.dart';
import 'package:migraine_tracker/core/settings/settings_repository.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/checkin/data/checkin_repository_impl.dart';
import 'package:migraine_tracker/features/cycle/domain/cycle_calculator.dart';

/// Whether cycle tracking is on. Always false when the feature flag is off.
final cycleTrackingEnabledProvider = StreamProvider<bool>((ref) {
  if (!AppFeatureFlags.cycleTrackingAvailable) return Stream.value(false);
  return ref
      .watch(settingsRepositoryProvider)
      .watch<bool>(SettingsKeys.cycleTrackingEnabled)
      .map((v) => v ?? false);
});

/// Logged period start dates, oldest first.
final periodStartsProvider = StreamProvider<List<String>>(
  (ref) => ref
      .watch(settingsRepositoryProvider)
      .watch<List<dynamic>>(SettingsKeys.cyclePeriodStarts)
      .map((v) => List<String>.from(v ?? const <dynamic>[])..sort()),
);

/// Cycle info for a date, or null when tracking is off or nothing logged.
final ProviderFamily<CycleInfo?, String> cycleInfoProvider = Provider.family((
  ref,
  date,
) {
  final enabled = ref.watch(cycleTrackingEnabledProvider).value ?? false;
  if (!enabled) return null;
  final starts = ref.watch(periodStartsProvider).value ?? const [];
  return CycleCalculator.infoFor(date, starts);
});

final cycleLogProvider = Provider<CycleLog>(CycleLog.new);

/// Writes the cycle setting and period starts, and keeps the per-day
/// `cycleDay` column on check-ins in step.
class CycleLog {
  CycleLog(this._ref);

  final Ref _ref;

  SettingsRepository get _settings => _ref.read(settingsRepositoryProvider);

  Future<void> setEnabled({required bool enabled}) async {
    await _settings.write(SettingsKeys.cycleTrackingEnabled, enabled);
    await _restampCheckins(enabled ? await _starts() : const []);
  }

  Future<List<String>> _starts() async {
    final stored = await _settings.read<List<dynamic>>(
      SettingsKeys.cyclePeriodStarts,
    );
    return List<String>.from(stored ?? const <dynamic>[])..sort();
  }

  /// Adds the date as a period start, or removes it when already logged.
  Future<void> togglePeriodStart(String date) async {
    final starts = await _starts();
    if (!starts.remove(date)) starts.add(date);
    starts.sort();
    await _settings.write(SettingsKeys.cyclePeriodStarts, starts);
    await _restampCheckins(starts);
  }

  /// Rewrites `cycleDay` on every check-in from the derived cycle.
  Future<void> _restampCheckins(List<String> starts) async {
    final repo = _ref.read(checkinRepositoryProvider);
    for (final checkin in await repo.all()) {
      final day = CycleCalculator.infoFor(checkin.date, starts)?.day;
      if (checkin.cycleDay != day) {
        await repo.save(
          checkin.copyWith(cycleDay: day, clearCycleDay: day == null),
        );
      }
    }
  }

  /// The cycle day to stamp on a check-in being saved now.
  Future<int?> cycleDayFor(String date) async {
    final enabled =
        await _settings.read<bool>(SettingsKeys.cycleTrackingEnabled) ?? false;
    if (!enabled || !AppFeatureFlags.cycleTrackingAvailable) return null;
    return CycleCalculator.infoFor(date, await _starts())?.day;
  }
}

/// Today's date key for the cycle screen.
final cycleTodayProvider = Provider<String>(
  (ref) => ref.watch(clockProvider)().dateKey,
);
