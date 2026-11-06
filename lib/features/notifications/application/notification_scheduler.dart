import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/generated/app_localizations.dart';
import 'package:migraine_tracker/core/settings/settings_keys.dart';
import 'package:migraine_tracker/core/settings/settings_repository.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/core/widgets/risk_level_badge.dart';
import 'package:migraine_tracker/features/attack_log/data/attack_repository_impl.dart';
import 'package:migraine_tracker/features/checkin/data/checkin_repository_impl.dart';
import 'package:migraine_tracker/features/notifications/data/local_notification_gateway.dart';
import 'package:migraine_tracker/features/notifications/domain/notification_gateway.dart';
import 'package:migraine_tracker/features/notifications/domain/notification_planner.dart';
import 'package:migraine_tracker/features/notifications/domain/notification_types.dart';
import 'package:migraine_tracker/features/notifications/domain/planned_notification.dart';
import 'package:migraine_tracker/features/questionnaires/data/questionnaire_repository_impl.dart';
import 'package:migraine_tracker/features/questionnaires/domain/questionnaire.dart';
import 'package:migraine_tracker/features/risk/application/risk_engine.dart';
import 'package:migraine_tracker/features/risk/data/risk_repository_impl.dart';
import 'package:migraine_tracker/features/risk/presentation/risk_text.dart';
import 'package:migraine_tracker/features/weather/application/weather_sync.dart';
import 'package:migraine_tracker/features/weather/data/weather_repository_impl.dart';
import 'package:migraine_tracker/features/weather/domain/location_cell.dart';
import 'package:risk_model/risk_model.dart';

final notificationSchedulerProvider = Provider<NotificationScheduler>(
  NotificationScheduler.new,
);

/// Reads the switches and the stores, plans, dedupes and hands the plan
/// to the gateway. Runs after each risk refresh and after an attack
/// starts; safe to call often.
class NotificationScheduler {
  NotificationScheduler(this._ref);

  final Ref _ref;

  SettingsRepository get _settings => _ref.read(settingsRepositoryProvider);
  NotificationGateway get _gateway => _ref.read(notificationGatewayProvider);
  DateTime get _now => _ref.read(clockProvider)();

  /// The switch for a type (default from the enum).
  Future<bool> isEnabled(NotificationType type) async =>
      await _settings.read<bool>(SettingsKeys.notificationType(type.code)) ??
      type.defaultOn;

  Future<void> setEnabled(NotificationType type, {required bool enabled}) =>
      _settings.write(SettingsKeys.notificationType(type.code), enabled);

  Future<double> pressureThreshold() async =>
      (await _settings.read<num>(SettingsKeys.notificationPressureThreshold))
          ?.toDouble() ??
      AppThresholds.defaultPressureDropAlertHpa;

  Future<void> setPressureThreshold(double hpa) =>
      _settings.write(SettingsKeys.notificationPressureThreshold, hpa);

  Future<TimeOfDay> medicationTime() async {
    final raw = await _settings.read<String>(
      SettingsKeys.notificationMedicationTime,
    );
    if (raw == null) return AppThresholds.defaultMedicationReminder;
    final parts = raw.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  Future<void> setMedicationTime(TimeOfDay time) => _settings.write(
    SettingsKeys.notificationMedicationTime,
    '${time.hour}:${time.minute}',
  );

  Future<List<PlannedNotification>>? _inFlight;

  /// True when no reschedule is running (tests wait on this).
  bool get isIdle => _inFlight == null;

  /// Builds the plan from the stores and schedules it. Returns what was
  /// scheduled (after dedupe). Calls queue behind each other so two
  /// refreshes (home, an attack start, a switch) never interleave their
  /// cancel-and-schedule sequences.
  Future<List<PlannedNotification>> reschedule() {
    final previous = _inFlight ?? Future.value(const <PlannedNotification>[]);
    late final Future<List<PlannedNotification>> next;
    next = previous
        .catchError((Object _) => const <PlannedNotification>[])
        .then((_) => _reschedule())
        .whenComplete(() {
          if (identical(_inFlight, next)) _inFlight = null;
        });
    _inFlight = next;
    return next;
  }

  Future<List<PlannedNotification>> _reschedule() async {
    final now = _now;
    final input = await _input(now);
    final planned = NotificationPlanner.plan(input);
    final delivered = await _deliveredKeys();
    final fresh = NotificationPlanner.dedupe(planned, delivered, now);
    await _gateway.cancelPending();
    final l10n = lookupAppLocalizations(AppLocales.fallback);
    for (final n in fresh) {
      await _gateway.schedule(n, render(l10n, n));
    }
    final kept = NotificationPlanner.prune(delivered, now);
    for (final n in fresh) {
      kept[n.key] = n.at;
    }
    await _settings.write(SettingsKeys.notificationSentKeys, {
      for (final e in kept.entries) e.key: e.value.toIso8601String(),
    });
    return fresh;
  }

  Future<Map<String, DateTime>> _deliveredKeys() async {
    final raw = await _settings.read<Map<String, dynamic>>(
      SettingsKeys.notificationSentKeys,
    );
    return {
      for (final e in (raw ?? const <String, dynamic>{}).entries)
        e.key: DateTime.parse(e.value as String),
    };
  }

  Future<PlannerInput> _input(DateTime now) async {
    final enabled = <NotificationType>{
      for (final t in NotificationType.values)
        if (await isEnabled(t)) t,
    };
    final today = now.dateKey;
    final to = now
        .add(const Duration(days: AppThresholds.riskForecastDays))
        .dateKey;
    final riskDays = await _ref
        .read(riskRepositoryProvider)
        .riskRange(now.subtract(const Duration(days: 1)).dateKey, to);
    final running = await _ref.read(attackRepositoryProvider).running();
    final checkins = await _ref
        .read(checkinRepositoryProvider)
        .inRange(today, to);
    final checkinTime = await _checkinTime();
    final questionnaires = await _ref
        .read(questionnaireRepositoryProvider)
        .all();
    return PlannerInput(
      now: now,
      enabled: enabled,
      riskDays: riskDays,
      pressure: await _pressure(now),
      pressureThresholdHpa: await pressureThreshold(),
      runningAttackId: running?.id,
      runningAttackStartedAt: running?.startedAt,
      typicalAttackDuration: await typicalAttackDuration(),
      checkinTime: checkinTime,
      checkedInDates: {for (final c in checkins) c.date},
      medicationTime: await medicationTime(),
      questionnaireDue: QuestionnaireDue.nextDue(
        questionnaires,
        AppThresholds.questionnaireReminder,
      ),
    );
  }

  Future<TimeOfDay> _checkinTime() async {
    final raw = await _settings.read<String>(SettingsKeys.checkinReminderTime);
    if (raw == null) return AppThresholds.defaultCheckinReminder;
    final parts = raw.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  /// Median length of completed attacks once enough exist, else the
  /// default.
  Future<Duration> typicalAttackDuration() async {
    final completed = await _ref.read(attackRepositoryProvider).completed();
    final lengths = completed.map((a) => a.duration).nonNulls.toList()..sort();
    if (lengths.length < AppThresholds.attacksBeforeDurationEstimate) {
      return AppThresholds.defaultAttackDuration;
    }
    return lengths[lengths.length ~/ 2];
  }

  /// 24 h deltas for every cached hour from now to the end of the
  /// forecast window.
  Future<List<PressureForecastPoint>> _pressure(DateTime now) async {
    final LocationCell? cell;
    try {
      cell = (await _ref.read(weatherSyncProvider).resolveLocation()).cell;
    } on Object catch (error) {
      // No location plugin (tests, desktop): plan without pressure alerts.
      debugPrint('notification pressure source unavailable: $error');
      return const [];
    }
    if (cell == null) return const [];
    final hours = await _ref
        .read(weatherRepositoryProvider)
        .hours(
          cell.key,
          now.subtract(const Duration(hours: 25)).toUtc(),
          now
              .add(const Duration(hours: AppThresholds.forecastWindowHours))
              .toUtc(),
        );
    final byHour = {
      for (final h in hours)
        if (h.pressureMsl != null) h.hourUtc.toUtc(): h.pressureMsl!,
    };
    return [
      for (final e in byHour.entries)
        if (!e.key.isBefore(now.toUtc()))
          if (byHour[e.key.subtract(const Duration(hours: 24))] case final p?)
            PressureForecastPoint(
              hourLocal: e.key.toLocal(),
              delta24h: double.parse((e.value - p).toStringAsFixed(1)),
            ),
    ];
  }

  /// Title and body for a planned notification.
  static NotificationCopy render(AppLocalizations l10n, PlannedNotification n) {
    switch (n.type) {
      case NotificationType.riskRising:
        final level = RiskLevel.fromId(n.args['level'] ?? 'low').label(l10n);
        final factor = Factor.fromId(n.args['driver'] ?? '');
        final driver = factor == null ? '' : factorLabel(l10n, factor);
        final evening = n.key.endsWith(':evening');
        return NotificationCopy(
          title: evening
              ? l10n.notifRiskEveningTitle(level)
              : l10n.notifRiskMorningTitle(level),
          body: evening
              ? l10n.notifRiskEveningBody(level, driver)
              : l10n.notifRiskMorningBody(level, driver),
        );
      case NotificationType.pressureDrop:
        final at = DateTime.tryParse(n.args['time'] ?? '');
        return NotificationCopy(
          title: l10n.notifPressureTitle,
          body: l10n.notifPressureBody(
            n.args['hpa'] ?? '',
            at == null ? '' : DateFormat.Hm().format(at),
          ),
        );
      case NotificationType.attackOver:
        final minutes = int.tryParse(n.args['duration'] ?? '') ?? 0;
        final d = Duration(minutes: minutes);
        final text = d.inHours > 0
            ? '${d.inHours} h ${d.inMinutes % 60} min'
            : '${d.inMinutes} min';
        return NotificationCopy(
          title: l10n.notifAttackOverTitle,
          body: l10n.notifAttackOverBody(text),
        );
      case NotificationType.checkin:
        return NotificationCopy(
          title: l10n.notifCheckinTitle,
          body: l10n.notifCheckinBody,
        );
      case NotificationType.medication:
        return NotificationCopy(
          title: l10n.notifMedicationTitle,
          body: l10n.notifMedicationBody,
        );
      case NotificationType.questionnaire:
        return NotificationCopy(
          title: l10n.notifQuestionnaireTitle,
          body: l10n.notifQuestionnaireBody,
        );
    }
  }
}

/// Reschedules once the risk refresh has run. Watched by home.
final notificationRefreshProvider = FutureProvider<List<PlannedNotification>>((
  ref,
) async {
  await ref.watch(riskRefreshProvider.future);
  return await ref.read(notificationSchedulerProvider).reschedule();
});
