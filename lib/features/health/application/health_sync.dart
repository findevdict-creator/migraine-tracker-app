import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/settings/settings_keys.dart';
import 'package:migraine_tracker/core/settings/settings_repository.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/attack_log/domain/attack_entity.dart';
import 'package:migraine_tracker/features/checkin/data/checkin_repository_impl.dart';
import 'package:migraine_tracker/features/checkin/domain/checkin_entity.dart';
import 'package:migraine_tracker/features/cycle/presentation/cycle_controller.dart';
import 'package:migraine_tracker/features/health/data/health_repository_impl.dart';
import 'package:migraine_tracker/features/health/data/health_source_impl.dart';
import 'package:migraine_tracker/features/health/domain/health_entities.dart';
import 'package:migraine_tracker/features/health/domain/health_repository.dart';
import 'package:migraine_tracker/features/health/domain/health_source.dart';

/// Outcome of one import.
@immutable
class HealthSyncResult {
  const HealthSyncResult({
    required this.imported,
    required this.prefilledDays,
    required this.periodStartsAdded,
    this.error,
  });

  const HealthSyncResult.nothing()
    : imported = 0,
      prefilledDays = 0,
      periodStartsAdded = 0,
      error = null;

  final int imported;
  final int prefilledDays;
  final int periodStartsAdded;
  final String? error;
}

/// Current consent, from settings.
final healthConsentProvider = StreamProvider<HealthConsent>(
  (ref) => ref
      .watch(settingsRepositoryProvider)
      .watch<Map<String, dynamic>>(SettingsKeys.healthConsent)
      .map(
        (raw) => raw == null
            ? const HealthConsent.none()
            : HealthConsent.fromJson(raw.cast<String, Object?>()),
      ),
);

final healthWriteHeadachesProvider = StreamProvider<bool>(
  (ref) => ref
      .watch(settingsRepositoryProvider)
      .watch<bool>(SettingsKeys.healthWriteHeadaches)
      .map((v) => v ?? false),
);

final healthLastImportProvider = StreamProvider<DateTime?>(
  (ref) => ref
      .watch(settingsRepositoryProvider)
      .watch<String>(SettingsKeys.healthLastImport)
      .map((v) => v == null ? null : DateTime.parse(v).toUtc()),
);

final healthSyncProvider = Provider<HealthSync>(HealthSync.new);

/// Imports consented types, pre-fills check-ins from sleep, and feeds
/// menstrual flow into cycle tracking. Writes headache events back when
/// the person opted in.
class HealthSync {
  HealthSync(this._ref);

  final Ref _ref;

  HealthSource get _source => _ref.read(healthSourceProvider);
  HealthRepository get _repo => _ref.read(healthRepositoryProvider);
  SettingsRepository get _settings => _ref.read(settingsRepositoryProvider);
  DateTime get _now => _ref.read(clockProvider)();

  Future<HealthConsent> consent() async {
    final raw = await _settings.read<Map<String, dynamic>>(
      SettingsKeys.healthConsent,
    );
    return raw == null
        ? const HealthConsent.none()
        : HealthConsent.fromJson(raw.cast<String, Object?>());
  }

  /// Turns a type on (asking the store for permission first) or off
  /// (deleting what was imported for it). Returns the resulting state.
  Future<bool> setConsent(HealthType type, {required bool allowed}) async {
    final current = await consent();
    if (allowed) {
      final granted = await _source.requestRead({type});
      if (!granted) return false;
      if (!current.any) await _source.requestHistory();
      await _settings.write(
        SettingsKeys.healthConsent,
        current.with_(type, allowed: true).toJson(),
      );
      await sync();
      return true;
    }
    await _settings.write(
      SettingsKeys.healthConsent,
      current.with_(type, allowed: false).toJson(),
    );
    await _repo.deleteType(type);
    return false;
  }

  Future<bool> setWriteHeadaches({required bool enabled}) async {
    if (enabled && !await _source.requestWriteHeadache()) {
      await _settings.write(SettingsKeys.healthWriteHeadaches, false);
      return false;
    }
    await _settings.write(SettingsKeys.healthWriteHeadaches, enabled);
    return enabled;
  }

  /// Imports everything new for each consented type, then derives.
  Future<HealthSyncResult> sync() async {
    final consent = await this.consent();
    if (!consent.any) return const HealthSyncResult.nothing();
    final now = _now.toUtc();
    var imported = 0;
    try {
      for (final type in consent.types) {
        final since =
            await _repo.latestEnd(type) ??
            now.subtract(const Duration(days: AppThresholds.healthImportDays));
        final samples = await _source.read({type}, since, now);
        await _repo.insertAll(samples);
        imported += samples.length;
      }
    } on Object catch (error) {
      return HealthSyncResult(
        imported: imported,
        prefilledDays: 0,
        periodStartsAdded: 0,
        error: error.toString(),
      );
    }
    await _settings.write(SettingsKeys.healthLastImport, now.toIso8601String());
    final prefilled = consent.allows(HealthType.sleep)
        ? await _prefillSleep(now)
        : 0;
    final starts = consent.allows(HealthType.menstrualFlow)
        ? await _importPeriodStarts(now)
        : 0;
    return HealthSyncResult(
      imported: imported,
      prefilledDays: prefilled,
      periodStartsAdded: starts,
    );
  }

  /// Sets sleep quality on check-ins of the back-fill window from the
  /// night's sleep minutes, never over a typed value.
  Future<int> _prefillSleep(DateTime now) async {
    final repo = _ref.read(checkinRepositoryProvider);
    var changed = 0;
    for (var i = 0; i < AppThresholds.checkinBackfillDays; i++) {
      final day = now.toLocal().startOfDay.subtract(Duration(days: i));
      final minutes = await sleepMinutesFor(day);
      if (minutes == null) continue;
      final date = day.dateKey;
      final existing = await repo.byDate(date) ?? CheckinEntity(date: date);
      if (existing.sources[CheckinField.sleepQuality] == CheckinSource.typed) {
        continue;
      }
      final quality = sleepQualityFromMinutes(minutes);
      if (existing[CheckinField.sleepQuality] == quality) continue;
      await repo.save(
        existing.withValue(
          CheckinField.sleepQuality,
          quality,
          _source.store == HealthStore.healthkit
              ? CheckinSource.healthkit
              : CheckinSource.healthConnect,
        ),
      );
      changed++;
    }
    return changed;
  }

  /// Minutes asleep in the night ending on [day] (noon the day before to
  /// noon that day), or null without samples.
  Future<int?> sleepMinutesFor(DateTime day) async {
    final local = day.toLocal().startOfDay;
    final from = local.subtract(const Duration(hours: 12));
    final to = local.add(const Duration(hours: 12));
    final samples = await _repo.ofType(HealthType.sleep, from, to);
    if (samples.isEmpty) return null;
    return samples.fold<double>(0, (sum, s) => sum + s.value).round();
  }

  /// A bleeding day after a non-bleeding day starts a period.
  Future<int> _importPeriodStarts(DateTime now) async {
    final from = now.subtract(
      const Duration(days: AppThresholds.healthImportDays),
    );
    final samples = await _repo.ofType(HealthType.menstrualFlow, from, now);
    final bleedingDays = <String>{
      for (final s in samples)
        if (s.value > 0) s.start.toLocal().dateKey,
    };
    final starts = <String>[
      for (final date in bleedingDays)
        if (!bleedingDays.contains(
          parseDateKey(date).subtract(const Duration(days: 1)).dateKey,
        ))
          date,
    ]..sort();
    final cycle = _ref.read(cycleLogProvider);
    var added = 0;
    for (final date in starts) {
      if (await cycle.addPeriodStart(date)) added++;
    }
    return added;
  }

  /// Writes an ended attack as a headache event when opted in.
  Future<void> exportAttack(AttackEntity attack) async {
    final end = attack.endedAt;
    if (end == null) return;
    final enabled =
        await _settings.read<bool>(SettingsKeys.healthWriteHeadaches) ?? false;
    if (!enabled) return;
    await _source.writeHeadache(
      start: attack.startedAt,
      end: end,
      intensity: attack.intensity,
    );
  }
}
