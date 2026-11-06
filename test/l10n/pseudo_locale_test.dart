import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/app/app.dart';
import 'package:migraine_tracker/app/router.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/weather/data/weather_sources.dart';
import 'package:migraine_tracker/features/weather/domain/weather_repository.dart';

import '../features/weather/support/weather_fakes.dart';
import '../support/pump_app.dart';

/// Screens visited in the pseudo-locale. Each one is scrolled to the end.
const List<String> _routes = [
  AppRoutes.home,
  AppRoutes.environment,
  AppRoutes.risk,
  AppRoutes.insights,
  AppRoutes.insightsMethod,
  AppRoutes.settings,
  AppRoutes.medications,
  AppRoutes.notifications,
  AppRoutes.routines,
  AppRoutes.questionnaires,
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

/// Words allowed on screen without passing through the translation files:
/// the app's name, the support address, units, product names and what the
/// date and number formats print.
final RegExp _allowed = RegExp(
  '${RegExp.escape(AppIdentity.name)}( \\((dev|staging)\\))?|'
  r'[\w.+-]+@[\w.-]+|'
  r'\b(hPa|inHg|mmHg|PDF|CSV|Apple|Google|Premium|Health|Connect|MIDAS|HIT|'
  'AM|PM|Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec|'
  'January|February|March|April|June|July|August|September|October|'
  'November|December|Mon|Tue|Wed|Thu|Fri|Sat|Sun|'
  r'Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)\b',
);

/// The mark tool/pseudo_arb.dart opens every pseudo message with.
const pseudoOpen = '⟦';

void main() {
  testWidgets('every screen reads in the pseudo-locale without clipping', (
    tester,
  ) async {
    final untranslated = await _visitAll(tester, AppLocales.pseudo);
    expect(untranslated, isEmpty);
  });

  // The real translations run longer than English too (German most of all);
  // each one must fit on a small phone.
  for (final locale in AppLocales.supported.skip(1)) {
    testWidgets('every screen fits in $locale', (tester) async {
      await _visitAll(tester, locale);
    });
  }
}

/// Opens every route in [_routes] in [locale] on a small phone, scrolls each
/// to the end and fails on any overflow. Returns, for the pseudo-locale,
/// the visible copy that skipped the translation files.
Future<Set<String>> _visitAll(WidgetTester tester, Locale locale) async {
  final pseudo = locale == AppLocales.pseudo;
  tester.platformDispatcher.localesTestValue = [locale];
  tester.view
    ..physicalSize = const Size(360 * 3, 720 * 3)
    ..devicePixelRatio = 3;
  addTearDown(tester.platformDispatcher.clearLocalesTestValue);
  addTearDown(tester.view.reset);

  // A loaded forecast, so the weather screens show their full content.
  final now = DateTime.utc(2026, 11, 6, 9, 30);
  await tester.pumpApp(
    overrides: [
      clockProvider.overrideWithValue(() => now),
      weatherSourceProvider.overrideWithValue(
        FakeWeatherSource(weatherPayload(now: now)),
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
  final untranslated = <String>{};

  for (final route in _routes) {
    final where = '$locale $route';
    container.read(routerProvider).go(route);
    await _settle(tester, where);
    expect(tester.takeException(), isNull, reason: where);
    if (pseudo) {
      expect(find.textContaining(pseudoOpen), findsWidgets, reason: where);
    }

    final scrollable = find.byType(Scrollable);
    for (var page = 0; page < 30; page++) {
      if (pseudo) untranslated.addAll(_plainCopy(tester, route));
      if (scrollable.evaluate().isEmpty) break;
      final state = tester.state<ScrollableState>(scrollable.first);
      final position = state.position;
      if (position.pixels >= position.maxScrollExtent) break;
      await tester.drag(scrollable.first, const Offset(0, -400));
      await _settle(tester, where);
      expect(tester.takeException(), isNull, reason: where);
    }
  }
  return untranslated;
}

Future<void> _settle(WidgetTester tester, String where) async {
  try {
    await tester.pumpAndSettle();
    // pumpAndSettle reports an endless animation as a FlutterError.
    // ignore: avoid_catching_errors
  } on FlutterError {
    fail('$where keeps animating');
  }
}

/// Visible text with a plain ASCII word outside the pseudo marks: copy that
/// did not come from the translation files.
Iterable<String> _plainCopy(WidgetTester tester, String route) sync* {
  for (final element in find.byType(RichText).evaluate()) {
    final render = element.renderObject;
    if (render is! RenderParagraph || !render.attached) continue;
    final text = render.text.toPlainText();
    final outside = text
        .replaceAll(RegExp('⟦[^⟧]*⟧', dotAll: true), ' ')
        // A pseudo message split by the widget (a list of steps) leaves an
        // opening or closing half.
        .replaceAll(RegExp(r'⟦[^⟧]*$', dotAll: true), ' ')
        .replaceAll(RegExp('^[^⟦]*⟧', dotAll: true), ' ')
        .replaceAll(_allowed, ' ');
    if (RegExp('[A-Za-z]{3,}').hasMatch(outside)) yield '$route: $text';
  }
}
