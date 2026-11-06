import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/app/app.dart';
import 'package:migraine_tracker/app/bootstrap.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';

/// Test helpers shared by widget tests.
extension PumpApp on WidgetTester {
  /// Pumps the whole app (router, theme, localizations) for a flavor.
  Future<void> pumpApp({
    AppFlavor flavor = AppFlavor.dev,
    List<Override> overrides = const [],
  }) async {
    await pumpWidget(
      ProviderScope(
        overrides: [
          appConfigProvider.overrideWithValue(AppConfig(flavor: flavor)),
          ...overrides,
        ],
        child: const MigraineTrackerApp(),
      ),
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
  }) async {
    await pumpWidget(
      ProviderScope(
        overrides: [
          appConfigProvider.overrideWithValue(AppConfig(flavor: flavor)),
          ...overrides,
        ],
        child: MaterialApp(
          theme: theme,
          supportedLocales: AppLocales.supported,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: child,
        ),
      ),
    );
    await pumpAndSettle();
  }
}
