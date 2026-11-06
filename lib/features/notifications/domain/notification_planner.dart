import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/notifications/domain/notification_types.dart';
import 'package:migraine_tracker/features/notifications/domain/planned_notification.dart';
import 'package:migraine_tracker/features/risk/domain/risk_entities.dart';
import 'package:risk_model/risk_model.dart';

/// A forecast hour's 24 h pressure change, for the pressure-drop alert.
@immutable
class PressureForecastPoint {
  const PressureForecastPoint({
    required this.hourLocal,
    required this.delta24h,
  });

  /// Local time of the hour.
  final DateTime hourLocal;

  /// Pressure at that hour minus pressure 24 h before, hPa.
  final double delta24h;
}

/// Everything the planner looks at. Built by the scheduler from the
/// local stores; built by hand in tests.
@immutable
class PlannerInput {
  const PlannerInput({
    required this.now,
    required this.enabled,
    this.riskDays = const [],
    this.pressure = const [],
    this.pressureThresholdHpa = AppThresholds.defaultPressureDropAlertHpa,
    this.runningAttackId,
    this.runningAttackStartedAt,
    this.typicalAttackDuration = AppThresholds.defaultAttackDuration,
    this.checkinTime = AppThresholds.defaultCheckinReminder,
    this.checkedInDates = const {},
    this.medicationTime = AppThresholds.defaultMedicationReminder,
    this.horizonDays = AppThresholds.riskForecastDays,
  });

  final DateTime now;
  final Set<NotificationType> enabled;

  /// Stored risk for today and the days ahead, any order.
  final List<RiskDayEntity> riskDays;

  /// Forecast hours ahead of [now] with their 24 h change.
  final List<PressureForecastPoint> pressure;
  final double pressureThresholdHpa;
  final String? runningAttackId;
  final DateTime? runningAttackStartedAt;
  final Duration typicalAttackDuration;
  final TimeOfDay checkinTime;

  /// Dates (`yyyy-MM-dd`) that already have a check-in.
  final Set<String> checkedInDates;
  final TimeOfDay medicationTime;
  final int horizonDays;
}

/// FR-14: turns the stores into dated notifications with event keys.
/// Pure: same input, same plan.
abstract final class NotificationPlanner {
  static List<PlannedNotification> plan(PlannerInput input) {
    final out = <PlannedNotification>[
      ..._riskRising(input),
      ..._pressureDrop(input),
      ..._attackOver(input),
      ..._daily(
        input,
        NotificationType.checkin,
        input.checkinTime,
        skipDates: input.checkedInDates,
      ),
      ..._daily(input, NotificationType.medication, input.medicationTime),
    ]..sort((a, b) => a.at.compareTo(b.at));
    return out;
  }

  /// Drops notifications whose key was already delivered: present in
  /// [delivered] with a time at or before [now]. A key recorded with a
  /// future time was only pending and may be scheduled again.
  static List<PlannedNotification> dedupe(
    List<PlannedNotification> planned,
    Map<String, DateTime> delivered,
    DateTime now,
  ) => [
    for (final n in planned)
      if (!_wasDelivered(n.key, delivered, now)) n,
  ];

  /// The keys worth keeping: delivered within the retention window, plus
  /// everything scheduled now.
  static Map<String, DateTime> prune(
    Map<String, DateTime> delivered,
    DateTime now,
  ) => {
    for (final e in delivered.entries)
      if (now.difference(e.value) <= AppThresholds.notificationDedupeRetention)
        e.key: e.value,
  };

  static bool _wasDelivered(
    String key,
    Map<String, DateTime> delivered,
    DateTime now,
  ) {
    final at = delivered[key];
    return at != null && !at.isAfter(now);
  }

  /// The soonest a notification may fire.
  static DateTime _soonest(DateTime now) =>
      now.add(AppThresholds.notificationLeadTime);

  static Iterable<PlannedNotification> _riskRising(PlannerInput input) sync* {
    if (!input.enabled.contains(NotificationType.riskRising)) return;
    final byDate = {for (final d in input.riskDays) d.date: d};
    final today = input.now.dateKey;
    for (final day in input.riskDays) {
      if (day.date.compareTo(today) < 0) continue;
      final date = parseDateKey(day.date);
      final previous = byDate[date.subtract(const Duration(days: 1)).dateKey];
      final previousLevel = previous?.level ?? RiskLevel.low;
      final rising = day.level.index > previousLevel.index;
      if (!rising) continue;
      final driver = day.drivers().firstOrNull?.factor.id ?? '';
      final args = {'level': day.level.id, 'driver': driver};
      final evening = DateTime(
        date.year,
        date.month,
        date.day - 1,
        AppThresholds.riskRisingEveningHour,
      );
      if (evening.isAfter(input.now)) {
        yield PlannedNotification(
          key: 'risk:${day.date}:evening',
          type: NotificationType.riskRising,
          at: evening,
          args: args,
        );
      }
      final morning = DateTime(
        date.year,
        date.month,
        date.day,
        AppThresholds.riskRisingMorningHour,
      );
      if (morning.isAfter(input.now)) {
        yield PlannedNotification(
          key: 'risk:${day.date}:morning',
          type: NotificationType.riskRising,
          at: morning,
          args: args,
        );
      }
    }
  }

  /// One alert per forecast day whose first qualifying hour shows a fall
  /// of the threshold or more over 24 h.
  static Iterable<PlannedNotification> _pressureDrop(PlannerInput input) sync* {
    if (!input.enabled.contains(NotificationType.pressureDrop)) return;
    final seenDays = <String>{};
    final points = [...input.pressure]
      ..sort((a, b) => a.hourLocal.compareTo(b.hourLocal));
    for (final p in points) {
      if (p.hourLocal.isBefore(input.now)) continue;
      if (p.delta24h > -input.pressureThresholdHpa) continue;
      final day = p.hourLocal.dateKey;
      if (!seenDays.add(day)) continue;
      yield PlannedNotification(
        key: 'pressure:$day',
        type: NotificationType.pressureDrop,
        at: _soonest(input.now),
        args: {
          'hpa': p.delta24h.abs().toStringAsFixed(1),
          'time': p.hourLocal.toIso8601String(),
        },
      );
    }
  }

  static Iterable<PlannedNotification> _attackOver(PlannerInput input) sync* {
    if (!input.enabled.contains(NotificationType.attackOver)) return;
    final id = input.runningAttackId;
    final started = input.runningAttackStartedAt;
    if (id == null || started == null) return;
    final due = started.add(input.typicalAttackDuration);
    final at = due.isAfter(input.now) ? due : _soonest(input.now);
    yield PlannedNotification(
      key: 'attackOver:$id',
      type: NotificationType.attackOver,
      at: at,
      args: {'duration': input.typicalAttackDuration.inMinutes.toString()},
      payload: id,
      withEndAttackAction: true,
    );
  }

  static Iterable<PlannedNotification> _daily(
    PlannerInput input,
    NotificationType type,
    TimeOfDay time, {
    Set<String> skipDates = const {},
  }) sync* {
    if (!input.enabled.contains(type)) return;
    final start = input.now.startOfDay;
    for (var i = 0; i <= input.horizonDays; i++) {
      final day = start.add(Duration(days: i));
      final at = DateTime(day.year, day.month, day.day, time.hour, time.minute);
      if (!at.isAfter(input.now)) continue;
      if (skipDates.contains(day.dateKey)) continue;
      yield PlannedNotification(
        key: '${type.code}:${day.dateKey}',
        type: type,
        at: at,
      );
    }
  }
}
