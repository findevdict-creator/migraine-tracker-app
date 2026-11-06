import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/util/clock.dart';

import '../support/pump_app.dart';
import '../support/screen_walk.dart';

/// What VoiceOver and TalkBack meet, swipe by swipe, on the two screens
/// used mid-attack and every day: the attack screen and the check-in. The
/// view is tall so the whole screen is built at once and the traversal
/// covers it all.
void main() {
  final l10n = lookupAppLocalizations(AppLocales.fallback);

  Future<void> tall(WidgetTester tester) async {
    tester.view
      ..physicalSize = const Size(400 * 3, 3000 * 3)
      ..devicePixelRatio = 3;
    addTearDown(tester.view.reset);
  }

  Future<void> openAttack(WidgetTester tester) async {
    await tester.pumpApp(
      overrides: [clockProvider.overrideWithValue(() => walkNow)],
    );
    await tester.tap(find.byKey(const ValueKey('start-attack')));
    await tester.pumpAndSettle();
  }

  testWidgets('attack screen: every stop is labelled, in reading order', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tall(tester);
    await openAttack(tester);

    final stops = _stops(tester);
    _expectAllLabelled(stops);

    final labels = [for (final n in stops) n.label];
    int at(String label) => labels.indexWhere((l) => l.startsWith(label));
    // Top to bottom, as on screen.
    expect(at(l10n.attackIntensity), greaterThanOrEqualTo(0));
    expect(at(l10n.attackIntensity), lessThan(at(l10n.headLeftTemple)));
    expect(at(l10n.headLeftTemple), lessThan(at(l10n.symptomAura)));
    expect(at(l10n.symptomAura), lessThan(at(l10n.phaseProdrome)));
    expect(at(l10n.phaseProdrome), lessThan(at(l10n.attackEnd)));

    // The intensity is one stop with the scale's own number and both
    // ends, changed by swiping up or down.
    bool isSlider(SemanticsNode n) =>
        n.getSemanticsData().hasAction(SemanticsAction.increase) &&
        n.label.startsWith(l10n.attackIntensity);
    final intensity = stops.firstWhere(isSlider);
    final data = intensity.getSemanticsData();
    expect(data.value, '0');
    expect(data.hint, contains(l10n.attackIntensityLow));
    expect(data.hint, contains(l10n.attackIntensityHigh));
    expect(data.hasAction(SemanticsAction.increase), isTrue);
    intensity.owner!.performAction(intensity.id, SemanticsAction.increase);
    await tester.pumpAndSettle();
    final after = _stops(tester).firstWhere(isSlider);
    expect(after.getSemanticsData().value, '1');

    // A head region says it is a button and whether it is selected.
    final temple = stops.firstWhere((n) => n.label == l10n.headLeftTemple);
    expect(temple.getSemanticsData().flagsCollection.isButton, isTrue);
    expect(
      temple.getSemanticsData().flagsCollection.isSelected,
      isNot(Tristate.none),
    );
    handle.dispose();
  });

  testWidgets('check-in: every question and answer is labelled', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tall(tester);
    await walkScreens(
      tester,
      routes: ['/checkin/2026-11-06'],
      onPage: (_) => _expectAllLabelled(_stops(tester)),
    );
    handle.dispose();
  });

  testWidgets('attack screen fits at 200% text', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    tester.view
      ..physicalSize = const Size(360 * 3, 720 * 3)
      ..devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await openAttack(tester);
    final list = find.byType(Scrollable).first;
    for (var page = 0; page < 30; page++) {
      expect(tester.takeException(), isNull);
      final position = tester.state<ScrollableState>(list).position;
      if (position.pixels >= position.maxScrollExtent) break;
      await tester.drag(list, const Offset(0, -400));
      await tester.pumpAndSettle();
    }
    expect(tester.takeException(), isNull);
    expect(find.byKey(const ValueKey('attack-end')), findsOneWidget);
  });
}

/// The nodes a screen reader stops on, in its order.
List<SemanticsNode> _stops(WidgetTester tester) => [
  for (final node in tester.semantics.simulatedAccessibilityTraversal())
    if (!node.isInvisible) node,
];

/// Every stop that does something (tap, slide, type) says what it is.
void _expectAllLabelled(List<SemanticsNode> stops) {
  const actions = [
    SemanticsAction.tap,
    SemanticsAction.increase,
    SemanticsAction.longPress,
  ];
  final unlabelled = [
    for (final node in stops)
      if (actions.any(node.getSemanticsData().hasAction) &&
          node.label.trim().isEmpty &&
          node.tooltip.trim().isEmpty &&
          !node.getSemanticsData().flagsCollection.isTextField)
        node.toStringDeep(),
  ];
  expect(unlabelled, isEmpty);
}
