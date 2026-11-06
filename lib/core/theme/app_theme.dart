import 'package:flutter/material.dart';
import 'package:migraine_tracker/config/app_config.dart';

/// Builds the Material 3 themes from [AppThemeTokens].
///
/// The scaffold phase ships the minimum: light and dark schemes from the seed
/// colour. The design-system phase extends this with the attack theme, the
/// type scale and the component themes.
abstract final class AppTheme {
  static ThemeData light() => _build(Brightness.light);

  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppThemeTokens.seed,
      brightness: brightness,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
    );
  }
}
