import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/settings/settings_keys.dart';
import 'package:migraine_tracker/core/settings/settings_repository.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/health/data/health_source_impl.dart';
import 'package:migraine_tracker/features/health/domain/health_entities.dart';
import 'package:migraine_tracker/features/home/presentation/home_screen.dart';
import 'package:migraine_tracker/features/onboarding/presentation/level_explainer.dart';
import 'package:migraine_tracker/features/onboarding/presentation/onboarding_screen.dart';
import 'package:migraine_tracker/features/weather/data/weather_sources.dart';
import 'package:migraine_tracker/features/weather/domain/weather_repository.dart';
import 'package:migraine_tracker/features/weather/presentation/environment_screen.dart';

import '../../support/pump_app.dart';
import '../../support/test_database.dart';
import '../health/support/health_fakes.dart';
import '../weather/support/weather_fakes.dart';

void main() {
  late AppDatabase db;
  late FakeWeatherSource weather;
  late FakeHealthSource health;
  final now = DateTime.utc(2026, 11, 6, 9, 30);

  setUp(() {
    db = newTestDatabase();
    weather = FakeWeatherSource(weatherPayload(now: now));
    health = FakeHealthSource();
  });

  tearDown(() => db.close());

  Future<void> freshInstall(WidgetTester tester, {LocationFix? fix}) =>
      tester.pumpApp(
        database: db,
        onboarded: false,
        overrides: [
          clockProvider.overrideWithValue(() => now),
          weatherSourceProvider.overrideWithValue(weather),
          locationSourceProvider.overrideWithValue(FakeLocationSource(fix)),
          healthSourceProvider.overrideWithValue(health),
        ],
      );

  String textOf(WidgetTester tester, String key) =>
      tester.widget<Text>(find.byKey(ValueKey(key))).data!;

  testWidgets('a new install lands on the populated environment screen in '
      'under 60 seconds', (tester) async {
    final stopwatch = Stopwatch()..start();
    await freshInstall(
      tester,
      fix: const LocationFix(lat: 51.5074, lon: -0.1278),
    );
    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(find.byType(LevelExplainer), findsOneWidget);
    expect(textOf(tester, 'onboarding-step'), 'Step 1 of 4');

    await tester.tap(find.byKey(const ValueKey('onboarding-next')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('onboarding-use-location')));
    await tester.pumpAndSettle();
    expect(
      textOf(tester, 'onboarding-location-status'),
      'Using your approximate location',
    );
    expect(weather.calls, [(51.5, -0.1)]);

    await tester.tap(find.byKey(const ValueKey('onboarding-next')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('onboarding-health-sleep')));
    await tester.pumpAndSettle();
    expect(health.readRequests, [
      {HealthType.sleep},
    ]);

    await tester.tap(find.byKey(const ValueKey('onboarding-next')));
    await tester.pumpAndSettle();
    expect(textOf(tester, 'onboarding-step'), 'Step 4 of 4');
    expect(
      find.byKey(const ValueKey('onboarding-reminder-time')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('onboarding-next')));
    await tester.pumpAndSettle();
    stopwatch.stop();

    expect(find.byType(EnvironmentScreen), findsOneWidget);
    expect(textOf(tester, 'env-pressure-now'), '1037.0 hPa');
    expect(stopwatch.elapsed, lessThan(const Duration(seconds: 60)));

    final done = await SettingsRepository(db)
        .read<bool>(SettingsKeys.onboardingCompleted);
    expect(done, isTrue);
  });

  testWidgets('skip marks onboarding done and goes to the environment screen', (
    tester,
  ) async {
    await freshInstall(tester);
    await tester.tap(find.byKey(const ValueKey('onboarding-skip')));
    await tester.pumpAndSettle();
    expect(find.byType(EnvironmentScreen), findsOneWidget);
    expect(find.byKey(const ValueKey('env-empty')), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(OnboardingScreen), findsNothing);
  });

  testWidgets('an onboarded install never sees the flow', (tester) async {
    await SettingsRepository(db).write(SettingsKeys.onboardingCompleted, true);
    await freshInstall(tester);
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(OnboardingScreen), findsNothing);
  });

  testWidgets('the explainer opens from settings', (tester) async {
    await tester.pumpApp(database: db);
    await tester.tap(find.byKey(const ValueKey('home-settings')));
    await tester.pumpAndSettle();
    await tester.scrollToKey('settings-explainer');
    await tester.tap(find.byKey(const ValueKey('settings-explainer')));
    await tester.pumpAndSettle();
    expect(find.byType(ExplainerScreen), findsOneWidget);
    expect(find.textContaining('not a forecast of an attack'), findsOneWidget);
  });
}
