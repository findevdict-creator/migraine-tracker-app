import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/features/weather/domain/pressure_deltas.dart';
import 'package:migraine_tracker/features/weather/domain/weather_entities.dart';

void main() {
  final now = DateTime.utc(2026, 11, 6, 9, 30);

  WeatherHourEntity hour(int hoursBack, double? pressure) => WeatherHourEntity(
    cell: 'c',
    hourUtc: DateTime.utc(2026, 11, 6, 9).subtract(Duration(hours: hoursBack)),
    fetchedAt: now,
    pressureMsl: pressure,
  );

  test('computes 3, 6, 12 and 24 h deltas from the current hour', () {
    final deltas = PressureDeltas.from([
      hour(0, 1010),
      hour(3, 1012.5),
      hour(6, 1013),
      hour(12, 1008),
      hour(24, 1010),
    ], now);
    expect(deltas.current, 1010);
    expect(deltas.h3, -2.5);
    expect(deltas.h6, -3.0);
    expect(deltas.h12, 2.0);
    expect(deltas.h24, 0.0);
    expect(deltas.strongest, -3.0);
    expect(deltas.toJson(), {
      'pressureNow': 1010,
      'delta3h': -2.5,
      'delta6h': -3.0,
      'delta12h': 2.0,
      'delta24h': 0.0,
    });
  });

  test('is null where either end of a window is missing', () {
    final deltas = PressureDeltas.from([
      hour(0, 1010),
      hour(3, null),
      hour(6, 1013),
    ], now);
    expect(deltas.h3, isNull);
    expect(deltas.h6, -3.0);
    expect(deltas.h12, isNull);
    expect(deltas.h24, isNull);
  });

  test('is all null without a current hour', () {
    final deltas = PressureDeltas.from([hour(3, 1012)], now);
    expect(deltas.current, isNull);
    expect(deltas.strongest, isNull);
    expect(deltas.toJson().values, everyElement(isNull));
  });

  test('accepts local times by normalising to the UTC hour', () {
    final local = DateTime(2026, 11, 6, 9, 30).toLocal();
    final deltas = PressureDeltas.from([
      WeatherHourEntity(
        cell: 'c',
        hourUtc: local.toUtc().subtract(
          Duration(minutes: local.toUtc().minute),
        ),
        fetchedAt: now,
        pressureMsl: 1000,
      ),
    ], local);
    expect(deltas.current, 1000);
  });
}
