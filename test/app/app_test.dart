import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/features/home/presentation/home_screen.dart';

import '../support/pump_app.dart';

void main() {
  group('MigraineTrackerApp', () {
    testWidgets('boots to the home screen', (tester) async {
      await tester.pumpApp();
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('shows the flavor in the title for non-prod builds', (
      tester,
    ) async {
      await tester.pumpApp();
      expect(find.text(AppIdentity.displayName(AppFlavor.dev)), findsOneWidget);
    });

    testWidgets('shows the plain product name for prod builds', (tester) async {
      await tester.pumpApp(flavor: AppFlavor.prod);
      expect(find.text(AppIdentity.name), findsOneWidget);
      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.debugShowCheckedModeBanner, isFalse);
    });

    testWidgets('uses the seed colour from the central config', (tester) async {
      await tester.pumpApp();
      final theme = Theme.of(tester.element(find.byType(HomeScreen)));
      final expected = ColorScheme.fromSeed(seedColor: AppThemeTokens.seed);
      expect(theme.colorScheme.primary, expected.primary);
    });
  });
}
