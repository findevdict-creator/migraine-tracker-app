import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:migraine_tracker/app/router.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/core/widgets/widgets.dart';
import 'package:migraine_tracker/features/checkin/presentation/checkin_controller.dart';

/// Home card: today's check-in status, tap to open it.
class CheckinCard extends ConsumerWidget {
  const CheckinCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final today = ref.watch(todayKeyProvider);
    final checkin = ref.watch(todayCheckinProvider).value;
    final done = checkin?.isComplete ?? false;
    return AppCard(
      key: const ValueKey('checkin-card'),
      onTap: () => context.push(AppRoutes.checkin(today)),
      child: Row(
        children: [
          Icon(
            done ? Icons.check_circle : Icons.radio_button_unchecked,
            color: done
                ? context.appColors.success
                : context.theme.colorScheme.primary,
          ),
          const SizedBox(width: AppThemeTokens.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.checkinCardTitle,
                  style: context.textStyles.titleMedium,
                ),
                Text(
                  done ? l10n.checkinCardDone : l10n.checkinCardTodo,
                  style: context.textStyles.bodyMedium,
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}
