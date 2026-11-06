import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:migraine_tracker/app/router.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/core/widgets/widgets.dart';
import 'package:migraine_tracker/features/questionnaires/domain/questionnaire.dart';
import 'package:migraine_tracker/features/questionnaires/presentation/questionnaire_controller.dart';
import 'package:migraine_tracker/features/questionnaires/presentation/score_chart.dart';

/// One card per instrument: latest score and band, due state, score
/// history chart, and the button into the form.
class QuestionnairesScreen extends ConsumerWidget {
  const QuestionnairesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final due = ref.watch(questionnaireDueProvider).value;
    final now = ref.watch(clockProvider)();
    return Scaffold(
      appBar: AppBar(title: Text(l10n.questionnairesTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppThemeTokens.space4),
        children: [
          Text(l10n.questionnairesIntro, style: context.textStyles.bodyMedium),
          const SizedBox(height: AppThemeTokens.space4),
          for (final kind in QuestionnaireKind.values) ...[
            _KindCard(kind: kind, due: due, now: now),
            const SizedBox(height: AppThemeTokens.space4),
          ],
          SectionHeader(title: l10n.questionnaireAbout),
          Text(
            l10n.questionnaireAboutBody,
            style: context.textStyles.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _KindCard extends ConsumerWidget {
  const _KindCard({required this.kind, required this.due, required this.now});

  final QuestionnaireKind kind;
  final DateTime? due;
  final DateTime now;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final fmt = DateFormat.yMMMd(locale);
    final history = ref.watch(questionnaireHistoryProvider(kind)).value;
    final latest = history == null || history.isEmpty ? null : history.last;
    final isDue = due != null && !due!.isAfter(now);
    return AppCard(
      child: Column(
        key: ValueKey('questionnaire-card-${kind.code}'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            questionnaireTitle(l10n, kind),
            style: context.textStyles.titleLarge,
          ),
          Text(
            questionnaireSubtitle(l10n, kind),
            style: context.textStyles.bodySmall,
          ),
          const SizedBox(height: AppThemeTokens.space3),
          if (latest == null)
            Text(
              l10n.questionnaireNeverDone,
              key: ValueKey('questionnaire-latest-${kind.code}'),
            )
          else ...[
            Text(
              l10n.questionnaireLatest(
                latest.score,
                fmt.format(latest.completedAt),
              ),
              key: ValueKey('questionnaire-latest-${kind.code}'),
              style: context.textStyles.titleMedium,
            ),
            Text(
              bandLabel(l10n, kind, latest.band),
              key: ValueKey('questionnaire-band-${kind.code}'),
            ),
            if (due != null)
              Padding(
                padding: const EdgeInsets.only(top: AppThemeTokens.space1),
                child: Text(
                  isDue
                      ? l10n.questionnaireDueNow
                      : l10n.questionnaireDueOn(fmt.format(due!)),
                  key: ValueKey('questionnaire-due-${kind.code}'),
                  style: context.textStyles.bodySmall?.copyWith(
                    color: isDue ? context.appColors.warning : null,
                  ),
                ),
              ),
            if (history!.length > 1) ...[
              const SizedBox(height: AppThemeTokens.space3),
              Text(
                l10n.questionnaireHistory,
                style: context.textStyles.labelLarge,
              ),
              const SizedBox(height: AppThemeTokens.space2),
              ScoreChart(
                kind: kind,
                responses: history,
                semanticLabel: l10n.questionnaireChartLabel(
                  history.length,
                  fmt.format(history.first.completedAt),
                  fmt.format(history.last.completedAt),
                  history.last.score,
                ),
              ),
            ],
          ],
          const SizedBox(height: AppThemeTokens.space3),
          AppButton(
            key: ValueKey('questionnaire-start-${kind.code}'),
            label: latest == null
                ? l10n.questionnaireStart
                : l10n.questionnaireRepeat,
            variant: latest == null || isDue
                ? AppButtonVariant.primary
                : AppButtonVariant.secondary,
            expand: true,
            onPressed: () => context.push(AppRoutes.questionnaire(kind.code)),
          ),
        ],
      ),
    );
  }
}
