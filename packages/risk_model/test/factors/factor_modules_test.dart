import 'package:risk_model/risk_model.dart';
import 'package:test/test.dart';

import '../support.dart';

void main() {
  group('ramp', () {
    test('is 0 before, 1 after and linear between', () {
      expect(ramp(0, from: 2, to: 6), 0);
      expect(ramp(2, from: 2, to: 6), 0);
      expect(ramp(4, from: 2, to: 6), 0.5);
      expect(ramp(6, from: 2, to: 6), 1);
      expect(ramp(9, from: 2, to: 6), 1);
    });

    test('runs downwards too', () {
      expect(ramp(-1, from: -2, to: -6), 0);
      expect(ramp(-4, from: -2, to: -6), 0.5);
      expect(ramp(-7, from: -2, to: -6), 1);
    });
  });

  group('scales', () {
    test('scaleHigh', () {
      expect(scaleHigh(1), 0);
      expect(scaleHigh(3), 0);
      expect(scaleHigh(4), 0.5);
      expect(scaleHigh(5), 1);
      expect(scaleHigh(6), 1);
    });

    test('scaleLow', () {
      expect(scaleLow(0), 1);
      expect(scaleLow(1), 1);
      expect(scaleLow(2), 0.5);
      expect(scaleLow(3), 0);
      expect(scaleLow(5), 0);
    });
  });

  group('registry', () {
    test('has one module per factor in order', () {
      expect(allModules.length, Factor.values.length);
      for (var i = 0; i < Factor.values.length; i++) {
        expect(allModules[i].factor, Factor.values[i]);
        expect(moduleFor(Factor.values[i]), allModules[i]);
      }
    });

    test('population weights lie in (0, 1]', () {
      for (final m in allModules) {
        expect(m.populationWeight, greaterThan(0));
        expect(m.populationWeight, lessThanOrEqualTo(1));
      }
    });

    test('every module returns null for an empty day', () {
      for (final m in allModules) {
        expect(m.exposure(day()), isNull, reason: m.factor.id);
      }
    });

    test('every module returns 1 for the worst day and 0 for the calm one', () {
      for (final m in allModules) {
        expect(m.exposure(worstDay), 1, reason: m.factor.id);
        expect(m.exposure(calmDay), 0, reason: m.factor.id);
      }
    });
  });

  group('pressure drop', () {
    const m = PressureDropModule();
    test('boundaries', () {
      expect(m.exposure(day(pressureDelta24h: 0)), 0);
      expect(m.exposure(day(pressureDelta24h: -2)), 0);
      expect(m.exposure(day(pressureDelta24h: -4)), 0.5);
      expect(m.exposure(day(pressureDelta24h: -6)), 1);
      expect(m.exposure(day(pressureDelta24h: -10)), 1);
      expect(m.exposure(day(pressureDelta24h: 5)), 0);
    });
  });

  group('humidity', () {
    const m = HumidityModule();
    test('boundaries', () {
      expect(m.exposure(day(humidity: 65)), 0);
      expect(m.exposure(day(humidity: 75)), 0.5);
      expect(m.exposure(day(humidity: 85)), 1);
    });
  });

  group('temperature swing', () {
    const m = TemperatureSwingModule();
    test('uses the absolute change', () {
      expect(m.exposure(day(temperatureSwing: 3)), 0);
      expect(m.exposure(day(temperatureSwing: -5.5)), 0.5);
      expect(m.exposure(day(temperatureSwing: 8)), 1);
    });
  });

  group('air quality', () {
    const m = AirQualityModule();
    test('boundaries', () {
      expect(m.exposure(day(aqiUs: 50)), 0);
      expect(m.exposure(day(aqiUs: 100)), 0.5);
      expect(m.exposure(day(aqiUs: 150)), 1);
    });
  });

  group('pollen', () {
    const m = PollenModule();
    test('boundaries', () {
      expect(m.exposure(day(pollenMax: 20)), 0);
      expect(m.exposure(day(pollenMax: 60)), 0.5);
      expect(m.exposure(day(pollenMax: 100)), 1);
    });
  });

  group('bright light', () {
    const m = BrightLightModule();
    test('takes the stronger of UV and the answer', () {
      expect(m.exposure(day(uvMax: 3)), 0);
      expect(m.exposure(day(uvMax: 5.5)), 0.5);
      expect(m.exposure(day(uvMax: 8)), 1);
      expect(m.exposure(day(lightExposure: 4)), 0.5);
      expect(m.exposure(day(lightExposure: 5)), 1);
      expect(m.exposure(day(uvMax: 2, lightExposure: 4)), 0.5);
      expect(m.exposure(day(uvMax: 8, lightExposure: 1)), 1);
    });
  });

  group('screen time', () {
    const m = ScreenTimeModule();
    test('answers', () {
      expect(m.exposure(day(screenExposure: 3)), 0);
      expect(m.exposure(day(screenExposure: 4)), 0.5);
      expect(m.exposure(day(screenExposure: 5)), 1);
    });
  });

  group('poor sleep', () {
    const m = PoorSleepModule();
    test('takes the stronger of the answer and minutes', () {
      expect(m.exposure(day(sleepQuality: 3)), 0);
      expect(m.exposure(day(sleepQuality: 2)), 0.5);
      expect(m.exposure(day(sleepQuality: 1)), 1);
      expect(m.exposure(day(sleepMinutes: 420)), 0);
      expect(m.exposure(day(sleepMinutes: 360)), 0.5);
      expect(m.exposure(day(sleepMinutes: 300)), 1);
      expect(m.exposure(day(sleepMinutes: 200)), 1);
      expect(m.exposure(day(sleepQuality: 4, sleepMinutes: 360)), 0.5);
      expect(m.exposure(day(sleepQuality: 1, sleepMinutes: 480)), 1);
    });
  });

  group('stress, neck tension and caffeine', () {
    test('answers', () {
      expect(const StressModule().exposure(day(stress: 4)), 0.5);
      expect(const StressModule().exposure(day(stress: 2)), 0);
      expect(const NeckTensionModule().exposure(day(neckTension: 5)), 1);
      expect(const NeckTensionModule().exposure(day(neckTension: 3)), 0);
      expect(const CaffeineModule().exposure(day(caffeine: 4)), 0.5);
      expect(const CaffeineModule().exposure(day(caffeine: 0)), 0);
    });
  });

  group('alcohol', () {
    const m = AlcoholModule();
    test('ramps from 1 to 5', () {
      expect(m.exposure(day(alcohol: 0)), 0);
      expect(m.exposure(day(alcohol: 1)), 0);
      expect(m.exposure(day(alcohol: 2)), 0.25);
      expect(m.exposure(day(alcohol: 3)), 0.5);
      expect(m.exposure(day(alcohol: 5)), 1);
    });
  });

  group('dehydration', () {
    const m = DehydrationModule();
    test('answers', () {
      expect(m.exposure(day(hydration: 1)), 1);
      expect(m.exposure(day(hydration: 2)), 0.5);
      expect(m.exposure(day(hydration: 3)), 0);
    });
  });

  group('cycle phase', () {
    const m = CyclePhaseModule();
    test('needs both the day and the length', () {
      expect(m.exposure(day(cycleDay: 1)), isNull);
      expect(m.exposure(day(cycleLength: 28)), isNull);
    });

    test('window around the period start', () {
      expect(m.exposure(day(cycleDay: 27, cycleLength: 28)), 1);
      expect(m.exposure(day(cycleDay: 28, cycleLength: 28)), 1);
      expect(m.exposure(day(cycleDay: 1, cycleLength: 28)), 1);
      expect(m.exposure(day(cycleDay: 2, cycleLength: 28)), 1);
      expect(m.exposure(day(cycleDay: 3, cycleLength: 28)), 0.5);
      expect(m.exposure(day(cycleDay: 4, cycleLength: 28)), 0);
      expect(m.exposure(day(cycleDay: 26, cycleLength: 28)), 0);
      expect(m.exposure(day(cycleDay: 15, cycleLength: 28)), 0);
    });
  });
}
