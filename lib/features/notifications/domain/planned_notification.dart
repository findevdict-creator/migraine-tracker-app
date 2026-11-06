import 'package:flutter/foundation.dart';
import 'package:migraine_tracker/features/notifications/domain/notification_types.dart';

/// One notification the planner wants delivered. [key] identifies the
/// event (`risk:2026-11-07:evening`, `attackOver:<id>`) so the same event
/// is never announced twice. Copy is rendered by the scheduler from
/// [args] so the planner stays free of localisation.
@immutable
class PlannedNotification {
  const PlannedNotification({
    required this.key,
    required this.type,
    required this.at,
    this.args = const {},
    this.payload,
    this.withEndAttackAction = false,
  });

  final String key;
  final NotificationType type;

  /// Local delivery time.
  final DateTime at;

  /// Values the copy needs (level, driver, hPa, time, duration).
  final Map<String, String> args;

  /// Carried back on tap or action (the attack id for [withEndAttackAction]).
  final String? payload;
  final bool withEndAttackAction;

  /// Stable id for the OS from the key.
  int get id => key.hashCode & 0x7fffffff;

  @override
  bool operator ==(Object other) =>
      other is PlannedNotification && other.key == key && other.at == at;

  @override
  int get hashCode => Object.hash(key, at);
}
