import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/theme/app_theme.dart';
import 'package:migraine_tracker/core/widgets/widgets.dart';
import 'package:migraine_tracker/features/dev_tools/presentation/theme_gallery_screen.dart';

/// Golden tests for the design system. One file per theme and text scale
/// under `goldens/ci/`. Regenerate with `flutter test --update-goldens`
/// only in the PR that changes a widget, and attach before and after.
void main() {
  Widget localized(Widget child) => Localizations(
    locale: AppLocales.fallback,
    delegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    child: child,
  );

  final themes = <String, ThemeData>{
    'light': AppTheme.light(),
    'dark': AppTheme.dark(),
    'attack': AppTheme.attack(),
  };

  for (final MapEntry(key: name, value: theme) in themes.entries) {
    for (final scale in [1.0, 2.0]) {
      unawaited(
        goldenTest(
          'gallery $name at ${(scale * 100).round()}%',
          fileName: 'gallery_${name}_${(scale * 100).round()}',
          constraints: const BoxConstraints(maxWidth: 420),
          builder: () => GoldenTestGroup(
            scenarioConstraints: const BoxConstraints(maxWidth: 420),
            children: [
              GoldenTestScenario(
                name: name,
                child: Theme(
                  data: theme,
                  child: MediaQuery(
                    data: MediaQueryData(textScaler: TextScaler.linear(scale)),
                    child: localized(
                      ColoredBox(
                        color: theme.scaffoldBackgroundColor,
                        child: Padding(
                          padding: const EdgeInsets.all(AppThemeTokens.space4),
                          child: ThemeGalleryContent(title: name),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  unawaited(
    goldenTest(
      'core widgets side by side',
      fileName: 'core_widgets',
      builder: () => GoldenTestGroup(
        columns: 3,
        children: [
          for (final MapEntry(key: name, value: theme) in themes.entries)
            GoldenTestScenario(
              name: name,
              child: Theme(
                data: theme,
                child: localized(
                  ColoredBox(
                    color: theme.scaffoldBackgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.all(AppThemeTokens.space3),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppButton(label: 'Start attack', onPressed: () {}),
                          const SizedBox(height: AppThemeTokens.space2),
                          AppChoiceChip(
                            label: 'Aura',
                            selected: true,
                            onSelected: (_) {},
                          ),
                          const SizedBox(height: AppThemeTokens.space2),
                          const RiskLevelBadge(level: RiskLevel.high),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}
