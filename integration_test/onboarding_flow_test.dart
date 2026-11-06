// Device integration test: a fresh install reaches the populated
// environment screen in under 60 seconds, using the real location prompt
// and the real cache function (dev flavor, emulator or deployed).
//
// Run on a device or emulator with the dev env file:
//   flutter test integration_test/onboarding_flow_test.dart \
//     --flavor dev --dart-define-from-file=env/dev.json -d <device>
// Accept the approximate-location prompt when it appears. Not run in the
// PR workflow (no emulator); listed in the parity checklist for phase 15.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:migraine_tracker/app/bootstrap.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/features/weather/presentation/environment_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('new install to populated environment screen under 60 s', (
    tester,
  ) async {
    final stopwatch = Stopwatch()..start();
    await bootstrap(AppFlavor.dev);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    Future<void> tapKey(String key) async {
      await tester.tap(find.byKey(ValueKey(key)));
      await tester.pumpAndSettle(const Duration(seconds: 2));
    }

    await tapKey('onboarding-next');
    await tapKey('onboarding-use-location');
    // The system prompt is answered by the person running the test.
    await tester.pumpAndSettle(const Duration(seconds: 10));
    await tapKey('onboarding-next');
    await tapKey('onboarding-next');
    await tapKey('onboarding-next');

    // Wait for the first fetch to land, up to the budget.
    while (stopwatch.elapsed < const Duration(seconds: 60)) {
      await tester.pump(const Duration(seconds: 1));
      if (find
          .byKey(const ValueKey('env-pressure-now'))
          .evaluate()
          .isNotEmpty) {
        break;
      }
    }
    stopwatch.stop();
    expect(find.byType(EnvironmentScreen), findsOneWidget);
    expect(find.byKey(const ValueKey('env-pressure-now')), findsOneWidget);
    expect(stopwatch.elapsed, lessThan(const Duration(seconds: 60)));
  });
}
