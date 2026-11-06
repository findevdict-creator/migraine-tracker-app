import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/theme/app_theme.dart';
import 'package:migraine_tracker/core/widgets/widgets.dart';

import '../../support/pump_app.dart';

void main() {
  group('AppButton', () {
    testWidgets('meets the 48 dp target in the standard theme', (tester) async {
      await tester.pumpLocalized(
        Center(
          child: AppButton(label: 'Go', onPressed: () {}),
        ),
        theme: AppTheme.light(),
      );
      final size = tester.getSize(find.byType(FilledButton));
      expect(size.height, greaterThanOrEqualTo(AppThemeTokens.minTapTarget));
      expect(size.width, greaterThanOrEqualTo(AppThemeTokens.minTapTarget));
    });

    testWidgets('grows to 56 pt inside the attack theme', (tester) async {
      await tester.pumpLocalized(
        Center(
          child: AppButton(label: 'End', onPressed: () {}),
        ),
        theme: AppTheme.attack(),
      );
      final size = tester.getSize(find.byType(FilledButton));
      expect(size.height, greaterThanOrEqualTo(AppThemeTokens.attackTapTarget));
    });

    testWidgets('large forces 56 pt anywhere and fires onPressed', (
      tester,
    ) async {
      var pressed = 0;
      await tester.pumpLocalized(
        Center(
          child: AppButton(
            label: 'Start',
            large: true,
            icon: Icons.bolt,
            onPressed: () => pressed++,
          ),
        ),
        theme: AppTheme.light(),
      );
      final size = tester.getSize(find.byType(FilledButton));
      expect(size.height, greaterThanOrEqualTo(AppThemeTokens.attackTapTarget));
      await tester.tap(find.byType(FilledButton));
      expect(pressed, 1);
    });
  });

  group('AppChoiceChip', () {
    testWidgets('reports selection and meets the tap target', (tester) async {
      bool? selected;
      await tester.pumpLocalized(
        Center(
          child: AppChoiceChip(
            label: 'Aura',
            selected: false,
            onSelected: (v) => selected = v,
          ),
        ),
        theme: AppTheme.attack(),
      );
      final size = tester.getSize(find.byType(FilterChip));
      expect(size.height, greaterThanOrEqualTo(AppThemeTokens.attackTapTarget));
      await tester.tap(find.byType(FilterChip));
      expect(selected, isTrue);
    });
  });

  group('AppIntensitySlider', () {
    testWidgets('snaps to integers and shows the value', (tester) async {
      int? value;
      await tester.pumpLocalized(
        AppIntensitySlider(
          value: 3,
          onChanged: (v) => value = v,
          semanticLabel: 'Intensity',
        ),
        theme: AppTheme.light(),
      );
      expect(find.text('3'), findsOneWidget);
      final slider = find.byType(Slider);
      await tester.drag(slider, const Offset(200, 0));
      expect(value, isNotNull);
      expect(value, inInclusiveRange(0, 10));
    });

    testWidgets('shows a dash when unanswered', (tester) async {
      await tester.pumpLocalized(
        AppIntensitySlider(
          value: null,
          onChanged: (_) {},
          semanticLabel: 'Intensity',
        ),
        theme: AppTheme.light(),
      );
      expect(find.text('–'), findsOneWidget);
    });
  });

  group('RiskLevelBadge', () {
    testWidgets('labels every level with text, not colour alone', (
      tester,
    ) async {
      await tester.pumpLocalized(
        const Column(
          children: [
            RiskLevelBadge(level: RiskLevel.low),
            RiskLevelBadge(level: RiskLevel.moderate),
            RiskLevelBadge(level: RiskLevel.high),
          ],
        ),
        theme: AppTheme.light(),
      );
      expect(find.text('Low'), findsOneWidget);
      expect(find.text('Moderate'), findsOneWidget);
      expect(find.text('High'), findsOneWidget);
    });
  });

  group('AppCard', () {
    testWidgets('is tappable when onTap is given', (tester) async {
      var taps = 0;
      await tester.pumpLocalized(
        AppCard(onTap: () => taps++, child: const Text('x')),
        theme: AppTheme.light(),
      );
      await tester.tap(find.byType(AppCard));
      expect(taps, 1);
    });
  });
}
