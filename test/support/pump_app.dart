import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/app/app.dart';
import 'package:migraine_tracker/app/bootstrap.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/db/database_provider.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/features/barometer/data/barometer_sources.dart';
import 'package:migraine_tracker/features/barometer/domain/barometer_source.dart';

import 'test_database.dart';

/// Test helpers shared by widget tests.
extension PumpApp on WidgetTester {
  /// Pumps the whole app (router, theme, localizations) for a flavor.
  ///
  /// Uses a fresh in-memory database unless [database] is given, and no
  /// barometer unless [barometer] is given (the platform sensor has no
  /// implementation under test).
  Future<void> pumpApp({
    AppFlavor flavor = AppFlavor.dev,
    List<Override> overrides = const [],
    AppDatabase? database,
    BarometerSource barometer = const NoBarometer(),
  }) async {
    await pumpWidget(
      UncontrolledProviderScope(
        container: _container(flavor, database, barometer, overrides),
        child: const MigraineTrackerApp(),
      ),
    );
    await pumpAndSettle();
  }

  /// Scrolls the first scrollable until the widget with [key] is built and
  /// visible. Screens are lazy lists, so far-down fields do not exist until
  /// scrolled to.
  Future<void> scrollToKey(String key) async {
    await scrollUntilVisible(
      find.byKey(ValueKey(key)),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await pumpAndSettle();
  }

  /// Pumps a single widget inside a MaterialApp with localizations and the
  /// config provider, for screen and widget tests that do not need routing.
  Future<void> pumpLocalized(
    Widget child, {
    AppFlavor flavor = AppFlavor.dev,
    List<Override> overrides = const [],
    ThemeData? theme,
    AppDatabase? database,
    BarometerSource barometer = const NoBarometer(),
  }) async {
    await pumpWidget(
      UncontrolledProviderScope(
        container: _container(flavor, database, barometer, overrides),
        child: MaterialApp(
          theme: theme,
          supportedLocales: AppLocales.supported,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Scaffold(body: child),
        ),
      ),
    );
    await pumpAndSettle();
  }
}

/// A container that outlives the widget tree. Disposing it in the test's
/// tear-down (outside the fake-async zone) keeps drift's deferred
/// stream-close timers from tripping the pending-timer check.
ProviderContainer _container(
  AppFlavor flavor,
  AppDatabase? database,
  BarometerSource barometer,
  List<Override> overrides,
) {
  final container = ProviderContainer(
    overrides: [
      appConfigProvider.overrideWithValue(AppConfig(flavor: flavor)),
      _databaseOverride(database),
      barometerSourceProvider.overrideWithValue(barometer),
      ...overrides,
    ],
  );
  addTearDown(container.dispose);
  return container;
}

Override _databaseOverride(AppDatabase? database) => database != null
    ? appDatabaseProvider.overrideWithValue(database)
    : appDatabaseProvider.overrideWith((ref) {
        final db = newTestDatabase();
        ref.onDispose(db.close);
        return db;
      });
