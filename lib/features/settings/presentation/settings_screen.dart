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
import 'package:migraine_tracker/features/cycle/presentation/cycle_screen.dart';
import 'package:migraine_tracker/features/export/data/export_service.dart';
import 'package:migraine_tracker/features/export/presentation/share_files.dart';
import 'package:url_launcher/url_launcher.dart';

/// Settings skeleton. Later phases add their sections here: health sync
/// (14), notifications (21), accounts and backup (32, 33), premium (35),
/// accessibility (38).
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final config = ref.watch(appConfigProvider);
    final reminder = ref.watch(checkinReminderProvider).value;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppThemeTokens.space2),
        children: [
          SectionHeader(title: l10n.settingsSectionDaily),
          ListTile(
            key: const ValueKey('settings-reminder'),
            leading: const Icon(Icons.alarm),
            title: Text(l10n.checkinReminderPickerTitle),
            subtitle: Text(reminder == null ? '' : reminder.format(context)),
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: reminder ?? AppThresholds.defaultCheckinReminder,
                helpText: l10n.checkinReminderPickerTitle,
              );
              if (picked != null) {
                await ref.read(checkinReminderProvider.notifier).set(picked);
              }
            },
          ),
          if (AppFeatureFlags.cycleTrackingAvailable)
            const CycleTrackingToggle(),
          if (AppFeatureFlags.healthSyncAvailable)
            ListTile(
              key: const ValueKey('settings-health'),
              leading: const Icon(Icons.favorite_outline),
              title: Text(l10n.healthTitle),
              subtitle: Text(l10n.settingsHealthHint),
              onTap: () => context.push(AppRoutes.health),
            ),
          SectionHeader(title: l10n.settingsSectionData),
          ListTile(
            key: const ValueKey('settings-routines'),
            leading: const Icon(Icons.self_improvement_outlined),
            title: Text(l10n.routinesTitle),
            subtitle: Text(l10n.settingsRoutinesHint),
            onTap: () => context.push(AppRoutes.routines),
          ),
          ListTile(
            key: const ValueKey('settings-questionnaires'),
            leading: const Icon(Icons.checklist_outlined),
            title: Text(l10n.questionnairesTitle),
            subtitle: Text(l10n.settingsQuestionnairesHint),
            onTap: () => context.push(AppRoutes.questionnaires),
          ),
          ListTile(
            key: const ValueKey('settings-report'),
            leading: const Icon(Icons.description_outlined),
            title: Text(l10n.reportTitle),
            subtitle: Text(l10n.settingsReportHint),
            onTap: () => context.push(AppRoutes.report),
          ),
          ListTile(
            key: const ValueKey('settings-export-json'),
            leading: const Icon(Icons.data_object),
            title: Text(l10n.settingsExportJson),
            subtitle: Text(l10n.settingsExportJsonHint),
            onTap: () => _exportJson(context, ref),
          ),
          ListTile(
            key: const ValueKey('settings-export-csv'),
            leading: const Icon(Icons.table_chart_outlined),
            title: Text(l10n.settingsExportCsv),
            subtitle: Text(l10n.settingsExportCsvHint),
            onTap: () => _exportCsv(context, ref),
          ),
          ListTile(
            key: const ValueKey('settings-delete-all'),
            leading: Icon(
              Icons.delete_forever,
              color: context.appColors.danger,
            ),
            title: Text(
              l10n.settingsDeleteAll,
              style: TextStyle(color: context.appColors.danger),
            ),
            subtitle: Text(l10n.settingsDeleteAllHint),
            onTap: () => _confirmDelete(context, ref),
          ),
          SectionHeader(title: l10n.settingsSectionAbout),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(config.displayName),
            subtitle: const Text(AppIdentity.wellnessDisclaimer),
          ),
          ListTile(
            key: const ValueKey('settings-notifications'),
            leading: const Icon(Icons.notifications_outlined),
            title: Text(l10n.notificationsTitle),
            subtitle: Text(l10n.settingsNotificationsHint),
            onTap: () => context.push(AppRoutes.notifications),
          ),
          ListTile(
            key: const ValueKey('settings-insights'),
            leading: const Icon(Icons.insights_outlined),
            title: Text(l10n.insightsTitle),
            subtitle: Text(l10n.settingsInsightsHint),
            onTap: () => context.push(AppRoutes.insights),
          ),
          ListTile(
            key: const ValueKey('settings-explainer'),
            leading: const Icon(Icons.help_outline),
            title: Text(l10n.explainerTitle),
            onTap: () => context.push(AppRoutes.explainer),
          ),
          ListTile(
            key: const ValueKey('settings-about-data'),
            leading: const Icon(Icons.dataset_outlined),
            title: Text(l10n.aboutDataTitle),
            onTap: () => context.push(AppRoutes.aboutData),
          ),
          ListTile(
            key: const ValueKey('settings-privacy'),
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(l10n.settingsPrivacyPolicy),
            onTap: () => _open(AppIdentity.privacyPolicyUrl),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(l10n.settingsTerms),
            onTap: () => _open(AppIdentity.termsUrl),
          ),
          ListTile(
            leading: const Icon(Icons.mail_outline),
            title: Text(l10n.settingsSupport),
            subtitle: const Text(AppIdentity.supportEmail),
            onTap: () => _open('mailto:${AppIdentity.supportEmail}'),
          ),
        ],
      ),
    );
  }

  Future<void> _open(String url) =>
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);

  Future<void> _exportJson(BuildContext context, WidgetRef ref) async {
    final file = await ref.read(exportServiceProvider).writeJsonFile();
    await ref.read(shareFilesProvider)([file], text: AppIdentity.name);
  }

  Future<void> _exportCsv(BuildContext context, WidgetRef ref) async {
    final files = await ref.read(exportServiceProvider).writeCsvFiles();
    if (!context.mounted) return;
    if (files.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.settingsExportEmpty)));
      return;
    }
    await ref.read(shareFilesProvider)(files, text: AppIdentity.name);
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final service = ref.read(exportServiceProvider);
    final counts = await service.rowCounts();
    final total = counts.values.fold(0, (a, b) => a + b);
    if (!context.mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.settingsDeleteAll),
        content: Text(l10n.settingsDeleteAllConfirm(total)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.settingsCancel),
          ),
          FilledButton(
            key: const ValueKey('settings-delete-confirm'),
            style: FilledButton.styleFrom(
              backgroundColor: context.appColors.danger,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.settingsDeleteAllButton),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await service.deleteEverything();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.settingsDeletedAll)));
  }
}
