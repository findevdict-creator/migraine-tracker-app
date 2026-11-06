import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/premium/presentation/premium_screen.dart';
import 'package:migraine_tracker/features/weather/data/weather_sources.dart';
import 'package:migraine_tracker/features/weather/domain/weather_repository.dart';
import 'package:migraine_tracker/features/weather/presentation/about_data_screen.dart';

import '../../../support/pump_app.dart';
import '../../../support/test_database.dart';
import '../support/weather_fakes.dart';

void main() {
  late AppDatabase db;
  late FakeWeatherSource source;
  var now = DateTime.utc(2026, 11, 6, 9, 30);

  setUp(() {
    now = DateTime.utc(2026, 11, 6, 9, 30);
    db = newTestDatabase();
    source = FakeWeatherSource(weatherPayload(now: now));
  });

  tearDown(() => db.close());

  Future<void> openEnvironment(
    WidgetTester tester, {
    LocationFix? fix,
    AppFlavor flavor = AppFlavor.dev,
  }) async {
    await tester.pumpApp(
      database: db,
      flavor: flavor,
      overrides: [
        clockProvider.overrideWithValue(() => now),
        weatherSourceProvider.overrideWithValue(source),
        locationSourceProvider.overrideWithValue(FakeLocationSource(fix)),
      ],
    );
    await tester.tap(find.byKey(const ValueKey('environment-card')));
    await tester.pumpAndSettle();
    await tester.scrollToKey('env-factors');
  }

  String rowText(WidgetTester tester, String key) {
    final texts = find.descendant(
      of: find.byKey(ValueKey('factor-$key')),
      matching: find.byType(Text),
    );
    return tester.widget<Text>(texts.last).data!;
  }

  testWidgets('shows every factor the region has data for', (tester) async {
    await openEnvironment(tester, fix: const LocationFix(lat: 51.5, lon: -0.1));
    expect(rowText(tester, 'aqi-us'), '42 (low)');
    expect(rowText(tester, 'aqi-eu'), '30 (moderate)');
    expect(rowText(tester, 'pm'), '8.5 / 12.0 µg/m³');
    expect(rowText(tester, 'ozone'), '60 µg/m³');
    expect(rowText(tester, 'pollen'), 'grass low');
    expect(find.text('Pollen (Europe only)'), findsOneWidget);
    expect(rowText(tester, 'uv'), '4.5 (moderate)');
    expect(rowText(tester, 'daylight'), '9 h 0 min');
    expect(rowText(tester, 'sun'), isNotEmpty);
    expect(find.byKey(const ValueKey('env-factors-empty')), findsNothing);
  });

  testWidgets('without Premium the extended factors give way to one line '
      'that opens the paywall; the rest stay', (tester) async {
    await openEnvironment(
      tester,
      fix: const LocationFix(lat: 51.5, lon: -0.1),
      flavor: AppFlavor.staging,
    );
    expect(rowText(tester, 'aqi-us'), '42 (low)');
    expect(rowText(tester, 'uv'), '4.5 (moderate)');
    for (final key in AppPremium.extendedFactorKeys) {
      expect(find.byKey(ValueKey('factor-$key')), findsNothing, reason: key);
    }
    await tester.scrollToKey('factor-premium-open');
    await tester.tap(find.byKey(const ValueKey('factor-premium-open')));
    await tester.pumpAndSettle();
    expect(find.byType(PremiumScreen), findsOneWidget);
  });

  testWidgets('hides factors the region lacks, and the card says so when '
      'there is nothing', (tester) async {
    // Tomorrow's entry in the fixture is sparse.
    now = now.add(const Duration(days: 1));
    source.payload = weatherPayload(now: now.subtract(const Duration(days: 1)));
    await openEnvironment(tester, fix: const LocationFix(lat: 51.5, lon: -0.1));
    expect(rowText(tester, 'aqi-us'), '50 (low)');
    expect(find.byKey(const ValueKey('factor-aqi-eu')), findsNothing);
    expect(find.byKey(const ValueKey('factor-pm')), findsNothing);
    expect(find.byKey(const ValueKey('factor-pollen')), findsNothing);
    expect(find.byKey(const ValueKey('factor-sun')), findsNothing);
    expect(rowText(tester, 'uv'), '3.0 (moderate)');
  });

  testWidgets('without a location the factors card shows the empty note', (
    tester,
  ) async {
    await openEnvironment(tester);
    expect(find.byKey(const ValueKey('env-factors-empty')), findsOneWidget);
  });

  testWidgets('About the data lists every configured source', (tester) async {
    await openEnvironment(tester, fix: const LocationFix(lat: 51.5, lon: -0.1));
    await tester.tap(find.byKey(const ValueKey('env-about-data')));
    await tester.pumpAndSettle();
    expect(find.byType(AboutDataScreen), findsOneWidget);
    for (final source in AppDataSources.entries) {
      expect(find.byKey(ValueKey('source-${source.id}')), findsOneWidget);
    }
    expect(find.textContaining('Europe only'), findsWidgets);
    expect(find.text('Open-Meteo pollen (CAMS)'), findsOneWidget);
  });
}
