import 'package:intl/intl.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:risk_model/risk_model.dart';

/// Plain words for a factor.
String factorLabel(AppLocalizations l10n, Factor factor) => switch (factor) {
  Factor.pressureDrop => l10n.riskFactorPressureDrop,
  Factor.humidity => l10n.riskFactorHumidity,
  Factor.temperatureSwing => l10n.riskFactorTemperatureSwing,
  Factor.airQuality => l10n.riskFactorAirQuality,
  Factor.pollen => l10n.riskFactorPollen,
  Factor.brightLight => l10n.riskFactorBrightLight,
  Factor.screenTime => l10n.riskFactorScreenTime,
  Factor.poorSleep => l10n.riskFactorPoorSleep,
  Factor.stress => l10n.riskFactorStress,
  Factor.neckTension => l10n.riskFactorNeckTension,
  Factor.caffeine => l10n.riskFactorCaffeine,
  Factor.alcohol => l10n.riskFactorAlcohol,
  Factor.dehydration => l10n.riskFactorDehydration,
  Factor.cyclePhase => l10n.riskFactorCyclePhase,
};

/// "low", "medium" or "high" for a mean weight confidence.
String confidenceLabel(AppLocalizations l10n, double confidence) {
  const bands = AppThresholds.riskConfidenceBands;
  if (confidence < bands[0]) return l10n.riskConfidenceLow;
  if (confidence < bands[1]) return l10n.riskConfidenceMedium;
  return l10n.riskConfidenceHigh;
}

/// "Today", "Tomorrow" or the weekday for a date key relative to
/// [today] (also a date key).
String dayLabel(
  AppLocalizations l10n,
  String date,
  String today, {
  String? locale,
}) {
  final offset = parseDateKey(date).difference(parseDateKey(today)).inDays;
  if (offset == 0) return l10n.riskDayToday;
  if (offset == 1) return l10n.riskDayTomorrow;
  return DateFormat.EEEE(locale).format(parseDateKey(date));
}
