import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/core/widgets/widgets.dart';
import 'package:migraine_tracker/features/attack_log/presentation/attack_log_controller.dart';
import 'package:migraine_tracker/features/audit/application/self_audit_controller.dart';
import 'package:migraine_tracker/features/audit/data/functions_audit_gateway.dart';
import 'package:migraine_tracker/features/audit/domain/self_audit.dart';

/// Accuracy self-audit (FR-13): how often attacks followed a High day, how
/// many High days passed without one, and the trend by month.
class AuditScreen extends ConsumerWidget {
  const AuditScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final ready = ref.watch(selfAuditReadyProvider);
    final logged = ref.watch(attacksProvider).value?.length ?? 0;
    final audit = ref.watch(selfAuditProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.auditTitle)),
      body: ListView(
        key: const ValueKey('audit-list'),
        padding: const EdgeInsets.all(AppThemeTokens.space4),
        children: [
          if (!ready)
            Text(
              l10n.auditNotYet(AppThresholds.attacksBeforeSelfAudit, logged),
              key: const ValueKey('audit-not-yet'),
            )
          else ...[
            Text(
              l10n.auditIntro(AppThresholds.auditWindowDays),
              style: context.textStyles.bodyMedium,
            ),
            const SizedBox(height: AppThemeTokens.space4),
            if (audit == null)
              const SizedBox.shrink()
            else if (audit.total.isEmpty)
              Text(l10n.auditEmpty, key: const ValueKey('audit-empty'))
            else ...[
              _Totals(counts: audit.total),
              const SizedBox(height: AppThemeTokens.space4),
              SectionHeader(title: l10n.auditTrend),
              _Trend(byMonth: audit.byMonth),
            ],
            const SizedBox(height: AppThemeTokens.space3),
            AppCard(
              key: const ValueKey('audit-caveat'),
              child: Text(l10n.auditCaveat),
            ),
            if (AppFeatureFlags.auditUploadAvailable &&
                ref.watch(auditGatewayProvider).available) ...[
              const SizedBox(height: AppThemeTokens.space3),
              SwitchListTile(
                key: const ValueKey('audit-share'),
                contentPadding: EdgeInsets.zero,
                value: ref.watch(auditShareProvider).value ?? false,
                title: Text(l10n.auditShare),
                subtitle: Text(l10n.auditShareHint),
                onChanged: (on) =>
                    unawaited(ref.read(auditUploaderProvider).setShare(on: on)),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

String _percent(BuildContext context, double share) =>
    NumberFormat.percentPattern(Localizations.localeOf(context).toString())
        .format(share);

class _Totals extends StatelessWidget {
  const _Totals({required this.counts});

  final AuditCounts counts;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    Widget line(String key, String title, String value) => Padding(
      key: ValueKey(key),
      padding: const EdgeInsets.only(bottom: AppThemeTokens.space3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: context.textStyles.titleMedium),
          Text(value, key: ValueKey('$key-value')),
        ],
      ),
    );
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          line(
            'audit-hits',
            l10n.auditHitsTitle,
            l10n.auditHitsValue(
              counts.hits,
              counts.attacks,
              _percent(context, counts.hitShare ?? 0),
            ),
          ),
          line(
            'audit-misses',
            l10n.auditMissesTitle,
            l10n.auditMissesValue(counts.misses),
          ),
          line(
            'audit-false-alarms',
            l10n.auditFalseAlarmsTitle,
            l10n.auditFalseAlarmsValue(counts.falseAlarms, counts.highDays),
          ),
        ],
      ),
    );
  }
}

class _Trend extends StatelessWidget {
  const _Trend({required this.byMonth});

  final Map<String, AuditCounts> byMonth;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final format = DateFormat.yMMM(Localizations.localeOf(context).toString());
    final months = byMonth.keys.toList().reversed.take(
      AppThresholds.auditTrendMonths,
    );
    return Column(
      children: [
        for (final m in months)
          ListTile(
            key: ValueKey('audit-month-$m'),
            contentPadding: EdgeInsets.zero,
            title: Text(
              format.format(
                DateTime(
                  int.parse(m.substring(0, 4)),
                  int.parse(m.substring(5)),
                ),
              ),
            ),
            subtitle: Text(
              l10n.auditMonthLine(
                byMonth[m]!.hits,
                byMonth[m]!.attacks,
                byMonth[m]!.falseAlarms,
                byMonth[m]!.highDays,
              ),
            ),
          ),
      ],
    );
  }
}
