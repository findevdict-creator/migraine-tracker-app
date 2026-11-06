import 'package:flutter/material.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/core/theme/app_motion.dart';
import 'package:migraine_tracker/core/theme/app_typography.dart';

/// Builds the three Material 3 themes from [AppThemeTokens]:
/// light, dark and the high-contrast dark attack theme.
///
/// Widgets never reference a raw colour or size; they read the theme and
/// [AppColors]. Changing a token in the central config changes every screen.
abstract final class AppTheme {
  static ThemeData light() => _build(
    ColorScheme.fromSeed(seedColor: AppThemeTokens.seed),
    const AppColors.light(),
  );

  static ThemeData dark() => _build(
    ColorScheme.fromSeed(
      seedColor: AppThemeTokens.seed,
      brightness: Brightness.dark,
    ),
    const AppColors.dark(),
  );

  /// Photophobia-friendly theme for the attack screen: true black
  /// background, muted text, one warm accent, 56 pt targets, no elevation
  /// tints.
  static ThemeData attack() {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppThemeTokens.attackAccent,
      onPrimary: AppThemeTokens.attackBackground,
      secondary: AppThemeTokens.attackOnBackground,
      onSecondary: AppThemeTokens.attackBackground,
      error: AppThemeTokens.riskHighDark,
      onError: AppThemeTokens.attackBackground,
      surface: AppThemeTokens.attackSurface,
      onSurface: AppThemeTokens.attackOnBackground,
      surfaceContainerHighest: AppThemeTokens.attackSurfaceRaised,
      onSurfaceVariant: AppThemeTokens.attackMuted,
      outline: AppThemeTokens.attackMuted,
      outlineVariant: AppThemeTokens.attackSurfaceRaised,
    );
    final base = _build(
      scheme,
      const AppColors.dark(),
      tapTarget: AppThemeTokens.attackTapTarget,
    );
    return base.copyWith(
      scaffoldBackgroundColor: AppThemeTokens.attackBackground,
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: AppThemeTokens.attackBackground,
        surfaceTintColor: Colors.transparent,
      ),
      extensions: [...base.extensions.values, const AttackThemeMarker()],
    );
  }

  static ThemeData _build(
    ColorScheme scheme,
    AppColors appColors, {
    double tapTarget = AppThemeTokens.minTapTarget,
  }) {
    final textTheme = AppTypography.textTheme(scheme);
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppThemeTokens.radiusMedium),
    );
    final buttonMinSize = Size(tapTarget, tapTarget);
    const buttonPadding = EdgeInsets.symmetric(
      horizontal: AppThemeTokens.space5,
      vertical: AppThemeTokens.space3,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: scheme.surface,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      extensions: [appColors],
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        shape: shape,
        margin: EdgeInsets.zero,
        elevation: 0,
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: buttonMinSize,
          padding: buttonPadding,
          shape: shape,
          textStyle: textTheme.titleMedium,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: buttonMinSize,
          padding: buttonPadding,
          shape: shape,
          textStyle: textTheme.titleMedium,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: buttonMinSize,
          padding: buttonPadding,
          shape: shape,
          textStyle: textTheme.titleMedium,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(minimumSize: buttonMinSize),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeTokens.radiusLarge),
        ),
        labelStyle: textTheme.labelLarge,
        padding: const EdgeInsets.symmetric(
          horizontal: AppThemeTokens.space3,
          vertical: AppThemeTokens.space2,
        ),
      ),
      sliderTheme: SliderThemeData(
        trackHeight: AppThemeTokens.space2,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: tapTarget / 4),
        overlayShape: RoundSliderOverlayShape(overlayRadius: tapTarget / 2),
        showValueIndicator: ShowValueIndicator.onDrag,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppThemeTokens.radiusMedium),
        ),
        contentPadding: buttonPadding,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: shape,
      ),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant),
      // The platform transitions, cut to nothing under reduce motion.
      pageTransitionsTheme: appPageTransitions,
    );
  }
}
