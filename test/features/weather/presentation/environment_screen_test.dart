import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/db/database_provider.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/weather/application/weather_sync.dart';
import 'package:migraine_tracker/features/weather/data/weather_sources.dart';
import 'package:migraine_tracker/features/weather/domain/weather_repository.dart';
import 'package:migraine_tracker/features/weather/presentation/environment_screen.dart';
import 'package:migraine_tracker/features/weather/presentation/pressure_chart.dart';

import '../../../support/pump_app.dart';
import '../../../support/test_database.dart';
import '../support/weather_fakes.dart';

void main() {
  late AppDatabase db;
  late FakeWeatherSource source;
  late FakeLocationSource location;
  late FakeGeocoder geocoder;
  var now = DateTime.utc(2026, 11, 6, 9, 30);

  setUp(() {
    now = DateTime.utc(2026, 11, 6, 9, 30);
    db = newTestDatabase();
    source = FakeWeatherSource(weatherPayload(now: now));
    location = FakeLocationSource(
      const LocationFix(lat: 51.5074, lon: -0.1278),
    );
    geocoder = FakeGeocoder(const [
      GeocodeResult(
        name: 'Paris',
        admin: 'Île-de-France',
        country: 'France',
        lat: 48.8566,
        lon: 2.3522,
      ),
    ]);
  });

  tearDown(() => db.close());

  List<Override> overrides() => [
    clockProvider.overrideWithValue(() => now),
    weatherSourceProvider.overrideWithValue(source),
    locationSourceProvider.overrideWithValue(location),
    geocoderProvider.overrideWithValue(geocoder),
  ];

  Future<void> pumpHome(WidgetTester tester) =>
      tester.pumpApp(database: db, overrides: overrides());

  Future<void> openEnvironment(WidgetTester tester) async {
    await pumpHome(tester);
    await tester.tap(find.byKey(const ValueKey('environment-card')));
    await tester.pumpAndSettle();
    expect(find.byType(EnvironmentScreen), findsOneWidget);
  }

  String textOf(WidgetTester tester, String key) =>
      tester.widget<Text>(find.byKey(ValueKey(key))).data!;

  /// The location row sits below the lazy factors card.
  Future<String> locationText(WidgetTester tester) async {
    await tester.scrollToKey('env-location');
    return textOf(tester, 'env-location');
  }

  testWidgets('home card and screen are populated on first open', (
    tester,
  ) async {
    await openEnvironment(tester);
    expect(source.calls, [(51.5, -0.1)]);
    expect(textOf(tester, 'env-pressure-now'), '1037.0 hPa');
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('env-delta-3h')),
        matching: find.text('+1.5 hPa'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('env-delta-24h')),
        matching: find.text('+12.0 hPa'),
      ),
      findsOneWidget,
    );
    expect(textOf(tester, 'env-age'), 'Updated just now');
    expect(find.byType(PressureChart), findsOneWidget);
    expect(find.byKey(const ValueKey('env-stale')), findsNothing);
    expect(find.byKey(const ValueKey('env-offline')), findsNothing);
    expect(await locationText(tester), 'Using your approximate location');
    await tester.scrollToKey('env-attribution');
    expect(find.byKey(const ValueKey('env-attribution')), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(textOf(tester, 'environment-card-summary'), '1037.0 hPa, rising');
  });

  testWidgets('airplane mode shows the cached forecast with its age', (
    tester,
  ) async {
    // Seed the cache four hours ago, then lose the network.
    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db), ...overrides()],
    );
    await container.read(weatherSyncProvider).refresh();
    container.dispose();
    now = now.add(const Duration(hours: 4));
    source.error = Exception('no network');

    await openEnvironment(tester);
    expect(source.calls, hasLength(2));
    // 13:00 UTC is hour index 52 of the seeded series.
    expect(textOf(tester, 'env-pressure-now'), '1039.0 hPa');
    expect(textOf(tester, 'env-age'), 'Updated 4 h ago');
    expect(find.byKey(const ValueKey('env-offline')), findsOneWidget);
  });

  testWidgets('with no location and no cache the empty state explains', (
    tester,
  ) async {
    location.fix = null;
    await openEnvironment(tester);
    expect(source.calls, isEmpty);
    expect(find.byKey(const ValueKey('env-empty')), findsOneWidget);
    expect(await locationText(tester), 'No location set');
  });

  testWidgets('a typed city becomes the manual location', (tester) async {
    await openEnvironment(tester);
    source.payload = weatherPayload(now: now, cell: '48.9,2.4');

    await tester.scrollToKey('env-choose-city');
    await tester.tap(find.byKey(const ValueKey('env-choose-city')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('city-query')), 'Par');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    expect(geocoder.queries, ['Par']);
    await tester.tap(find.byKey(const ValueKey('city-result-0')));
    await tester.pumpAndSettle();

    expect(await locationText(tester), 'Using Paris, Île-de-France, France');
    expect(source.calls.last, (48.9, 2.4));
    await tester.scrollToKey('env-pressure-now');
    expect(textOf(tester, 'env-pressure-now'), '1037.0 hPa');

    await tester.scrollToKey('env-use-gps');
    await tester.tap(find.byKey(const ValueKey('env-use-gps')));
    await tester.pumpAndSettle();
    expect(await locationText(tester), 'Using your approximate location');
  });

  testWidgets('a failed city search says so', (tester) async {
    geocoder.error = Exception('offline');
    await openEnvironment(tester);
    await tester.scrollToKey('env-choose-city');
    await tester.tap(find.byKey(const ValueKey('env-choose-city')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('city-query')), 'Par');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('city-failed')), findsOneWidget);
  });
}
