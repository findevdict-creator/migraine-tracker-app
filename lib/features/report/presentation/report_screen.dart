import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/core/widgets/widgets.dart';
import 'package:migraine_tracker/features/export/presentation/share_files.dart';
import 'package:migraine_tracker/features/report/application/report_service.dart';
import 'package:migraine_tracker/features/report/domain/report_model.dart';
import 'package:migraine_tracker/features/share_link/presentation/share_link_sheet.dart';

/// Pick a period, see what it holds, share the PDF or the spreadsheets.
class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({super.key});

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  static const _presets = [30, 90, 180, 365];

  late ReportRange _range;
  int? _preset = AppThresholds.defaultReportDays;
  Future<ReportSummary>? _summary;
  bool _busy = false;
  bool _includeQuestionnaires = true;

  @override
  void initState() {
    super.initState();
    _range = ReportRange.lastDays(
      AppThresholds.defaultReportDays,
      today: ref.read(clockProvider)(),
    );
    _reload();
  }

  void _reload() {
    setState(() {
      _summary = ref.read(reportServiceProvider).summary(_range);
    });
  }

  void _pickPreset(int days) {
    _preset = days;
    _range = ReportRange.lastDays(days, today: ref.read(clockProvider)());
    _reload();
  }

  Future<void> _pickCustom() async {
    final now = ref.read(clockProvider)();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
      initialDateRange: DateTimeRange(start: _range.from, end: _range.to),
    );
    if (picked == null || !mounted) return;
    _preset = null;
    _range = ReportRange(picked.start, picked.end);
    _reload();
  }

  Future<void> _share(ReportFormat format) async {
    if (_busy) return;
    setState(() => _busy = true);
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final messenger = ScaffoldMessenger.of(context);
    List<File> files;
    try {
      files = await ref
          .read(reportServiceProvider)
          .write(
            _range,
            format: format,
            l10n: l10n,
            locale: locale,
            includeQuestionnaires: _includeQuestionnaires,
          );
    } on Exception catch (e) {
      debugPrint('report failed: $e');
      messenger.showSnackBar(SnackBar(content: Text(l10n.reportFailed)));
      if (mounted) setState(() => _busy = false);
      return;
    }
    try {
      await ref.read(shareFilesProvider)(files, text: AppIdentity.name);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final fmt = DateFormat.yMMMd(locale);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.reportTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppThemeTokens.space4),
        children: [
          Text(l10n.reportIntro, style: context.textStyles.bodyMedium),
          SectionHeader(title: l10n.reportRangeLabel),
          Wrap(
            spacing: AppThemeTokens.space2,
            runSpacing: AppThemeTokens.space2,
            children: [
              for (final days in _presets)
                AppChoiceChip(
                  key: ValueKey('report-range-$days'),
                  label: l10n.reportRangeDays(days),
                  selected: _preset == days,
                  onSelected: (_) => _pickPreset(days),
                ),
              AppChoiceChip(
                key: const ValueKey('report-range-custom'),
                label: l10n.reportRangeCustom,
                selected: _preset == null,
                onSelected: (_) => _pickCustom(),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppThemeTokens.space2,
            ),
            child: Text(
              l10n.reportRangeText(
                fmt.format(_range.from),
                fmt.format(_range.to),
              ),
              key: const ValueKey('report-range-text'),
              style: context.textStyles.bodySmall,
            ),
          ),
          AppCard(
            child: FutureBuilder<ReportSummary>(
              future: _summary,
              builder: (context, snapshot) {
                final r = snapshot.data;
                if (r == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Column(
                  key: const ValueKey('report-preview'),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.reportPreviewAttacks(r.attacks),
                      style: context.textStyles.titleMedium,
                    ),
                    Text(
                      [
                        l10n.reportPreviewAttackDays(r.attackDays),
                        l10n.reportPreviewDoses(r.inputs.medications.length),
                        l10n.reportPreviewCheckins(r.checkinDays),
                      ].join(', '),
                    ),
                    if (r.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(
                          top: AppThemeTokens.space2,
                        ),
                        child: Text(
                          l10n.reportEmpty,
                          style: context.textStyles.bodySmall?.copyWith(
                            color: context.appColors.warning,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: AppThemeTokens.space4),
          SwitchListTile(
            key: const ValueKey('report-include-questionnaires'),
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.reportIncludeQuestionnaires),
            subtitle: Text(l10n.reportIncludeQuestionnairesHint),
            value: _includeQuestionnaires,
            onChanged: (v) => setState(() => _includeQuestionnaires = v),
          ),
          const SizedBox(height: AppThemeTokens.space2),
          AppButton(
            key: const ValueKey('report-share-pdf'),
            label: l10n.reportSharePdf,
            icon: Icons.picture_as_pdf_outlined,
            expand: true,
            onPressed: _busy ? null : () => _share(ReportFormat.pdf),
          ),
          const SizedBox(height: AppThemeTokens.space2),
          AppButton(
            key: const ValueKey('report-share-csv'),
            label: l10n.reportShareCsv,
            icon: Icons.table_chart_outlined,
            variant: AppButtonVariant.secondary,
            expand: true,
            onPressed: _busy ? null : () => _share(ReportFormat.csv),
          ),
          const SizedBox(height: AppThemeTokens.space2),
          AppButton(
            key: const ValueKey('report-share-all'),
            label: l10n.reportShareAll,
            icon: Icons.share_outlined,
            variant: AppButtonVariant.secondary,
            expand: true,
            onPressed: _busy ? null : () => _share(ReportFormat.all),
          ),
          if (AppFeatureFlags.shareLinkAvailable) ...[
            const SizedBox(height: AppThemeTokens.space2),
            AppButton(
              key: const ValueKey('report-share-link'),
              label: l10n.shareLinkButton,
              icon: Icons.link,
              variant: AppButtonVariant.secondary,
              expand: true,
              onPressed: _busy
                  ? null
                  : () => showShareLinkSheet(
                      context,
                      range: _range,
                      includeQuestionnaires: _includeQuestionnaires,
                    ),
            ),
          ],
          if (_busy)
            Padding(
              padding: const EdgeInsets.only(top: AppThemeTokens.space4),
              child: Row(
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: AppThemeTokens.space2),
                  Text(l10n.reportBuilding),
                ],
              ),
            ),
          SectionHeader(title: l10n.reportWhatIsIn),
          Text(l10n.reportContents, style: context.textStyles.bodySmall),
        ],
      ),
    );
  }
}
