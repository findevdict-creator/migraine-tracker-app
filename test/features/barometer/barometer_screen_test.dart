import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/barometer/domain/barometer_entities.dart';
import 'package:migraine_tracker/features/barometer/domain/barometer_source.dart';
import 'package:migraine_tracker/features/barometer/presentation/barometer_screen.dart';
import 'package:migraine_tracker/features/weather/data/weather_sources.dart';
import 'package:migraine_tracker/features/weather/domain/weather_repository.dart';

import '../../support/pump_app.dart';
import '../../support/test_database.dart';
import '../weather/support/weather_fakes.dart';
import 'support/barometer_fakes.dart';

void main() {
  late AppDatabase db;
  late FakeBarometer barometer;
  final now = DateTime.utc(2026, 11, 6, 9, 30);

  setUp(() {
    db = newTestDatabase();
    barometer = FakeBarometer();
  });

  tearDown(() async {
    await barometer.close();
    await db.close();
  });

  String textOf(WidgetTester tester, String key) =>
      tester.widget<Text>(find.byKey(ValueKey(key))).data!;

  Future<void> open(WidgetTester tester, BarometerSource source) async {
    await tester.pumpApp(
      database: db,
      barometer: source,
      overrides: [
        clockProvider.overrideWithValue(() => now),
        weatherSourceProvider.overrideWithValue(
          FakeWeatherSource(weatherPayload(now: now)),
        ),
        locationSourceProvider.overrideWithValue(
          FakeLocationSource(const LocationFix(lat: 51.5, lon: -0.1)),
        ),
      ],
    );
    await tester.tap(find.byKey(const ValueKey('environment-card')));
    await tester.pumpAndSettle();
    await tester.scrollToKey('env-barometer');
    await tester.tap(find.byKey(const ValueKey('env-barometer')));
    await tester.pumpAndSettle();
    expect(find.byType(BarometerScreen), findsOneWidget);
  }

  testWidgets('shows the live sensor value and updates with new readings', (
    tester,
  ) async {
    await open(tester, barometer);
    barometer.emit(PressureReading(at: now, hpa: 1001.2));
    await tester.pumpAndSettle();
    expect(textOf(tester, 'baro-value'), '1001.2 hPa');
    expect(textOf(tester, 'baro-source'), "From this device's sensor");
    expect(textOf(tester, 'baro-offset'), contains('Not calibrated yet'));

    barometer.emit(PressureReading(at: now, hpa: 1003.7));
    await tester.pumpAndSettle();
    expect(textOf(tester, 'baro-value'), '1003.7 hPa');
  });

  testWidgets('falls back to the nearest station without a sensor', (
    tester,
  ) async {
    await open(tester, const NoBarometer());
    expect(textOf(tester, 'baro-value'), '1037.0 hPa');
    expect(textOf(tester, 'baro-source'), 'From the nearest station');
    expect(find.byKey(const ValueKey('baro-trend')), findsOneWidget);
  });
}
