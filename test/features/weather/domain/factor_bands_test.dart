import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/features/weather/domain/factor_bands.dart';

void main() {
  test('bands follow the configured upper bounds inclusively', () {
    expect(AppThresholds.aqiUsBands, [50, 100, 150]);
    expect(FactorBand.aqiUs(0), FactorBand.low);
    expect(FactorBand.aqiUs(50), FactorBand.low);
    expect(FactorBand.aqiUs(51), FactorBand.moderate);
    expect(FactorBand.aqiUs(150), FactorBand.high);
    expect(FactorBand.aqiUs(151), FactorBand.veryHigh);
  });

  test('uv and pollen use their own bounds', () {
    expect(FactorBand.uv(2), FactorBand.low);
    expect(FactorBand.uv(4.5), FactorBand.moderate);
    expect(FactorBand.uv(7.1), FactorBand.veryHigh);
    expect(FactorBand.pollen(3), FactorBand.low);
    expect(FactorBand.pollen(80), FactorBand.high);
    expect(FactorBand.aqiEu(30), FactorBand.moderate);
  });
}
