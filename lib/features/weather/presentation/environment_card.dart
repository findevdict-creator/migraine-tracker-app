import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:migraine_tracker/app/router.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/core/widgets/widgets.dart';
import 'package:migraine_tracker/features/weather/presentation/environment_controller.dart';
import 'package:migraine_tracker/features/weather/presentation/weather_text.dart';

/// Home card: current pressure and trend, tap to open the environment
/// screen. Also kicks off the foreground refresh when the home screen
/// is first shown.
class EnvironmentCard extends ConsumerWidget {
  const EnvironmentCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final view = ref.watch(environmentViewProvider).value;
    final current = view?.deltas.current;
    return AppCard(
      key: const ValueKey('environment-card'),
      onTap: () => context.push(AppRoutes.environment),
      child: Row(
        children: [
          Icon(Icons.air, color: context.theme.colorScheme.primary),
          const SizedBox(width: AppThemeTokens.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.environmentCardTitle,
                  style: context.textStyles.titleMedium,
                ),
                Text(
                  current == null
                      ? l10n.environmentCardEmpty
                      : l10n.environmentCardSummary(
                          current.toStringAsFixed(1),
                          trendLabel(l10n, view?.deltas.strongest),
                        ),
                  key: const ValueKey('environment-card-summary'),
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
