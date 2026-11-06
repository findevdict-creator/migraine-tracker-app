import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/features/barometer/domain/barometer_entities.dart';
import 'package:migraine_tracker/features/weather/domain/weather_entities.dart';

void main() {
  final base = DateTime.utc(2026, 11, 6, 9);

  WeatherHourEntity station(int hoursBack, double? hpa) => WeatherHourEntity(
    cell: 'c',
    hourUtc: base.subtract(Duration(hours: hoursBack)),
    fetchedAt: base,
    pressureMsl: hpa,
  );

  PressureReading sensor(int hoursBack, double hpa, {int minute = 20}) =>
      PressureReading(
        at: base.subtract(Duration(hours: hoursBack, minutes: -minute)),
        hpa: hpa,
      );

  test('offset is the median of station minus sensor per hour', () {
    final cal = PressureCalibration.from(
      [sensor(0, 1000), sensor(1, 1001), sensor(2, 1002), sensor(3, 990)],
      [
        station(0, 1012),
        station(1, 1013.5),
        station(2, 1014),
        station(3, 1020),
      ],
    );
    // Diffs: 12, 12.5, 12, 30 -> sorted 12, 12, 12.5, 30 -> median 12.25.
    expect(cal.pairs, 4);
    expect(cal.offset, 12.3);
    expect(cal.apply(1000), 1012.3);
    expect(cal.isCalibrated, isTrue);
  });

  test('needs the configured number of pairs', () {
    final cal = PressureCalibration.from(
      [sensor(0, 1000), sensor(1, 1001)],
      [station(0, 1012), station(1, 1013), station(2, 1014)],
    );
    expect(AppThresholds.barometerCalibrationMinPairs, 3);
    expect(cal.pairs, 2);
    expect(cal.isCalibrated, isFalse);
    expect(cal.apply(1000), 1000);
  });

  test(
    'uses the last sample of an hour and skips hours without station data',
    () {
      final cal = PressureCalibration.from(
        [
          sensor(0, 900, minute: 5),
          sensor(0, 1000, minute: 50),
          sensor(1, 1001),
          sensor(2, 1002),
          sensor(3, 1003),
        ],
        [
          station(0, 1012),
          station(1, 1013),
          station(2, null),
          station(3, 1015),
        ],
      );
      // Hour 0 pairs 1000 (not 900): diffs 12, 12, 12 -> median 12.
      expect(cal.pairs, 3);
      expect(cal.offset, 12.0);
    },
  );

  test('display value prefers the calibrated sensor, then the station', () {
    const cal = PressureCalibration(offset: 2, pairs: 3);
    final reading = PressureReading(at: base, hpa: 1000);
    expect(
      BarometerState(
        origin: PressureOrigin.sensor,
        reading: reading,
        stationHpa: 1010,
        calibration: cal,
        trend: const [],
      ).displayHpa,
      1002,
    );
    expect(
      const BarometerState(
        origin: PressureOrigin.station,
        stationHpa: 1010,
        calibration: cal,
        trend: [],
      ).displayHpa,
      1010,
    );
    expect(
      const BarometerState(
        origin: PressureOrigin.none,
        calibration: PressureCalibration.none(),
        trend: [],
      ).displayHpa,
      isNull,
    );
  });
}
