import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/theme/app_theme.dart';
import 'package:migraine_tracker/features/risk/presentation/load_meter.dart';
import 'package:risk_model/risk_model.dart';

/// Goldens for the load meter: light, dark and attack themes at 100 % and
/// 200 % text scale, population and learned thresholds, compact and full.
/// Regenerate with `flutter test --update-goldens` only in the PR that
/// changes the widget, and attach before and after.
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

  final stacked = const DailyLoad().compute(
    const DayInputs(
      date: '2026-11-06',
      stress: 5,
      sleepQuality: 1,
      alcohol: 3,
      pressureDelta24h: -4,
      caffeine: 4,
    ),
  );
  final single = const DailyLoad().compute(
    const DayInputs(date: '2026-11-06', pressureDelta24h: -6),
  );
  const learned = LevelThresholds(moderate: 22, high: 48);

  Widget scenario(ThemeData theme, double scale, Widget child) => Theme(
    data: theme,
    child: MediaQuery(
      data: MediaQueryData(textScaler: TextScaler.linear(scale)),
      child: localized(
        ColoredBox(
          color: theme.scaffoldBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(AppThemeTokens.space4),
            child: child,
          ),
        ),
      ),
    ),
  );

  for (final MapEntry(key: name, value: theme) in themes.entries) {
    for (final scale in [1.0, 2.0]) {
      unawaited(
        goldenTest(
          'load meter $name at ${(scale * 100).round()}%',
          fileName: 'load_meter_${name}_${(scale * 100).round()}',
          constraints: const BoxConstraints(maxWidth: 420),
          builder: () => GoldenTestGroup(
            scenarioConstraints: const BoxConstraints(maxWidth: 420),
            children: [
              GoldenTestScenario(
                name: 'stacked, population thresholds',
                child: scenario(
                  theme,
                  scale,
                  LoadMeter(
                    load: stacked.load,
                    contributions: stacked.contributions,
                    thresholds: const LevelThresholds.population(),
                  ),
                ),
              ),
              GoldenTestScenario(
                name: 'single factor, learned thresholds',
                child: scenario(
                  theme,
                  scale,
                  LoadMeter(
                    load: single.load,
                    contributions: single.contributions,
                    thresholds: learned,
                  ),
                ),
              ),
              GoldenTestScenario(
                name: 'compact on the card',
                child: scenario(
                  theme,
                  scale,
                  LoadMeter(
                    load: stacked.load,
                    contributions: stacked.contributions,
                    thresholds: learned,
                    compact: true,
                    showLegend: false,
                  ),
                ),
              ),
              GoldenTestScenario(
                name: 'empty',
                child: scenario(
                  theme,
                  scale,
                  const LoadMeter(
                    load: 0,
                    contributions: [],
                    thresholds: LevelThresholds.population(),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
