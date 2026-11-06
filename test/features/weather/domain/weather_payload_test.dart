import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/features/weather/domain/weather_payload.dart';

import '../support/weather_fakes.dart';

void main() {
  test('deltaDecode is the inverse of the function encoder', () {
    // Encoded by the TS deltaEncode: [10130, 10131, null, 10129] ->
    // [10130, 1, null, -2].
    expect(deltaDecode([10130, 1, null, -2]), [10130, 10131, null, 10129]);
    expect(deltaDecode([null, null, 5, 1]), [null, null, 5, 6]);
    expect(deltaDecode([]), isEmpty);
  });

  test('decodes hours with pressure for the whole window', () {
    final now = DateTime.utc(2026, 11, 6, 9, 30);
    final payload = WeatherPayload.decode(weatherPayload(now: now));
    expect(payload.cell, '51.5,-0.1');
    expect(payload.fetchedAt, now);
    expect(payload.hours, hasLength(96));
    expect(payload.hours.first.hourUtc, DateTime.utc(2026, 11, 4, 9));
    expect(payload.hours.first.pressureMsl, 1013.0);
    expect(payload.hours[48].hourUtc, DateTime.utc(2026, 11, 6, 9));
    expect(payload.hours[48].pressureMsl, 1013 + 48 * 0.5);
    // Forecast-only fields are null before fxStart and set after.
    expect(payload.hours[47].temperature, isNull);
    expect(payload.hours[48].temperature, 10.0);
    expect(payload.hours[49].temperature, 10.1);
    expect(payload.hours[48].humidity, 60);
    expect(payload.hours[48].uv, 1.5);
    expect(payload.hours[49].uv, isNull);
    expect(payload.hours[48].weatherCode, 2);
  });

  test('decodes environment days including partial pollen', () {
    final now = DateTime.utc(2026, 11, 6, 9, 30);
    final payload = WeatherPayload.decode(weatherPayload(now: now));
    expect(payload.days, hasLength(2));
    final today = payload.days.first;
    expect(today.date, '2026-11-06');
    expect(today.aqiUs, 42);
    expect(today.pm25, 8.5);
    expect(today.ozone, 60.0);
    expect(today.uvMax, 4.5);
    expect(today.daylightMinutes, 540);
    expect(today.sunrise, DateTime.utc(2026, 11, 6, 7, 12));
    expect(today.pollen, {'grass': 3.0});
    final tomorrow = payload.days.last;
    expect(tomorrow.aqiEu, isNull);
    expect(tomorrow.sunrise, isNull);
    expect(tomorrow.pollen, isNull);
  });

  test('rejects an unknown format version', () {
    expect(
      () => WeatherPayload.decode({'v': 2}),
      throwsA(isA<FormatException>()),
    );
  });
}
