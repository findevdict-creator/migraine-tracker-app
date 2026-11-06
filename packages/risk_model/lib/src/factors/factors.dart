import 'package:risk_model/src/day_inputs.dart';
import 'package:risk_model/src/factor.dart';
import 'package:risk_model/src/factor_module.dart';

export 'package:risk_model/src/factor_module.dart' show ramp;

/// Sea-level pressure falling over the last 24 h.
class PressureDropModule extends FactorModule {
  /// Stateless.
  const PressureDropModule();

  @override
  Factor get factor => Factor.pressureDrop;

  @override
  double get populationWeight => 0.45;

  @override
  double? exposure(DayInputs day) {
    final d = day.pressureDelta24h;
    if (d == null) return null;
    return ramp(d, from: -2, to: -6);
  }
}

/// High relative humidity.
class HumidityModule extends FactorModule {
  /// Stateless.
  const HumidityModule();

  @override
  Factor get factor => Factor.humidity;

  @override
  double get populationWeight => 0.2;

  @override
  double? exposure(DayInputs day) {
    final h = day.humidity;
    if (h == null) return null;
    return ramp(h, from: 65, to: 85);
  }
}

/// Large change of the daily temperature against the day before.
class TemperatureSwingModule extends FactorModule {
  /// Stateless.
  const TemperatureSwingModule();

  @override
  Factor get factor => Factor.temperatureSwing;

  @override
  double get populationWeight => 0.25;

  @override
  double? exposure(DayInputs day) {
    final t = day.temperatureSwing;
    if (t == null) return null;
    return ramp(t.abs(), from: 3, to: 8);
  }
}

/// Poor air quality (US AQI).
class AirQualityModule extends FactorModule {
  /// Stateless.
  const AirQualityModule();

  @override
  Factor get factor => Factor.airQuality;

  @override
  double get populationWeight => 0.2;

  @override
  double? exposure(DayInputs day) {
    final a = day.aqiUs;
    if (a == null) return null;
    return ramp(a, from: 50, to: 150);
  }
}

/// Pollen, highest type of the day.
class PollenModule extends FactorModule {
  /// Stateless.
  const PollenModule();

  @override
  Factor get factor => Factor.pollen;

  @override
  double get populationWeight => 0.2;

  @override
  double? exposure(DayInputs day) {
    final p = day.pollenMax;
    if (p == null) return null;
    return ramp(p, from: 20, to: 100);
  }
}

/// Bright light: the UV index or a high light-exposure answer, whichever
/// is stronger.
class BrightLightModule extends FactorModule {
  /// Stateless.
  const BrightLightModule();

  @override
  Factor get factor => Factor.brightLight;

  @override
  double get populationWeight => 0.25;

  @override
  double? exposure(DayInputs day) {
    final uv = day.uvMax;
    final light = day.lightExposure;
    if (uv == null && light == null) return null;
    final fromUv = uv == null ? 0.0 : ramp(uv, from: 3, to: 8);
    final fromAnswer = light == null ? 0.0 : scaleHigh(light);
    return fromUv > fromAnswer ? fromUv : fromAnswer;
  }
}

/// Screen time answer of 4 or 5.
class ScreenTimeModule extends FactorModule {
  /// Stateless.
  const ScreenTimeModule();

  @override
  Factor get factor => Factor.screenTime;

  @override
  double get populationWeight => 0.2;

  @override
  double? exposure(DayInputs day) {
    final v = day.screenExposure;
    return v == null ? null : scaleHigh(v);
  }
}

/// Poor sleep: the check-in answer or short measured sleep, whichever is
/// stronger.
class PoorSleepModule extends FactorModule {
  /// Stateless.
  const PoorSleepModule();

  @override
  Factor get factor => Factor.poorSleep;

  @override
  double get populationWeight => 0.5;

  @override
  double? exposure(DayInputs day) {
    final q = day.sleepQuality;
    final m = day.sleepMinutes;
    if (q == null && m == null) return null;
    final fromAnswer = q == null ? 0.0 : scaleLow(q);
    final fromMinutes = m == null ? 0.0 : ramp(m, from: 420, to: 300);
    return fromAnswer > fromMinutes ? fromAnswer : fromMinutes;
  }
}

/// Stress answer of 4 or 5.
class StressModule extends FactorModule {
  /// Stateless.
  const StressModule();

  @override
  Factor get factor => Factor.stress;

  @override
  double get populationWeight => 0.45;

  @override
  double? exposure(DayInputs day) {
    final v = day.stress;
    return v == null ? null : scaleHigh(v);
  }
}

/// Neck tension answer of 4 or 5.
class NeckTensionModule extends FactorModule {
  /// Stateless.
  const NeckTensionModule();

  @override
  Factor get factor => Factor.neckTension;

  @override
  double get populationWeight => 0.4;

  @override
  double? exposure(DayInputs day) {
    final v = day.neckTension;
    return v == null ? null : scaleHigh(v);
  }
}

/// Caffeine: a lot (4 or 5 on the 0 to 5 scale).
class CaffeineModule extends FactorModule {
  /// Stateless.
  const CaffeineModule();

  @override
  Factor get factor => Factor.caffeine;

  @override
  double get populationWeight => 0.25;

  @override
  double? exposure(DayInputs day) {
    final v = day.caffeine;
    return v == null ? null : scaleHigh(v);
  }
}

/// Alcohol: anything from 2 upwards on the 0 to 5 scale ramps to 1 at 5.
class AlcoholModule extends FactorModule {
  /// Stateless.
  const AlcoholModule();

  @override
  Factor get factor => Factor.alcohol;

  @override
  double get populationWeight => 0.35;

  @override
  double? exposure(DayInputs day) {
    final v = day.alcohol;
    if (v == null) return null;
    return ramp(v, from: 1, to: 5);
  }
}

/// Low hydration answer (1 or 2).
class DehydrationModule extends FactorModule {
  /// Stateless.
  const DehydrationModule();

  @override
  Factor get factor => Factor.dehydration;

  @override
  double get populationWeight => 0.3;

  @override
  double? exposure(DayInputs day) {
    final v = day.hydration;
    return v == null ? null : scaleLow(v);
  }
}

/// The two days before and the first two days of bleeding are full
/// exposure, day three is half.
class CyclePhaseModule extends FactorModule {
  /// Stateless.
  const CyclePhaseModule();

  @override
  Factor get factor => Factor.cyclePhase;

  @override
  double get populationWeight => 0.4;

  @override
  double? exposure(DayInputs day) {
    final d = day.cycleDay;
    final length = day.cycleLength;
    if (d == null || length == null) return null;
    if (d <= 2 || d >= length - 1) return 1;
    if (d == 3) return 0.5;
    return 0;
  }
}

/// 1 to 5 answers where high is the exposure: 4 is half, 5 is full.
double scaleHigh(int value) {
  if (value >= 5) return 1;
  if (value == 4) return 0.5;
  return 0;
}

/// 1 to 5 answers where low is the exposure: 1 is full, 2 is half.
double scaleLow(int value) {
  if (value <= 1) return 1;
  if (value == 2) return 0.5;
  return 0;
}

/// All modules, in [Factor] order.
const List<FactorModule> allModules = [
  PressureDropModule(),
  HumidityModule(),
  TemperatureSwingModule(),
  AirQualityModule(),
  PollenModule(),
  BrightLightModule(),
  ScreenTimeModule(),
  PoorSleepModule(),
  StressModule(),
  NeckTensionModule(),
  CaffeineModule(),
  AlcoholModule(),
  DehydrationModule(),
  CyclePhaseModule(),
];

/// The module for a factor.
FactorModule moduleFor(Factor factor) =>
    allModules.firstWhere((m) => m.factor == factor);
