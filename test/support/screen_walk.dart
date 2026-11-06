import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/app/app.dart';
import 'package:migraine_tracker/app/router.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/weather/data/weather_sources.dart';
import 'package:migraine_tracker/features/weather/domain/weather_repository.dart';

import '../features/weather/support/weather_fakes.dart';
import 'pump_app.dart';

/// The fixed "now" of a walk, so the fake forecast lines up.
final DateTime walkNow = DateTime.utc(2026, 11, 6, 9, 30);

/// Screens a walk visits. Each one is scrolled to the end.
final List<String> walkRoutes = [
  AppRoutes.home,
  AppRoutes.environment,
  AppRoutes.risk,
  AppRoutes.insights,
  AppRoutes.insightsMethod,
  AppRoutes.checkin('2026-11-06'),
  AppRoutes.settings,
  AppRoutes.medications,
  AppRoutes.notifications,
  AppRoutes.routines,
  AppRoutes.questionnaires,
  AppRoutes.questionnaire('midas'),
  AppRoutes.report,
  AppRoutes.experiments,
  AppRoutes.account,
  AppRoutes.backup,
  AppRoutes.shareLinks,
  AppRoutes.premium,
  AppRoutes.audit,
  AppRoutes.units,
  AppRoutes.barometer,
  AppRoutes.aboutData,
];

/// Opens every route in [routes] on a small phone (360 × 720) with a loaded
/// forecast, scrolls each to the end and fails on any overflow or endless
/// animation. [onPage] runs at every scroll position.
Future<void> walkScreens(
  WidgetTester tester, {
  required FutureOr<void> Function(String route) onPage,
  Locale? locale,
  Brightness brightness = Brightness.light,
  double textScale = 1,
  List<String>? routes,
}) async {
  if (locale != null) {
    tester.platformDispatcher.localesTestValue = [locale];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
  }
  tester.platformDispatcher
    ..platformBrightnessTestValue = brightness
    ..textScaleFactorTestValue = textScale;
  addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  tester.view
    ..physicalSize = const Size(360 * 3, 720 * 3)
    ..devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  await tester.pumpApp(
    overrides: [
      clockProvider.overrideWithValue(() => walkNow),
      weatherSourceProvider.overrideWithValue(
        FakeWeatherSource(weatherPayload(now: walkNow)),
      ),
      locationSourceProvider.overrideWithValue(
        FakeLocationSource(const LocationFix(lat: 51.5074, lon: -0.1278)),
      ),
      geocoderProvider.overrideWithValue(FakeGeocoder(const [])),
    ],
  );
  final container = ProviderScope.containerOf(
    tester.element(find.byType(MigraineTrackerApp)),
  );

  for (final route in routes ?? walkRoutes) {
    final where = '${locale ?? ''} $route'.trim();
    container.read(routerProvider).go(route);
    await settleOrFail(tester, where);
    expect(tester.takeException(), isNull, reason: where);

    final scrollable = find.byType(Scrollable);
    for (var page = 0; page < 30; page++) {
      await onPage(route);
      if (scrollable.evaluate().isEmpty) break;
      final position = tester.state<ScrollableState>(scrollable.first).position;
      if (position.pixels >= position.maxScrollExtent) break;
      await tester.drag(scrollable.first, const Offset(0, -400));
      await settleOrFail(tester, where);
      expect(tester.takeException(), isNull, reason: where);
    }
  }
}

/// pumpAndSettle that names the screen when an animation never ends.
Future<void> settleOrFail(WidgetTester tester, String where) async {
  try {
    await tester.pumpAndSettle();
    // pumpAndSettle reports an endless animation as a FlutterError.
    // ignore: avoid_catching_errors
  } on FlutterError {
    fail('$where keeps animating');
  }
}
