import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/core/units/units.dart';
import 'package:migraine_tracker/features/notifications/application/notification_scheduler.dart';
import 'package:migraine_tracker/features/notifications/data/local_notification_gateway.dart';
import 'package:migraine_tracker/features/notifications/domain/notification_types.dart';

/// The switches and knobs, read live from settings.
class NotificationSettings {
  const NotificationSettings({
    required this.enabled,
    required this.pressureThreshold,
    required this.medicationTime,
  });

  final Map<NotificationType, bool> enabled;
  final double pressureThreshold;
  final TimeOfDay medicationTime;
}

final notificationSettingsProvider =
    AsyncNotifierProvider<NotificationSettingsController, NotificationSettings>(
      NotificationSettingsController.new,
    );

class NotificationSettingsController
    extends AsyncNotifier<NotificationSettings> {
  NotificationScheduler get _scheduler =>
      ref.read(notificationSchedulerProvider);

  @override
  Future<NotificationSettings> build() async => NotificationSettings(
    enabled: {
      for (final t in NotificationType.values) t: await _scheduler.isEnabled(t),
    },
    pressureThreshold: await _scheduler.pressureThreshold(),
    medicationTime: await _scheduler.medicationTime(),
  );

  /// Turning a type on asks the OS for permission the first time.
  Future<bool> setEnabled(
    NotificationType type, {
    required bool enabled,
  }) async {
    var granted = true;
    if (enabled) {
      granted = await ref.read(notificationGatewayProvider).requestPermission();
    }
    await _scheduler.setEnabled(type, enabled: enabled);
    await _refresh();
    return granted;
  }

  Future<void> setPressureThreshold(double hpa) async {
    await _scheduler.setPressureThreshold(hpa);
    await _refresh();
  }

  Future<void> setMedicationTime(TimeOfDay time) async {
    await _scheduler.setMedicationTime(time);
    await _refresh();
  }

  Future<void> _refresh() async {
    state = AsyncData(await build());
    await _scheduler.reschedule();
  }
}

/// FR-14: one switch per type, the pressure threshold and the preventive
/// reminder time.
class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends ConsumerState<NotificationSettingsScreen> {
  bool _denied = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final units = ref.watch(unitsProvider);
    final settings = ref.watch(notificationSettingsProvider).value;
    final controller = ref.read(notificationSettingsProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.notificationsTitle)),
      body: settings == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.symmetric(
                vertical: AppThemeTokens.space2,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppThemeTokens.space4,
                  ),
                  child: Text(
                    l10n.notificationsIntro,
                    style: context.textStyles.bodyMedium,
                  ),
                ),
                if (_denied)
                  Padding(
                    padding: const EdgeInsets.all(AppThemeTokens.space4),
                    child: Text(
                      l10n.notificationsPermissionDenied,
                      key: const ValueKey('notif-denied'),
                      style: context.textStyles.bodyMedium?.copyWith(
                        color: context.appColors.warning,
                      ),
                    ),
                  ),
                for (final type in NotificationType.values)
                  SwitchListTile(
                    key: ValueKey('notif-${type.code}'),
                    title: Text(_title(l10n, type)),
                    subtitle: Text(_hint(l10n, type, settings, units)),
                    value: settings.enabled[type] ?? type.defaultOn,
                    onChanged: (on) async {
                      final granted = await controller.setEnabled(
                        type,
                        enabled: on,
                      );
                      if (mounted) setState(() => _denied = on && !granted);
                    },
                  ),
                ListTile(
                  key: const ValueKey('notif-threshold'),
                  title: Text(
                    l10n.notifPressureThreshold(
                      units.pressureChange(l10n, settings.pressureThreshold),
                    ),
                  ),
                  subtitle: Slider(
                    key: const ValueKey('notif-threshold-slider'),
                    value: settings.pressureThreshold,
                    min: 2,
                    max: 12,
                    divisions: 10,
                    label: units.pressureChange(
                      l10n,
                      settings.pressureThreshold,
                    ),
                    onChanged: controller.setPressureThreshold,
                  ),
                ),
                ListTile(
                  key: const ValueKey('notif-medication-time'),
                  title: Text(l10n.notifMedicationTime),
                  subtitle: Text(settings.medicationTime.format(context)),
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: settings.medicationTime,
                      helpText: l10n.notifMedicationTime,
                    );
                    if (picked != null) {
                      await controller.setMedicationTime(picked);
                    }
                  },
                ),
              ],
            ),
    );
  }

  String _title(AppLocalizations l10n, NotificationType type) => switch (type) {
    NotificationType.riskRising => l10n.notifTypeRiskRising,
    NotificationType.pressureDrop => l10n.notifTypePressureDrop,
    NotificationType.attackOver => l10n.notifTypeAttackOver,
    NotificationType.checkin => l10n.notifTypeCheckin,
    NotificationType.medication => l10n.notifTypeMedication,
    NotificationType.questionnaire => l10n.notifTypeQuestionnaire,
  };

  String _hint(
    AppLocalizations l10n,
    NotificationType type,
    NotificationSettings settings,
    Units units,
  ) => switch (type) {
    NotificationType.riskRising => l10n.notifTypeRiskRisingHint,
    NotificationType.pressureDrop => l10n.notifTypePressureDropHint(
      units.pressureChange(l10n, settings.pressureThreshold),
    ),
    NotificationType.attackOver => l10n.notifTypeAttackOverHint,
    NotificationType.checkin => l10n.notifTypeCheckinHint,
    NotificationType.medication => l10n.notifTypeMedicationHint,
    NotificationType.questionnaire => l10n.notifTypeQuestionnaireHint,
  };
}
