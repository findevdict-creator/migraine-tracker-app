import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/core/widgets/widgets.dart';
import 'package:migraine_tracker/features/questionnaires/domain/questionnaire.dart';
import 'package:migraine_tracker/features/questionnaires/presentation/questionnaire_controller.dart';

/// The MIDAS day counts or the HIT-6 options, then the score and band.
class QuestionnaireFormScreen extends ConsumerStatefulWidget {
  const QuestionnaireFormScreen({required this.kindCode, super.key});

  final String kindCode;

  @override
  ConsumerState<QuestionnaireFormScreen> createState() =>
      _QuestionnaireFormScreenState();
}

class _QuestionnaireFormScreenState
    extends ConsumerState<QuestionnaireFormScreen> {
  final _answers = <String, int>{};
  bool _saving = false;

  QuestionnaireKind get _kind =>
      QuestionnaireKind.fromCode(widget.kindCode) ?? QuestionnaireKind.midas;

  bool get _complete => _kind.isComplete(_answers);

  Future<void> _save() async {
    if (!_complete || _saving) return;
    setState(() => _saving = true);
    final l10n = context.l10n;
    final kind = _kind;
    final response = await ref
        .read(questionnaireSaverProvider)
        .save(kind, _answers);
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        key: const ValueKey('questionnaire-result'),
        title: Text(l10n.questionnaireResultTitle(response.score)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              bandLabel(l10n, kind, response.band),
              key: const ValueKey('questionnaire-result-band'),
              style: dialogContext.textStyles.titleMedium,
            ),
            const SizedBox(height: AppThemeTokens.space3),
            Text(
              l10n.questionnaireResultDisclaimer,
              style: dialogContext.textStyles.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            key: const ValueKey('questionnaire-result-done'),
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.questionnaireResultDone),
          ),
        ],
      ),
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final kind = _kind;
    return Scaffold(
      appBar: AppBar(title: Text(questionnaireTitle(l10n, kind))),
      body: ListView(
        padding: const EdgeInsets.all(AppThemeTokens.space4),
        children: [
          Text(switch (kind) {
            QuestionnaireKind.midas => l10n.questionnaireMidasIntro,
            QuestionnaireKind.hit6 => l10n.questionnaireHit6Intro,
          }, style: context.textStyles.bodyMedium),
          const SizedBox(height: AppThemeTokens.space4),
          switch (kind) {
            QuestionnaireKind.midas => _MidasItems(
              answers: _answers,
              onChanged: (item, value) => setState(() {
                if (value == null) {
                  _answers.remove(item);
                } else {
                  _answers[item] = value;
                }
              }),
            ),
            QuestionnaireKind.hit6 => _Hit6Items(
              answers: _answers,
              onChanged: (item, option) =>
                  setState(() => _answers[item] = option.points),
            ),
          },
          const SizedBox(height: AppThemeTokens.space4),
          if (!_complete)
            Padding(
              padding: const EdgeInsets.only(bottom: AppThemeTokens.space2),
              child: Text(
                l10n.questionnaireIncomplete,
                key: const ValueKey('questionnaire-incomplete'),
                style: context.textStyles.bodySmall,
              ),
            ),
          AppButton(
            key: const ValueKey('questionnaire-save'),
            label: l10n.questionnaireSave,
            expand: true,
            large: true,
            onPressed: _complete && !_saving ? _save : null,
          ),
        ],
      ),
    );
  }
}

class _MidasItems extends StatelessWidget {
  const _MidasItems({required this.answers, required this.onChanged});

  final Map<String, int> answers;
  final void Function(String item, int? value) onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (i, item) in Midas.items.indexed) ...[
          Text(
            '${i + 1}. ${midasQuestion(l10n, item)}',
            style: context.textStyles.bodyLarge,
          ),
          if (!Midas.scoredItems.contains(item))
            Text(
              l10n.questionnaireMidasUnscored,
              style: context.textStyles.bodySmall,
            ),
          const SizedBox(height: AppThemeTokens.space2),
          TextFormField(
            key: ValueKey('midas-$item'),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(2),
            ],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              labelText: item == Midas.painAverage
                  ? l10n.questionnairePainField
                  : l10n.questionnaireDaysField,
              border: const OutlineInputBorder(),
            ),
            validator: (text) {
              final v = int.tryParse(text ?? '');
              return v == null || v > Midas.maxFor(item)
                  ? l10n.questionnaireDaysError(Midas.maxFor(item))
                  : null;
            },
            onChanged: (text) {
              final v = int.tryParse(text);
              onChanged(item, v == null || v > Midas.maxFor(item) ? null : v);
            },
          ),
          const SizedBox(height: AppThemeTokens.space4),
        ],
      ],
    );
  }
}

class _Hit6Items extends StatelessWidget {
  const _Hit6Items({required this.answers, required this.onChanged});

  final Map<String, int> answers;
  final void Function(String item, Hit6Option option) onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (i, item) in Hit6.items.indexed) ...[
          Text(
            '${i + 1}. ${hit6Question(l10n, item)}',
            style: context.textStyles.bodyLarge,
          ),
          const SizedBox(height: AppThemeTokens.space2),
          Wrap(
            spacing: AppThemeTokens.space2,
            runSpacing: AppThemeTokens.space2,
            children: [
              for (final option in Hit6Option.values)
                AppChoiceChip(
                  key: ValueKey('hit6-$item-${option.name}'),
                  label: hit6OptionLabel(l10n, option),
                  selected: answers[item] == option.points,
                  onSelected: (_) => onChanged(item, option),
                ),
            ],
          ),
          const SizedBox(height: AppThemeTokens.space4),
        ],
      ],
    );
  }
}
