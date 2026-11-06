import 'package:migraine_tracker/core/l10n/l10n.dart';

/// "Updated X ago" for a forecast age; "not yet" when there is none.
String forecastAge(AppLocalizations l10n, Duration? age) {
  if (age == null) return l10n.envUpdatedNever;
  if (age.inMinutes < 1) return l10n.envUpdatedJustNow;
  if (age.inHours < 1) return l10n.envUpdatedMinutes(age.inMinutes);
  if (age.inDays < 1) return l10n.envUpdatedHours(age.inHours);
  return l10n.envUpdatedDays(age.inDays);
}

/// Signed hPa delta such as `+2.3 hPa`.
String formatDelta(AppLocalizations l10n, double value) {
  final sign = value > 0 ? '+' : '';
  return l10n.envDeltaValue('$sign${value.toStringAsFixed(1)}');
}

/// Trend word for the strongest recent change.
String trendLabel(AppLocalizations l10n, double? strongest) {
  if (strongest == null) return l10n.envTrendUnknown;
  if (strongest >= 2) return l10n.envTrendRising;
  if (strongest <= -2) return l10n.envTrendFalling;
  return l10n.envTrendSteady;
}
