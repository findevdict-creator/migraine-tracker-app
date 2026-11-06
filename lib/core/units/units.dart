import 'dart:ui' show PlatformDispatcher;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/settings/settings_keys.dart';
import 'package:migraine_tracker/core/settings/settings_repository.dart';

enum PressureUnit {
  hpa('hpa', AppUnits.hpaDigits),
  inHg('inhg', AppUnits.inHgDigits),
  mmHg('mmhg', AppUnits.mmHgDigits);

  PressureUnit(this.id, this.digits);

  final String id;
  final int digits;

  static PressureUnit? fromId(String? id) =>
      values.where((u) => u.id == id).firstOrNull;

  /// [hpa] in this unit.
  double convert(double hpa) => switch (this) {
    PressureUnit.hpa => hpa,
    PressureUnit.inHg => hpa / AppUnits.hpaPerInHg,
    PressureUnit.mmHg => hpa / AppUnits.hpaPerMmHg,
  };
}

enum TemperatureUnit {
  celsius('c'),
  fahrenheit('f');

  TemperatureUnit(this.id);

  final String id;

  static TemperatureUnit? fromId(String? id) =>
      values.where((u) => u.id == id).firstOrNull;

  double convert(double celsius) =>
      this == TemperatureUnit.celsius ? celsius : celsius * 9 / 5 + 32;
}

/// How pressure and temperature are shown. Values are always stored in hPa
/// and °C.
class Units {
  const Units({
    this.pressure = PressureUnit.hpa,
    this.temperature = TemperatureUnit.celsius,
  });

  /// The defaults for a phone set to [region] (an ISO country code).
  factory Units.forRegion(String? region) => Units(
    pressure: AppUnits.inHgRegions.contains(region)
        ? PressureUnit.inHg
        : PressureUnit.hpa,
    temperature: AppUnits.fahrenheitRegions.contains(region)
        ? TemperatureUnit.fahrenheit
        : TemperatureUnit.celsius,
  );

  final PressureUnit pressure;
  final TemperatureUnit temperature;

  Units copyWith({PressureUnit? pressure, TemperatureUnit? temperature}) =>
      Units(
        pressure: pressure ?? this.pressure,
        temperature: temperature ?? this.temperature,
      );

  /// The number alone, such as `1013.2` or `29.92`, in the locale's digits.
  String pressureNumber(
    AppLocalizations l10n,
    double hpa, {
    bool signed = false,
    int? digits,
  }) {
    final value = pressure.convert(hpa);
    final text =
        (NumberFormat.decimalPatternDigits(
                locale: l10n.localeName,
                decimalDigits: digits ?? pressure.digits,
              )
              // 1013.2, not 1,013.2.
              ..turnOffGrouping())
            .format(value.abs());
    if (value < 0 && text.contains(RegExp('[1-9]'))) return '-$text';
    if (signed && value > 0 && text.contains(RegExp('[1-9]'))) return '+$text';
    return text;
  }

  /// The number with its unit, such as `1013.2 hPa` or `+0.07 inHg`.
  String pressureText(
    AppLocalizations l10n,
    double hpa, {
    bool signed = false,
    int? digits,
  }) {
    final n = pressureNumber(l10n, hpa, signed: signed, digits: digits);
    return switch (pressure) {
      PressureUnit.hpa => l10n.unitHpa(n),
      PressureUnit.inHg => l10n.unitInHg(n),
      PressureUnit.mmHg => l10n.unitMmHg(n),
    };
  }

  /// A pressure change such as a threshold: whole hPa, or two decimals in
  /// inHg so 6 hPa reads 0.18 inHg rather than 0.2.
  String pressureChange(AppLocalizations l10n, double hpa) => pressureText(
    l10n,
    hpa,
    digits: switch (pressure) {
      PressureUnit.hpa => 0,
      PressureUnit.inHg => 2,
      PressureUnit.mmHg => 1,
    },
  );

  /// Whole degrees with the unit, such as `12 °C`.
  String temperatureText(AppLocalizations l10n, double celsius) {
    final n = NumberFormat.decimalPatternDigits(
      locale: l10n.localeName,
      decimalDigits: 0,
    ).format(temperature.convert(celsius));
    return temperature == TemperatureUnit.celsius
        ? l10n.unitCelsius(n)
        : l10n.unitFahrenheit(n);
  }

  /// Reads the person's choice, or the region's defaults.
  static Future<Units> read(SettingsRepository settings, String? region) async {
    final defaults = Units.forRegion(region);
    return Units(
      pressure:
          PressureUnit.fromId(
            await settings.read<String>(SettingsKeys.unitPressure),
          ) ??
          defaults.pressure,
      temperature:
          TemperatureUnit.fromId(
            await settings.read<String>(SettingsKeys.unitTemperature),
          ) ??
          defaults.temperature,
    );
  }
}

/// The phone's region, for unit defaults. Overridden in tests.
final deviceRegionProvider = Provider<String?>(
  (ref) => PlatformDispatcher.instance.locale.countryCode,
);

final _pressureChoiceProvider = StreamProvider<PressureUnit?>(
  (ref) => ref
      .watch(settingsRepositoryProvider)
      .watch<String>(SettingsKeys.unitPressure)
      .map(PressureUnit.fromId),
);

final _temperatureChoiceProvider = StreamProvider<TemperatureUnit?>(
  (ref) => ref
      .watch(settingsRepositoryProvider)
      .watch<String>(SettingsKeys.unitTemperature)
      .map(TemperatureUnit.fromId),
);

/// The units to show, live: the person's choice or the region's defaults.
final unitsProvider = Provider<Units>((ref) {
  final defaults = Units.forRegion(ref.watch(deviceRegionProvider));
  return Units(
    pressure: ref.watch(_pressureChoiceProvider).value ?? defaults.pressure,
    temperature:
        ref.watch(_temperatureChoiceProvider).value ?? defaults.temperature,
  );
});

/// Saves a unit choice.
final unitActionsProvider = Provider<UnitActions>(UnitActions.new);

class UnitActions {
  UnitActions(this._ref);

  final Ref _ref;

  Future<void> setPressure(PressureUnit unit) => _ref
      .read(settingsRepositoryProvider)
      .write(SettingsKeys.unitPressure, unit.id);

  Future<void> setTemperature(TemperatureUnit unit) => _ref
      .read(settingsRepositoryProvider)
      .write(SettingsKeys.unitTemperature, unit.id);
}
