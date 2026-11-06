import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/settings/settings_keys.dart';
import 'package:migraine_tracker/core/settings/settings_repository.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/checkin/data/checkin_repository_impl.dart';
import 'package:migraine_tracker/features/checkin/domain/checkin_entity.dart';
import 'package:migraine_tracker/features/checkin/domain/checkin_repository.dart';

/// Today's date key, from the injectable clock.
final todayKeyProvider = Provider<String>(
  (ref) => ref.watch(clockProvider)().dateKey,
);

/// Today's check-in, or null when not started.
final todayCheckinProvider = StreamProvider<CheckinEntity?>((ref) {
  final today = ref.watch(todayKeyProvider);
  return ref.watch(checkinRepositoryProvider).watchByDate(today);
});

/// The dates the user may fill in: today and the back-fill window, newest
/// first. Never a future date.
final backfillDatesProvider = Provider<List<String>>((ref) {
  final now = ref.watch(clockProvider)().startOfDay;
  return [
    for (var i = 0; i < AppThresholds.checkinBackfillDays; i++)
      now.subtract(Duration(days: i)).dateKey,
  ];
});

/// Check-ins in the back-fill window keyed by date, to mark filled days.
final backfillCheckinsProvider = StreamProvider<Map<String, CheckinEntity>>((
  ref,
) {
  final dates = ref.watch(backfillDatesProvider);
  return ref
      .watch(checkinRepositoryProvider)
      .watchRange(dates.last, dates.first)
      .map((list) => {for (final c in list) c.date: c});
});

/// Edits one day's check-in. Each tap is written at once.
final AsyncNotifierProviderFamily<CheckinEditor, CheckinEntity, String>
checkinEditorProvider = AsyncNotifierProvider.family(CheckinEditor.new);

class CheckinEditor extends AsyncNotifier<CheckinEntity> {
  CheckinEditor(this.date);

  final String date;

  CheckinRepository get _repository => ref.read(checkinRepositoryProvider);

  @override
  Future<CheckinEntity> build() async =>
      await _repository.byDate(date) ?? CheckinEntity(date: date);

  /// Sets a typed value, or clears it with null. Tapping the selected chip
  /// again clears it.
  Future<void> setValue(CheckinField field, int? value) async {
    final current = state.value;
    if (current == null) return;
    final next = current.withValue(field, value, CheckinSource.typed);
    state = AsyncData(next);
    await _repository.save(next);
  }

  Future<void> toggleValue(CheckinField field, int value) =>
      setValue(field, state.value?[field] == value ? null : value);
}

/// The check-in reminder time. Phase 21 schedules the notification from it.
final checkinReminderProvider =
    AsyncNotifierProvider<CheckinReminderSetting, TimeOfDay>(
      CheckinReminderSetting.new,
    );

class CheckinReminderSetting extends AsyncNotifier<TimeOfDay> {
  SettingsRepository get _settings => ref.read(settingsRepositoryProvider);

  @override
  Future<TimeOfDay> build() async {
    final stored = await _settings.read<String>(
      SettingsKeys.checkinReminderTime,
    );
    return parseTime(stored) ?? AppThresholds.defaultCheckinReminder;
  }

  Future<void> set(TimeOfDay time) async {
    state = AsyncData(time);
    await _settings.write(SettingsKeys.checkinReminderTime, formatTime(time));
  }

  static String formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:'
      '${t.minute.toString().padLeft(2, '0')}';

  static TimeOfDay? parseTime(String? value) {
    if (value == null) return null;
    final parts = value.split(':');
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null || h < 0 || h > 23 || m < 0 || m > 59) {
      return null;
    }
    return TimeOfDay(hour: h, minute: m);
  }
}
