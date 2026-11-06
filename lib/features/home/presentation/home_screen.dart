import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:migraine_tracker/app/bootstrap.dart';
import 'package:migraine_tracker/app/router.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/features/attack_log/presentation/start_attack_button.dart';
import 'package:migraine_tracker/features/barometer/application/barometer_sampler.dart';
import 'package:migraine_tracker/features/checkin/presentation/checkin_card.dart';
import 'package:migraine_tracker/features/risk/application/risk_engine.dart';
import 'package:migraine_tracker/features/risk/presentation/risk_card.dart';
import 'package:migraine_tracker/features/weather/application/weather_sync.dart';
import 'package:migraine_tracker/features/weather/presentation/environment_card.dart';

/// Home screen. Carries the one-tap start-attack button; the risk card and
/// load meter arrive in their own phases.
class HomeScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);
    final l10n = context.l10n;
    // Foreground refresh on open; returns early while the cache is fresh.
    ref
      ..watch(weatherRefreshProvider)
      // Scores today and the days ahead once weather is in.
      ..watch(riskRefreshProvider)
      // Keeps the barometer sampler running while the app is open.
      ..watch(liveReadingProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(config.displayName),
        actions: [
          if (AppFeatureFlags.cycleTrackingAvailable)
            IconButton(
              key: const ValueKey('home-cycle'),
              icon: const Icon(Icons.loop),
              tooltip: l10n.cycleTitle,
              onPressed: () => context.push(AppRoutes.cycle),
            ),
          IconButton(
            key: const ValueKey('home-medications'),
            icon: const Icon(Icons.medication_outlined),
            tooltip: l10n.medicationTitle,
            onPressed: () => context.push(AppRoutes.medications),
          ),
          IconButton(
            key: const ValueKey('home-settings'),
            icon: const Icon(Icons.settings_outlined),
            tooltip: l10n.settingsTitle,
            onPressed: () => context.push(AppRoutes.settings),
          ),
          if (config.showDevTools)
            IconButton(
              icon: const Icon(Icons.palette_outlined),
              tooltip: l10n.devThemeGalleryTitle,
              onPressed: () => context.push(AppRoutes.devThemeGallery),
            ),
        ],
      ),
      body: ListView(
        key: const ValueKey('home-list'),
        padding: const EdgeInsets.all(AppThemeTokens.space4),
        children: [
          const StartAttackButton(),
          const SizedBox(height: AppThemeTokens.space4),
          const RiskCard(),
          const SizedBox(height: AppThemeTokens.space4),
          const CheckinCard(),
          const SizedBox(height: AppThemeTokens.space4),
          const EnvironmentCard(),
          const SizedBox(height: AppThemeTokens.space5),
          Text(
            l10n.homeEmptyState,
            key: const ValueKey('home-empty'),
            textAlign: TextAlign.center,
            style: context.textStyles.bodySmall,
          ),
        ],
      ),
    );
  }
}
