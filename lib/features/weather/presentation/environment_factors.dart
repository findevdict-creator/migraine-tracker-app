import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:migraine_tracker/app/router.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/core/widgets/widgets.dart';
import 'package:migraine_tracker/features/premium/application/premium_controller.dart';
import 'package:migraine_tracker/features/weather/application/weather_sync.dart';
import 'package:migraine_tracker/features/weather/data/weather_repository_impl.dart';
import 'package:migraine_tracker/features/weather/domain/factor_bands.dart';
import 'package:migraine_tracker/features/weather/domain/weather_entities.dart';

/// Today's environment day for the current cell, or null when the region
/// has no data yet.
final todayFactorsProvider = StreamProvider<EnvironmentDayEntity?>((
  ref,
) async* {
  final location = await ref.watch(weatherLocationProvider.future);
  final cell = location.cell;
  if (cell == null) {
    yield null;
    return;
  }
  // Days are keyed by UTC date, as the cache serves them.
  final today = ref.watch(clockProvider)().utcHour.dateKey;
  yield* ref
      .watch(weatherRepositoryProvider)
      .watchDays(today, today)
      .map((days) => days.where((d) => d.cell == cell.key).firstOrNull);
});

/// Daily factors: air quality, pollen (Europe only), UV, daylight, sunrise
/// and sunset. Every row is hidden where the region has no data.
class EnvironmentFactorsCard extends ConsumerWidget {
  const EnvironmentFactorsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final day = ref.watch(todayFactorsProvider).value;
    final all = day == null ? const <Widget>[] : _rows(context, day);
    final extended = ref
        .watch(premiumProvider)
        .allows(PremiumFeature.extendedFactors);
    final lockedKeys = {
      if (!extended)
        for (final k in AppPremium.extendedFactorKeys) ValueKey('factor-$k'),
    };
    final rows = [
      for (final r in all)
        if (!lockedKeys.contains(r.key)) r,
    ];
    final anyLocked = rows.length < all.length;
    return AppCard(
      key: const ValueKey('env-factors'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.envFactorsTitle,
                  style: context.textStyles.titleMedium,
                ),
              ),
              TextButton(
                key: const ValueKey('env-about-data'),
                onPressed: () => context.push(AppRoutes.aboutData),
                child: Text(l10n.aboutDataTitle),
              ),
            ],
          ),
          if (rows.isEmpty)
            Text(
              l10n.envFactorsEmpty,
              key: const ValueKey('env-factors-empty'),
              style: context.textStyles.bodyMedium,
            )
          else
            ...rows,
          if (anyLocked) _LockedFactors(),
        ],
      ),
    );
  }

  List<Widget> _rows(BuildContext context, EnvironmentDayEntity day) {
    final l10n = context.l10n;
    final local = MaterialLocalizations.of(context);
    String band(FactorBand b) => switch (b) {
      FactorBand.low => l10n.factorBandLow,
      FactorBand.moderate => l10n.factorBandModerate,
      FactorBand.high => l10n.factorBandHigh,
      FactorBand.veryHigh => l10n.factorBandVeryHigh,
    };
    String time(DateTime t) =>
        local.formatTimeOfDay(TimeOfDay.fromDateTime(t.toLocal()));
    return [
      ?_row(
        'aqi-us',
        l10n.factorAqiUs,
        day.aqiUs == null
            ? null
            : l10n.factorValueWithBand(
                day.aqiUs!.toStringAsFixed(0),
                band(FactorBand.aqiUs(day.aqiUs!)),
              ),
      ),
      ?_row(
        'aqi-eu',
        l10n.factorAqiEu,
        day.aqiEu == null
            ? null
            : l10n.factorValueWithBand(
                day.aqiEu!.toStringAsFixed(0),
                band(FactorBand.aqiEu(day.aqiEu!)),
              ),
      ),
      ?_row(
        'pm',
        l10n.factorParticulates,
        day.pm25 == null && day.pm10 == null
            ? null
            : l10n.factorParticulatesValue(
                day.pm25?.toStringAsFixed(1) ?? l10n.envDeltaUnknown,
                day.pm10?.toStringAsFixed(1) ?? l10n.envDeltaUnknown,
              ),
      ),
      ?_row(
        'ozone',
        l10n.factorOzone,
        day.ozone == null
            ? null
            : l10n.factorMicrograms(day.ozone!.toStringAsFixed(0)),
      ),
      ?_row(
        'pollen',
        l10n.factorPollen,
        day.pollen == null || day.pollen!.isEmpty
            ? null
            : [
                for (final e in day.pollen!.entries)
                  l10n.factorPollenType(
                    _pollenName(l10n, e.key),
                    band(FactorBand.pollen(e.value)),
                  ),
              ].join(', '),
      ),
      ?_row(
        'uv',
        l10n.factorUvMax,
        day.uvMax == null
            ? null
            : l10n.factorValueWithBand(
                day.uvMax!.toStringAsFixed(1),
                band(FactorBand.uv(day.uvMax!)),
              ),
      ),
      ?_row(
        'daylight',
        l10n.factorDaylight,
        day.daylightMinutes == null
            ? null
            : l10n.factorDaylightValue(
                day.daylightMinutes! ~/ 60,
                day.daylightMinutes! % 60,
              ),
      ),
      ?_row(
        'sun',
        l10n.factorSun,
        day.sunrise == null || day.sunset == null
            ? null
            : l10n.factorSunValue(time(day.sunrise!), time(day.sunset!)),
      ),
    ];
  }

  Widget? _row(String key, String label, String? value) {
    if (value == null) return null;
    return Padding(
      key: ValueKey('factor-$key'),
      padding: const EdgeInsets.only(top: AppThemeTokens.space2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: Text(label)),
          Expanded(flex: 3, child: Text(value, textAlign: TextAlign.end)),
        ],
      ),
    );
  }

  static String _pollenName(AppLocalizations l10n, String key) => switch (key) {
    'alder' => l10n.pollenAlder,
    'birch' => l10n.pollenBirch,
    'grass' => l10n.pollenGrass,
    'mugwort' => l10n.pollenMugwort,
    'olive' => l10n.pollenOlive,
    'ragweed' => l10n.pollenRagweed,
    _ => key,
  };
}

/// Stands in for the extended rows when there is data for them but no
/// Premium.
class _LockedFactors extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      key: const ValueKey('factor-premium'),
      padding: const EdgeInsets.only(top: AppThemeTokens.space2),
      child: Row(
        children: [
          const Icon(Icons.lock_outline, size: 18),
          const SizedBox(width: AppThemeTokens.space2),
          Expanded(child: Text(l10n.premiumFactorsLocked)),
          TextButton(
            key: const ValueKey('factor-premium-open'),
            onPressed: () => context.push(AppRoutes.premium),
            child: Text(l10n.premiumLockButton),
          ),
        ],
      ),
    );
  }
}
