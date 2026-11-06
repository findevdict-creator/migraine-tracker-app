import 'package:risk_model/src/day_inputs.dart';
import 'package:risk_model/src/factor.dart';

/// One factor's population rule: how exposed a day is, 0 (nothing) to 1
/// (the strongest exposure the model distinguishes), or null when the day
/// has no data for it.
abstract class FactorModule {
  /// Modules are stateless and const.
  const FactorModule();

  /// The factor this module scores.
  Factor get factor;

  /// Population weight, 0 to 1: how much a full exposure counts before any
  /// personal learning.
  double get populationWeight;

  /// Exposure for a day, 0 to 1, or null without data.
  double? exposure(DayInputs day);
}

/// Linear ramp from [from] (0) to [to] (1), clamped. Works in either
/// direction, so a drop can ramp from -2 to -6.
double ramp(num value, {required num from, required num to}) {
  final t = (value - from) / (to - from);
  if (t <= 0) return 0;
  if (t >= 1) return 1;
  return t;
}
