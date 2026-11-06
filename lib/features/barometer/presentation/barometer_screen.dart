import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/core/widgets/widgets.dart';
import 'package:migraine_tracker/features/barometer/domain/barometer_entities.dart';
import 'package:migraine_tracker/features/barometer/presentation/barometer_controller.dart';
import 'package:migraine_tracker/features/barometer/presentation/barometer_gauge.dart';
import 'package:migraine_tracker/features/weather/presentation/weather_text.dart';

/// Gauge screen: live sensor value (calibrated against the station series),
/// the 24 h on-device trend, and the "from nearest station" fallback when
/// the device has no barometer.
class BarometerScreen extends ConsumerWidget {
  const BarometerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(barometerStateProvider).value;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.barometerTitle)),
      body: state == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(AppThemeTokens.space4),
              children: [
                AppCard(
                  child: Column(
                    children: [
                      BarometerGauge(
                        key: const ValueKey('baro-gauge'),
                        hpa: state.displayHpa,
                      ),
                      Text(
                        state.displayHpa == null
                            ? l10n.barometerNoReading
                            : l10n.envPressureNow(
                                state.displayHpa!.toStringAsFixed(1),
                              ),
                        key: const ValueKey('baro-value'),
                        style: context.textStyles.headlineMedium,
                      ),
                      const SizedBox(height: AppThemeTokens.space1),
                      Text(
                        switch (state.origin) {
                          PressureOrigin.sensor => l10n.barometerFromSensor,
                          PressureOrigin.station => l10n.barometerFromStation,
                          PressureOrigin.none => l10n.barometerNoSource,
                        },
                        key: const ValueKey('baro-source'),
                        style: context.textStyles.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppThemeTokens.space4),
                SectionHeader(title: l10n.barometerCalibrationSection),
                AppCard(
                  child: Text(
                    state.calibration.isCalibrated
                        ? l10n.barometerOffset(
                            formatDelta(l10n, state.calibration.offset!),
                            state.calibration.pairs,
                          )
                        : l10n.barometerNotCalibrated(
                            AppThresholds.barometerCalibrationMinPairs,
                          ),
                    key: const ValueKey('baro-offset'),
                  ),
                ),
                const SizedBox(height: AppThemeTokens.space4),
                SectionHeader(title: l10n.barometerTrendSection),
                AppCard(
                  key: const ValueKey('baro-trend'),
                  child: state.trend.length < 2
                      ? Text(l10n.barometerTrendEmpty)
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PressureSparkline(
                              values: [
                                for (final r in state.trend)
                                  state.calibration.apply(r.hpa),
                              ],
                            ),
                            const SizedBox(height: AppThemeTokens.space2),
                            Text(
                              l10n.barometerTrendSamples(state.trend.length),
                              style: context.textStyles.bodySmall,
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: AppThemeTokens.space4),
                Text(
                  l10n.barometerStampNote,
                  style: context.textStyles.bodySmall,
                ),
              ],
            ),
    );
  }
}
