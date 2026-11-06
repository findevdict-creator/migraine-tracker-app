/// Keys of the key-value `settings` table. One place, so export, backup and
/// the settings screen agree on names. Values are JSON.
abstract final class SettingsKeys {
  /// Local time of the daily check-in reminder, as `HH:mm`.
  static const String checkinReminderTime = 'checkin.reminderTime';

  /// Whether the check-in reminder is on.
  static const String checkinReminderEnabled = 'checkin.reminderEnabled';

  /// Whether cycle tracking is enabled (phase 08).
  static const String cycleTrackingEnabled = 'cycle.enabled';
}
