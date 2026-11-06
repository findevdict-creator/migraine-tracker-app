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

  /// `gps` or `manual`. Where the weather cell comes from.
  static const String locationMode = 'location.mode';

  /// Typed-city fallback: `{name, lat, lon}` already rounded to a cell.
  static const String manualLocation = 'location.manual';

  /// The last cell weather was fetched for, so the app can show cached
  /// data before location is available.
  static const String weatherLastCell = 'weather.lastCell';

  /// Health sync (phase 14): map of type code to consent, whether headache
  /// events are written back, and the last import time.
  static const String healthConsent = 'health.consent';
  static const String healthWriteHeadaches = 'health.writeHeadaches';
  static const String healthLastImport = 'health.lastImport';

  /// Onboarding (phase 15): set once the first-run flow finished or was
  /// skipped, so it never shows again.
  static const String onboardingCompleted = 'onboarding.completed';
}
