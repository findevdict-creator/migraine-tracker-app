import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/app/app.dart';
import 'package:migraine_tracker/app/router.dart';
import 'package:migraine_tracker/core/settings/settings_keys.dart';
import 'package:migraine_tracker/core/settings/settings_repository.dart';
import 'package:migraine_tracker/core/theme/app_motion.dart';
import 'package:migraine_tracker/core/theme/app_theme.dart';

import '../support/pump_app.dart';

void main() {
  Future<ProviderContainer> app(WidgetTester tester) async {
    await tester.pumpApp();
    return ProviderScope.containerOf(
      tester.element(find.byType(MigraineTrackerApp)),
    );
  }

  bool animationsOff(WidgetTester tester) => MediaQuery.disableAnimationsOf(
    tester.element(find.byType(Scaffold).last),
  );

  testWidgets('the Settings switch is saved and turns animations off', (
    tester,
  ) async {
    final container = await app(tester);
    container.read(routerProvider).go(AppRoutes.settings);
    await tester.pumpAndSettle();
    expect(animationsOff(tester), isFalse);

    await tester.scrollToKey('settings-reduce-motion');
    await tester.tap(find.byKey(const ValueKey('settings-reduce-motion')));
    await tester.pumpAndSettle();

    expect(animationsOff(tester), isTrue);
    expect(
      await container
          .read(settingsRepositoryProvider)
          .read<bool>(SettingsKeys.reduceMotion),
      isTrue,
    );
  });

  testWidgets('with reduce motion screens change without a transition', (
    tester,
  ) async {
    final route = MaterialPageRoute<void>(builder: (_) => const SizedBox());
    const child = SizedBox(key: ValueKey('page'));
    final results = <bool, Widget>{};
    for (final off in [true, false]) {
      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(disableAnimations: off),
          child: Builder(
            builder: (context) {
              results[off] = appPageTransitions
                  .builders[TargetPlatform.android]!
                  .buildTransitions(
                    route,
                    context,
                    const AlwaysStoppedAnimation<double>(0.5),
                    kAlwaysDismissedAnimation,
                    child,
                  );
              return const SizedBox();
            },
          ),
        ),
      );
    }
    // The page itself, with nothing animating around it.
    expect(results[true], same(child));
    expect(results[false], isNot(same(child)));
    expect(AppTheme.light().pageTransitionsTheme, same(appPageTransitions));
  });

  testWidgets('the phone setting alone also turns animations off', (
    tester,
  ) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await app(tester);
    expect(animationsOff(tester), isTrue);
  });
}
