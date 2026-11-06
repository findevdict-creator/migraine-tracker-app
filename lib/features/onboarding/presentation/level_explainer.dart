import 'package:flutter/material.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/core/widgets/widgets.dart';

/// What the daily level can and cannot do. Shown in onboarding, behind the
/// risk card (phase 18) and from Settings.
class LevelExplainer extends StatelessWidget {
  const LevelExplainer({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final does = [
      l10n.explainerDoes1,
      l10n.explainerDoes2,
      l10n.explainerDoes3,
    ];
    final doesNot = [
      l10n.explainerDoesNot1,
      l10n.explainerDoesNot2,
      l10n.explainerDoesNot3,
    ];
    return Column(
      key: const ValueKey('level-explainer'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.explainerIntro, style: context.textStyles.bodyLarge),
        const SizedBox(height: AppThemeTokens.space4),
        SectionHeader(title: l10n.explainerDoesTitle),
        for (final line in does) _Line(icon: Icons.check, text: line),
        const SizedBox(height: AppThemeTokens.space3),
        SectionHeader(title: l10n.explainerDoesNotTitle),
        for (final line in doesNot) _Line(icon: Icons.close, text: line),
        const SizedBox(height: AppThemeTokens.space4),
        Text(
          AppIdentity.wellnessDisclaimer,
          style: context.textStyles.bodySmall,
        ),
      ],
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: AppThemeTokens.space2),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: AppThemeTokens.space2),
        Expanded(child: Text(text)),
      ],
    ),
  );
}

/// Standalone page for the explainer.
class ExplainerScreen extends StatelessWidget {
  const ExplainerScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.l10n.explainerTitle)),
    body: const SingleChildScrollView(
      padding: EdgeInsets.all(AppThemeTokens.space4),
      child: LevelExplainer(),
    ),
  );
}
