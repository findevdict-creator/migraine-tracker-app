/// Keys of the key-value `settings` table. One place, so export, backup and
/// the settings screen agree on names. Values are JSON.
abstract final class SettingsKeys {
  /// Local time of the daily check-in reminder, as `HH:mm`.
  static const String checkinReminderTime = 'checkin.reminderTime';

  /// Whether the check-in reminder is on.
  static const String checkinReminderEnabled = 'checkin.reminderEnabled';

  /// Whether cycle tracking is enabled. Off by default; nothing
  /// cycle-related is shown until the user turns it on.
  static const String cycleTrackingEnabled = 'cycle.enabled';

  /// Period start dates as a JSON list of `yyyy-MM-dd`, oldest first.
  static const String cyclePeriodStarts = 'cycle.periodStarts';
}
