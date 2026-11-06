import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:migraine_tracker/app/router.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/core/widgets/widgets.dart';
import 'package:migraine_tracker/features/weather/application/weather_sync.dart';
import 'package:migraine_tracker/features/weather/domain/location_cell.dart';
import 'package:migraine_tracker/features/weather/presentation/city_search_sheet.dart';
import 'package:migraine_tracker/features/weather/presentation/environment_controller.dart';
import 'package:migraine_tracker/features/weather/presentation/pressure_chart.dart';
import 'package:migraine_tracker/features/weather/presentation/weather_text.dart';

/// Environment screen: the 72 h pressure view, deltas, forecast age and
/// the location choice. Shows cached data with its age when offline.
class EnvironmentScreen extends ConsumerWidget {
  const EnvironmentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final refresh = ref.watch(weatherRefreshProvider);
    final view = ref.watch(environmentViewProvider).value;
    final location = ref.watch(weatherLocationProvider).value;
    final refreshError = refresh.value?.error;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.environmentTitle),
        actions: [
          if (refresh.isLoading)
            const Padding(
              padding: EdgeInsets.all(AppThemeTokens.space3),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              key: const ValueKey('env-refresh'),
              icon: const Icon(Icons.refresh),
              tooltip: l10n.envRefresh,
              onPressed: () => ref.invalidate(weatherRefreshProvider),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppThemeTokens.space4),
        children: [
          if (view == null)
            const Center(child: CircularProgressIndicator())
          else if (!view.hasData)
            AppCard(
              key: const ValueKey('env-empty'),
              child: Text(
                refreshError != null ? l10n.envOffline : l10n.envNoData,
              ),
            )
          else
            _PressureCard(view: view, offline: refreshError != null),
          const SizedBox(height: AppThemeTokens.space2),
          TextButton.icon(
            key: const ValueKey('env-barometer'),
            icon: const Icon(Icons.speed),
            label: Text(l10n.barometerOpen),
            onPressed: () => context.push(AppRoutes.barometer),
          ),
          const SizedBox(height: AppThemeTokens.space2),
          SectionHeader(title: l10n.envLocationSection),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  locationLabel(l10n, location),
                  key: const ValueKey('env-location'),
                  style: context.textStyles.bodyLarge,
                ),
                const SizedBox(height: AppThemeTokens.space2),
                Text(l10n.envPrivacyNote, style: context.textStyles.bodySmall),
                const SizedBox(height: AppThemeTokens.space3),
                Wrap(
                  spacing: AppThemeTokens.space2,
                  children: [
                    OutlinedButton.icon(
                      key: const ValueKey('env-use-gps'),
                      icon: const Icon(Icons.my_location),
                      label: Text(l10n.envUseMyLocation),
                      onPressed: () async {
                        await ref.read(weatherSyncProvider).useDeviceLocation();
                        ref
                          ..invalidate(weatherLocationProvider)
                          ..invalidate(environmentViewProvider)
                          ..invalidate(weatherRefreshProvider);
                      },
                    ),
                    OutlinedButton.icon(
                      key: const ValueKey('env-choose-city'),
                      icon: const Icon(Icons.location_city),
                      label: Text(l10n.envChooseCity),
                      onPressed: () => showCitySearchSheet(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppThemeTokens.space4),
          Text(
            l10n.envAttribution,
            key: const ValueKey('env-attribution'),
            style: context.textStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _PressureCard extends StatelessWidget {
  const _PressureCard({required this.view, required this.offline});

  final EnvironmentView view;
  final bool offline;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final deltas = view.deltas;
    final current = deltas.current;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.envPressureSection, style: context.textStyles.titleMedium),
          const SizedBox(height: AppThemeTokens.space2),
          Text(
            current == null
                ? l10n.envPressureUnknown
                : l10n.envPressureNow(current.toStringAsFixed(1)),
            key: const ValueKey('env-pressure-now'),
            style: context.textStyles.headlineMedium,
          ),
          const SizedBox(height: AppThemeTokens.space2),
          Wrap(
            spacing: AppThemeTokens.space3,
            runSpacing: AppThemeTokens.space1,
            children: [
              _Delta(label: l10n.envDelta3h, value: deltas.h3, keyName: '3h'),
              _Delta(label: l10n.envDelta6h, value: deltas.h6, keyName: '6h'),
              _Delta(
                label: l10n.envDelta12h,
                value: deltas.h12,
                keyName: '12h',
              ),
              _Delta(
                label: l10n.envDelta24h,
                value: deltas.h24,
                keyName: '24h',
              ),
            ],
          ),
          const SizedBox(height: AppThemeTokens.space3),
          Text(l10n.envChartTitle, style: context.textStyles.labelMedium),
          PressureChart(
            key: const ValueKey('env-chart'),
            hours: view.hours,
            now: view.now,
          ),
          const SizedBox(height: AppThemeTokens.space2),
          Text(
            forecastAge(l10n, view.age),
            key: const ValueKey('env-age'),
            style: context.textStyles.bodySmall,
          ),
          if (offline || view.isStale)
            Padding(
              padding: const EdgeInsets.only(top: AppThemeTokens.space1),
              child: Text(
                offline ? l10n.envOffline : l10n.envStale,
                key: ValueKey(offline ? 'env-offline' : 'env-stale'),
                style: context.textStyles.bodySmall,
              ),
            ),
        ],
      ),
    );
  }
}

class _Delta extends StatelessWidget {
  const _Delta({
    required this.label,
    required this.value,
    required this.keyName,
  });

  final String label;
  final double? value;
  final String keyName;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      key: ValueKey('env-delta-$keyName'),
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: context.textStyles.labelSmall),
        Text(
          value == null ? l10n.envDeltaUnknown : formatDelta(l10n, value!),
          style: context.textStyles.bodyMedium,
        ),
      ],
    );
  }
}

/// Human label for the location in use.
String locationLabel(AppLocalizations l10n, WeatherLocation? location) {
  if (location == null || location.cell == null) return l10n.envLocationNone;
  return switch (location.mode) {
    LocationMode.manual => l10n.envLocationManual(location.name ?? ''),
    LocationMode.gps => l10n.envLocationGps,
    LocationMode.none => l10n.envLocationLast,
  };
}
