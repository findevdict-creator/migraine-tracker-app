import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:migraine_tracker/app/router.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/core/widgets/widgets.dart';
import 'package:migraine_tracker/features/routines/domain/routine.dart';
import 'package:migraine_tracker/features/routines/presentation/routine_illustration.dart';
import 'package:migraine_tracker/features/routines/presentation/routine_text.dart';

/// Every routine, each opening its steps.
class RoutinesScreen extends StatelessWidget {
  const RoutinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.routinesTitle)),
      body: ListView(
        key: const ValueKey('routines-list'),
        padding: const EdgeInsets.all(AppThemeTokens.space4),
        children: [
          Text(l10n.routinesIntro, style: context.textStyles.bodyMedium),
          const SizedBox(height: AppThemeTokens.space3),
          for (final routine in Routine.values) ...[
            AppCard(
              key: ValueKey('routine-${routine.code}'),
              onTap: () => context.push(AppRoutes.routine(routine.code)),
              child: Row(
                children: [
                  RoutineIllustration(routine),
                  const SizedBox(width: AppThemeTokens.space3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          routine.title(l10n),
                          style: context.textStyles.titleSmall,
                        ),
                        Text(
                          routine.summary(l10n),
                          style: context.textStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppThemeTokens.space2),
          ],
          const SizedBox(height: AppThemeTokens.space2),
          Text(
            context.l10n.wellnessDisclaimer,
            key: const ValueKey('routines-disclaimer'),
            style: context.textStyles.bodySmall,
          ),
        ],
      ),
    );
  }
}
