import 'package:migraine_tracker/config/app_config.dart';

/// Band of an environment factor, from the bounds in [AppThresholds].
enum FactorBand {
  low,
  moderate,
  high,
  veryHigh;

  static FactorBand of(num value, List<num> bounds) {
    for (var i = 0; i < bounds.length; i++) {
      if (value <= bounds[i]) return FactorBand.values[i];
    }
    return FactorBand.veryHigh;
  }

  static FactorBand aqiUs(num v) => of(v, AppThresholds.aqiUsBands);
  static FactorBand aqiEu(num v) => of(v, AppThresholds.aqiEuBands);
  static FactorBand uv(num v) => of(v, AppThresholds.uvBands);
  static FactorBand pollen(num v) => of(v, AppThresholds.pollenBands);
}
