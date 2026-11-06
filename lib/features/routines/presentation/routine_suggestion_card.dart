import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:migraine_tracker/app/router.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/core/widgets/widgets.dart';
import 'package:migraine_tracker/features/routines/application/routine_suggestions.dart';
import 'package:migraine_tracker/features/routines/presentation/routine_illustration.dart';
import 'package:migraine_tracker/features/routines/presentation/routine_text.dart';

/// Home card with today's routine suggestions; hidden when there are none.
class RoutineSuggestionCard extends ConsumerWidget {
  const RoutineSuggestionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestions = ref.watch(routineSuggestionsProvider);
    if (suggestions.isEmpty) return const SizedBox.shrink();
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppThemeTokens.space4),
      child: AppCard(
        key: const ValueKey('routine-card'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.routineCardTitle, style: context.textStyles.titleMedium),
            const SizedBox(height: AppThemeTokens.space2),
            for (final s in suggestions)
              ListTile(
                key: ValueKey('routine-suggestion-${s.routine.code}'),
                contentPadding: EdgeInsets.zero,
                leading: RoutineIllustration(s.routine, size: 40),
                title: Text(s.routine.title(l10n)),
                subtitle: Text(s.reason.label(l10n)),
                onTap: () => context.push(AppRoutes.routine(s.routine.code)),
              ),
            Wrap(
              spacing: AppThemeTokens.space2,
              children: [
                TextButton(
                  key: const ValueKey('routine-not-today'),
                  onPressed: () => unawaited(
                    ref
                        .read(routineDismisserProvider)
                        .dismiss(suggestions.map((s) => s.routine)),
                  ),
                  child: Text(l10n.routineNotToday),
                ),
                TextButton(
                  key: const ValueKey('routine-see-all'),
                  onPressed: () => context.push(AppRoutes.routines),
                  child: Text(l10n.routineSeeAll),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
