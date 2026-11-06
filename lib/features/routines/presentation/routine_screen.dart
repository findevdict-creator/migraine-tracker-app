import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/features/routines/domain/routine.dart';
import 'package:migraine_tracker/features/routines/presentation/breathing_pacer.dart';
import 'package:migraine_tracker/features/routines/presentation/routine_illustration.dart';
import 'package:migraine_tracker/features/routines/presentation/routine_text.dart';

/// One routine: artwork, summary, numbered steps, and the breathing pacer
/// for paced breathing.
class RoutineScreen extends StatelessWidget {
  const RoutineScreen({required this.code, super.key});

  final String code;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final routine = Routine.fromCode(code) ?? Routine.breathing;
    final steps = routine.steps(l10n);
    final locale = Localizations.localeOf(context).toString();
    return Scaffold(
      appBar: AppBar(title: Text(routine.title(l10n))),
      body: ListView(
        key: const ValueKey('routine-detail'),
        padding: const EdgeInsets.all(AppThemeTokens.space4),
        children: [
          Center(child: RoutineIllustration(routine, size: 120)),
          const SizedBox(height: AppThemeTokens.space4),
          Text(routine.summary(l10n), style: context.textStyles.bodyLarge),
          if (routine == Routine.breathing) ...[
            const SizedBox(height: AppThemeTokens.space4),
            const BreathingPacer(),
          ],
          const SizedBox(height: AppThemeTokens.space4),
          Text(l10n.routineStepsTitle, style: context.textStyles.titleMedium),
          const SizedBox(height: AppThemeTokens.space2),
          for (final (i, step) in steps.indexed)
            ListTile(
              key: ValueKey('routine-step-$i'),
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                radius: 14,
                child: Text(NumberFormat.decimalPattern(locale).format(i + 1)),
              ),
              title: Text(step),
            ),
          const SizedBox(height: AppThemeTokens.space3),
          Text(
            AppIdentity.wellnessDisclaimer,
            key: const ValueKey('routine-disclaimer'),
            style: context.textStyles.bodySmall,
          ),
        ],
      ),
    );
  }
}
