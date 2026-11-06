import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:migraine_tracker/app/bootstrap.dart';
import 'package:migraine_tracker/app/router.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/core/widgets/widgets.dart';
import 'package:migraine_tracker/features/checkin/presentation/checkin_controller.dart';
import 'package:migraine_tracker/features/health/application/health_sync.dart';
import 'package:migraine_tracker/features/health/domain/health_entities.dart';
import 'package:migraine_tracker/features/health/presentation/health_settings_screen.dart';
import 'package:migraine_tracker/features/onboarding/application/onboarding_state.dart';
import 'package:migraine_tracker/features/onboarding/presentation/level_explainer.dart';
import 'package:migraine_tracker/features/weather/application/weather_sync.dart';
import 'package:migraine_tracker/features/weather/presentation/city_search_sheet.dart';
import 'package:migraine_tracker/features/weather/presentation/environment_controller.dart';
import 'package:migraine_tracker/features/weather/presentation/environment_screen.dart';

/// First run: explainer, location, health, reminder, then the populated
/// environment screen. Every page can be skipped; the weather refresh
/// starts as soon as a location is chosen so the last screen has data.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;
  static const int _pages = 4;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    if (_page == _pages - 1) {
      await _finish();
      return;
    }
    await _controller.nextPage(
      duration: AppThemeTokens.animationMedium,
      curve: Curves.easeInOut,
    );
  }

  Future<void> _finish() async {
    await ref.read(onboardingStateProvider.notifier).complete();
    if (!mounted) return;
    // Home underneath so back from the environment screen lands there.
    context.go(AppRoutes.home);
    unawaited(context.push(AppRoutes.environment));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final last = _page == _pages - 1;
    return Scaffold(
      appBar: AppBar(
        title: Text(ref.watch(appConfigProvider).displayName),
        actions: [
          if (!last)
            TextButton(
              key: const ValueKey('onboarding-skip'),
              onPressed: _finish,
              child: Text(l10n.onboardingSkip),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _page = i),
                children: const [
                  _Page(child: _WelcomePage()),
                  _Page(child: _LocationPage()),
                  _Page(child: _HealthPage()),
                  _Page(child: _ReminderPage()),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppThemeTokens.space4),
              child: Row(
                children: [
                  Text(
                    l10n.onboardingStep(_page + 1, _pages),
                    key: const ValueKey('onboarding-step'),
                    style: context.textStyles.bodySmall,
                  ),
                  const Spacer(),
                  AppButton(
                    key: const ValueKey('onboarding-next'),
                    label: last ? l10n.onboardingFinish : l10n.onboardingNext,
                    icon: last ? Icons.check : Icons.arrow_forward,
                    onPressed: _next,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Page extends StatelessWidget {
  const _Page({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppThemeTokens.space4),
    child: child,
  );
}

class _WelcomePage extends StatelessWidget {
  const _WelcomePage();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.onboardingWelcomeTitle,
          style: context.textStyles.headlineMedium,
        ),
        const SizedBox(height: AppThemeTokens.space3),
        const LevelExplainer(),
      ],
    );
  }
}

class _LocationPage extends ConsumerWidget {
  const _LocationPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    // Watching the refresh here starts the first fetch as soon as a
    // location is chosen, so the last screen has data.
    ref.watch(weatherRefreshProvider);
    final location = ref.watch(weatherLocationProvider).value;
    final hasLocation = location?.cell != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.onboardingLocationTitle,
          style: context.textStyles.headlineMedium,
        ),
        const SizedBox(height: AppThemeTokens.space3),
        Text(l10n.onboardingLocationBody, style: context.textStyles.bodyLarge),
        const SizedBox(height: AppThemeTokens.space2),
        Text(l10n.envPrivacyNote, style: context.textStyles.bodySmall),
        const SizedBox(height: AppThemeTokens.space4),
        AppButton(
          key: const ValueKey('onboarding-use-location'),
          label: l10n.envUseMyLocation,
          icon: Icons.my_location,
          expand: true,
          onPressed: () async {
            await ref.read(weatherSyncProvider).useDeviceLocation();
            ref
              ..invalidate(weatherLocationProvider)
              ..invalidate(environmentViewProvider)
              ..invalidate(weatherRefreshProvider);
          },
        ),
        const SizedBox(height: AppThemeTokens.space2),
        AppButton(
          key: const ValueKey('onboarding-choose-city'),
          label: l10n.envChooseCity,
          icon: Icons.location_city,
          variant: AppButtonVariant.secondary,
          expand: true,
          onPressed: () => showCitySearchSheet(context),
        ),
        const SizedBox(height: AppThemeTokens.space4),
        Text(
          hasLocation
              ? locationLabel(l10n, location)
              : l10n.onboardingLocationNone,
          key: const ValueKey('onboarding-location-status'),
          style: context.textStyles.bodyMedium,
        ),
      ],
    );
  }
}

class _HealthPage extends ConsumerWidget {
  const _HealthPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    if (!AppFeatureFlags.healthSyncAvailable) return const SizedBox.shrink();
    final available = ref.watch(healthAvailableProvider).value;
    final consent =
        ref.watch(healthConsentProvider).value ?? const HealthConsent.none();
    final sync = ref.read(healthSyncProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.onboardingHealthTitle,
          style: context.textStyles.headlineMedium,
        ),
        const SizedBox(height: AppThemeTokens.space3),
        Text(l10n.onboardingHealthBody, style: context.textStyles.bodyLarge),
        const SizedBox(height: AppThemeTokens.space2),
        Text(l10n.healthPrivacyNote, style: context.textStyles.bodySmall),
        const SizedBox(height: AppThemeTokens.space3),
        if (available == false)
          Text(
            l10n.onboardingHealthUnavailable,
            key: const ValueKey('onboarding-health-unavailable'),
          )
        else
          for (final type in HealthType.values)
            SwitchListTile(
              key: ValueKey('onboarding-health-${type.name}'),
              contentPadding: EdgeInsets.zero,
              title: Text(healthTypeLabel(l10n, type)),
              subtitle: Text(healthTypeReason(l10n, type)),
              value: consent.allows(type),
              onChanged: (v) => sync.setConsent(type, allowed: v),
            ),
      ],
    );
  }
}

class _ReminderPage extends ConsumerWidget {
  const _ReminderPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final time =
        ref.watch(checkinReminderProvider).value ??
        AppThresholds.defaultCheckinReminder;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.onboardingReminderTitle,
          style: context.textStyles.headlineMedium,
        ),
        const SizedBox(height: AppThemeTokens.space3),
        Text(l10n.onboardingReminderBody, style: context.textStyles.bodyLarge),
        const SizedBox(height: AppThemeTokens.space4),
        AppCard(
          key: const ValueKey('onboarding-reminder-time'),
          onTap: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: time,
              helpText: l10n.checkinReminderPickerTitle,
            );
            if (picked != null) {
              await ref.read(checkinReminderProvider.notifier).set(picked);
            }
          },
          child: Row(
            children: [
              const Icon(Icons.alarm),
              const SizedBox(width: AppThemeTokens.space3),
              Expanded(
                child: Text(
                  l10n.checkinReminderAt(time.format(context)),
                  style: context.textStyles.titleMedium,
                ),
              ),
              const Icon(Icons.edit_outlined),
            ],
          ),
        ),
        const SizedBox(height: AppThemeTokens.space4),
        Text(l10n.onboardingReminderNote, style: context.textStyles.bodySmall),
      ],
    );
  }
}
