import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/core/widgets/widgets.dart';
import 'package:migraine_tracker/features/health/application/health_sync.dart';
import 'package:migraine_tracker/features/health/data/health_source_impl.dart';
import 'package:migraine_tracker/features/health/domain/health_entities.dart';
import 'package:migraine_tracker/features/weather/presentation/weather_text.dart';

/// Whether a health store exists on this device.
final healthAvailableProvider = FutureProvider<bool>(
  (ref) => ref.watch(healthSourceProvider).isAvailable(),
);

/// Health settings: one consent per type with a plain-language reason, the
/// write-back switch, and a manual import.
class HealthSettingsScreen extends ConsumerStatefulWidget {
  const HealthSettingsScreen({super.key});

  @override
  ConsumerState<HealthSettingsScreen> createState() =>
      _HealthSettingsScreenState();
}

class _HealthSettingsScreenState extends ConsumerState<HealthSettingsScreen> {
  bool _busy = false;
  HealthSyncResult? _last;

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _busy = true);
    try {
      await action();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final available = ref.watch(healthAvailableProvider).value;
    final consent =
        ref.watch(healthConsentProvider).value ?? const HealthConsent.none();
    final writeBack = ref.watch(healthWriteHeadachesProvider).value ?? false;
    final lastImport = ref.watch(healthLastImportProvider).value;
    final sync = ref.read(healthSyncProvider);
    final store = ref.read(healthSourceProvider).store;
    final storeName = store == HealthStore.healthkit
        ? l10n.healthStoreApple
        : l10n.healthStoreConnect;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.healthTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppThemeTokens.space4),
        children: [
          Text(
            l10n.healthIntro(storeName),
            style: context.textStyles.bodyLarge,
          ),
          const SizedBox(height: AppThemeTokens.space2),
          Text(l10n.healthPrivacyNote, style: context.textStyles.bodySmall),
          if (available == false)
            Padding(
              padding: const EdgeInsets.only(top: AppThemeTokens.space3),
              child: AppCard(
                key: const ValueKey('health-unavailable'),
                child: Text(l10n.healthUnavailable(storeName)),
              ),
            ),
          const SizedBox(height: AppThemeTokens.space4),
          SectionHeader(title: l10n.healthReadSection),
          for (final type in HealthType.values)
            SwitchListTile(
              key: ValueKey('health-${type.name}'),
              title: Text(healthTypeLabel(l10n, type)),
              subtitle: Text(healthTypeReason(l10n, type)),
              value: consent.allows(type),
              onChanged: _busy || available == false
                  ? null
                  : (v) => _run(() async {
                      final granted = await sync.setConsent(type, allowed: v);
                      if (v && !granted && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.healthDenied(storeName))),
                        );
                      }
                    }),
            ),
          const SizedBox(height: AppThemeTokens.space4),
          SectionHeader(title: l10n.healthWriteSection),
          SwitchListTile(
            key: const ValueKey('health-write'),
            title: Text(l10n.healthWriteHeadaches(storeName)),
            subtitle: Text(l10n.healthWriteHeadachesHint),
            value: writeBack,
            onChanged: _busy || available == false
                ? null
                : (v) => _run(() => sync.setWriteHeadaches(enabled: v)),
          ),
          const SizedBox(height: AppThemeTokens.space4),
          SectionHeader(title: l10n.healthImportSection),
          ListTile(
            key: const ValueKey('health-sync-now'),
            leading: const Icon(Icons.sync),
            title: Text(l10n.healthImportNow),
            subtitle: Text(
              lastImport == null
                  ? l10n.healthImportNever
                  : l10n.healthImportLast(
                      forecastAge(
                        l10n,
                        ref.read(clockNowProvider).difference(lastImport),
                      ),
                    ),
              key: const ValueKey('health-last-import'),
            ),
            enabled: !_busy && consent.any,
            onTap: () => _run(() async => _last = await sync.sync()),
          ),
          if (_last case final result?)
            Padding(
              padding: const EdgeInsets.only(top: AppThemeTokens.space2),
              child: Text(
                result.error != null
                    ? l10n.healthImportFailed
                    : l10n.healthImportResult(
                        result.imported,
                        result.prefilledDays,
                      ),
                key: const ValueKey('health-import-result'),
                style: context.textStyles.bodyMedium,
              ),
            ),
        ],
      ),
    );
  }
}

/// Current time for the ages shown on this screen, from the app clock.
final clockNowProvider = Provider<DateTime>(
  (ref) => ref.watch(clockProvider)().toUtc(),
);

String healthTypeLabel(AppLocalizations l10n, HealthType type) =>
    switch (type) {
      HealthType.sleep => l10n.healthTypeSleep,
      HealthType.restingHr => l10n.healthTypeRestingHr,
      HealthType.hrv => l10n.healthTypeHrv,
      HealthType.steps => l10n.healthTypeSteps,
      HealthType.menstrualFlow => l10n.healthTypeFlow,
    };

String healthTypeReason(AppLocalizations l10n, HealthType type) =>
    switch (type) {
      HealthType.sleep => l10n.healthReasonSleep,
      HealthType.restingHr => l10n.healthReasonRestingHr,
      HealthType.hrv => l10n.healthReasonHrv,
      HealthType.steps => l10n.healthReasonSteps,
      HealthType.menstrualFlow => l10n.healthReasonFlow,
    };
