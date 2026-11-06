import 'package:migraine_tracker/config/app_config.dart';

/// The five notification types. Each has its own switch; [defaultOn]
/// applies until the person touches it.
enum NotificationType {
  riskRising(
    code: 'riskRising',
    channel: AppNotificationChannels.alerts,
    defaultOn: true,
  ),
  pressureDrop(
    code: 'pressureDrop',
    channel: AppNotificationChannels.alerts,
    defaultOn: true,
  ),
  attackOver(
    code: 'attackOver',
    channel: AppNotificationChannels.attack,
    defaultOn: true,
  ),
  checkin(
    code: 'checkin',
    channel: AppNotificationChannels.reminders,
    defaultOn: true,
  ),
  medication(
    code: 'medication',
    channel: AppNotificationChannels.reminders,
    defaultOn: false,
  ),
  questionnaire(
    code: 'questionnaire',
    channel: AppNotificationChannels.reminders,
    defaultOn: true,
  );

  NotificationType({
    required this.code,
    required this.channel,
    required this.defaultOn,
  });

  /// Settings key suffix and event key prefix.
  final String code;
  final String channel;
  final bool defaultOn;

  static NotificationType? fromCode(String code) =>
      values.where((t) => t.code == code).firstOrNull;
}
