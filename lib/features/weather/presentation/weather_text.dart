import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/units/units.dart';

/// "Updated X ago" for a forecast age; "not yet" when there is none.
String forecastAge(AppLocalizations l10n, Duration? age) {
  if (age == null) return l10n.envUpdatedNever;
  if (age.inMinutes < 1) return l10n.envUpdatedJustNow;
  if (age.inHours < 1) return l10n.envUpdatedMinutes(age.inMinutes);
  if (age.inDays < 1) return l10n.envUpdatedHours(age.inHours);
  return l10n.envUpdatedDays(age.inDays);
}

/// Signed pressure change such as `+2.3 hPa` or `+0.07 inHg`.
String formatDelta(AppLocalizations l10n, Units units, double hpa) =>
    units.pressureText(l10n, hpa, signed: true);

/// Trend word for the strongest recent change.
String trendLabel(AppLocalizations l10n, double? strongest) {
  if (strongest == null) return l10n.envTrendUnknown;
  if (strongest >= 2) return l10n.envTrendRising;
  if (strongest <= -2) return l10n.envTrendFalling;
  return l10n.envTrendSteady;
}
