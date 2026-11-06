import 'package:flutter/material.dart';
import 'package:migraine_tracker/config/app_config.dart';

/// Type scale. Sizes are logical pixels at 100% and scale with the
/// platform text scale up to [AppThemeTokens.maxTextScale]; layouts must not
/// truncate at 200%.
abstract final class AppTypography {
  static TextTheme textTheme(ColorScheme scheme) {
    final base = Typography.material2021(colorScheme: scheme).black;
    final onSurface = scheme.onSurface;
    return base
        .copyWith(
          displayLarge: base.displayLarge?.copyWith(
            fontSize: AppThemeTokens.fontDisplay,
            fontWeight: FontWeight.w700,
            height: 1.1,
          ),
          headlineMedium: base.headlineMedium?.copyWith(
            fontSize: AppThemeTokens.fontHeadline,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
          titleLarge: base.titleLarge?.copyWith(
            fontSize: AppThemeTokens.fontTitle,
            fontWeight: FontWeight.w600,
            height: 1.25,
          ),
          titleMedium: base.titleMedium?.copyWith(
            fontSize: AppThemeTokens.fontBody,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: base.bodyLarge?.copyWith(
            fontSize: AppThemeTokens.fontBody,
            height: 1.5,
          ),
          bodyMedium: base.bodyMedium?.copyWith(
            fontSize: AppThemeTokens.fontBodySmall,
            height: 1.5,
          ),
          labelLarge: base.labelLarge?.copyWith(
            fontSize: AppThemeTokens.fontLabel,
            fontWeight: FontWeight.w600,
          ),
        )
        .apply(bodyColor: onSurface, displayColor: onSurface);
  }

  /// Clamps the platform text scale to the ceiling the layouts are tested
  /// at, so an extreme accessibility setting degrades gracefully instead of
  /// overflowing.
  static TextScaler clampedScaler(BuildContext context) =>
      MediaQuery.textScalerOf(
        context,
      ).clamp(minScaleFactor: 1, maxScaleFactor: AppThemeTokens.maxTextScale);
}
