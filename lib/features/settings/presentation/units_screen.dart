import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/units/units.dart';
import 'package:migraine_tracker/core/widgets/widgets.dart';

/// Pressure and temperature units. Only the display changes.
class UnitsScreen extends ConsumerWidget {
  const UnitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final units = ref.watch(unitsProvider);
    final actions = ref.read(unitActionsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.unitsTitle)),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppThemeTokens.space2),
        children: [
          SectionHeader(title: l10n.unitsPressure),
          RadioGroup<PressureUnit>(
            groupValue: units.pressure,
            onChanged: (u) {
              if (u != null) unawaited(actions.setPressure(u));
            },
            child: Column(
              children: [
                for (final u in PressureUnit.values)
                  RadioListTile<PressureUnit>(
                    key: ValueKey('units-pressure-${u.id}'),
                    value: u,
                    title: Text(switch (u) {
                      PressureUnit.hpa => l10n.unitNameHpa,
                      PressureUnit.inHg => l10n.unitNameInHg,
                      PressureUnit.mmHg => l10n.unitNameMmHg,
                    }),
                    subtitle: Text(
                      units.copyWith(pressure: u).pressureText(l10n, 1013.25),
                    ),
                  ),
              ],
            ),
          ),
          SectionHeader(title: l10n.unitsTemperature),
          RadioGroup<TemperatureUnit>(
            groupValue: units.temperature,
            onChanged: (u) {
              if (u != null) unawaited(actions.setTemperature(u));
            },
            child: Column(
              children: [
                for (final u in TemperatureUnit.values)
                  RadioListTile<TemperatureUnit>(
                    key: ValueKey('units-temperature-${u.id}'),
                    value: u,
                    title: Text(switch (u) {
                      TemperatureUnit.celsius => l10n.unitNameCelsius,
                      TemperatureUnit.fahrenheit => l10n.unitNameFahrenheit,
                    }),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppThemeTokens.space4),
            child: Text(l10n.unitsNote, key: const ValueKey('units-note')),
          ),
        ],
      ),
    );
  }
}
