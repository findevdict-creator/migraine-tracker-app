import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/core/theme/app_theme.dart';

/// WCAG 2.2 relative luminance and contrast ratio.
double _luminance(Color c) {
  double channel(double v) =>
      v <= 0.03928 ? v / 12.92 : pow((v + 0.055) / 1.055, 2.4).toDouble();
  return 0.2126 * channel(c.r) + 0.7152 * channel(c.g) + 0.0722 * channel(c.b);
}

double contrast(Color a, Color b) {
  final la = _luminance(a);
  final lb = _luminance(b);
  return (max(la, lb) + 0.05) / (min(la, lb) + 0.05);
}

void main() {
  const aa = 4.5;

  group('Colour tokens meet WCAG 2.2 AA', () {
    test('risk fills against their on-colour', () {
      const light = AppColors.light();
      const dark = AppColors.dark();
      for (final c in [light.riskLow, light.riskModerate, light.riskHigh]) {
        expect(
          contrast(c, light.onRisk),
          greaterThanOrEqualTo(aa),
          reason: '$c on ${light.onRisk}',
        );
      }
      for (final c in [dark.riskLow, dark.riskModerate, dark.riskHigh]) {
        expect(
          contrast(c, dark.onRisk),
          greaterThanOrEqualTo(aa),
          reason: '$c on ${dark.onRisk}',
        );
      }
    });

    test('risk and semantic colours as text on the theme surfaces', () {
      final light = AppTheme.light();
      final dark = AppTheme.dark();
      final attack = AppTheme.attack();
      const lightColors = AppColors.light();
      const darkColors = AppColors.dark();
      for (final c in [
        lightColors.riskLow,
        lightColors.riskModerate,
        lightColors.riskHigh,
        lightColors.info,
      ]) {
        expect(
          contrast(c, light.colorScheme.surface),
          greaterThanOrEqualTo(aa),
          reason: '$c on light surface',
        );
      }
      for (final c in [
        darkColors.riskLow,
        darkColors.riskModerate,
        darkColors.riskHigh,
        darkColors.info,
      ]) {
        expect(
          contrast(c, dark.colorScheme.surface),
          greaterThanOrEqualTo(aa),
          reason: '$c on dark surface',
        );
        expect(
          contrast(c, attack.scaffoldBackgroundColor),
          greaterThanOrEqualTo(aa),
          reason: '$c on attack background',
        );
      }
    });

    test('attack theme text and accent against its surfaces', () {
      final attack = AppTheme.attack();
      final scheme = attack.colorScheme;
      expect(
        contrast(scheme.onSurface, attack.scaffoldBackgroundColor),
        greaterThanOrEqualTo(7),
      );
      expect(
        contrast(scheme.onSurface, scheme.surface),
        greaterThanOrEqualTo(7),
      );
      expect(
        contrast(scheme.onSurfaceVariant, scheme.surface),
        greaterThanOrEqualTo(aa),
      );
      expect(
        contrast(scheme.primary, attack.scaffoldBackgroundColor),
        greaterThanOrEqualTo(aa),
      );
      expect(
        contrast(scheme.onPrimary, scheme.primary),
        greaterThanOrEqualTo(aa),
      );
    });

    test('material schemes keep on-colours readable', () {
      for (final theme in [AppTheme.light(), AppTheme.dark()]) {
        final s = theme.colorScheme;
        expect(contrast(s.onSurface, s.surface), greaterThanOrEqualTo(aa));
        expect(contrast(s.onPrimary, s.primary), greaterThanOrEqualTo(aa));
      }
    });
  });

  group('AppTheme', () {
    test('attack theme uses 56 pt targets and true black', () {
      final attack = AppTheme.attack();
      expect(attack.scaffoldBackgroundColor, AppThemeTokens.attackBackground);
      expect(attack.extension<AttackThemeMarker>(), isNotNull);
      final size = attack.filledButtonTheme.style!.minimumSize!.resolve({})!;
      expect(size.height, AppThemeTokens.attackTapTarget);
    });

    test('standard themes use 48 dp targets', () {
      for (final theme in [AppTheme.light(), AppTheme.dark()]) {
        final size = theme.filledButtonTheme.style!.minimumSize!.resolve({})!;
        expect(size.height, AppThemeTokens.minTapTarget);
        expect(theme.extension<AttackThemeMarker>(), isNull);
        expect(theme.extension<AppColors>(), isNotNull);
      }
    });
  });
}
