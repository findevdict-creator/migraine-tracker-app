import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:migraine_tracker/app/router.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/widgets/widgets.dart';
import 'package:migraine_tracker/features/attack_log/presentation/attack_log_controller.dart';

/// The one-tap start button for the home screen. Shows "continue" instead
/// when an attack is already running.
class StartAttackButton extends ConsumerWidget {
  const StartAttackButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final running = ref.watch(runningAttackProvider).value;
    Future<void> open() async {
      final id = await ref.read(attackStarterProvider).start();
      if (context.mounted) await context.push(AppRoutes.attack(id));
    }

    return AppButton(
      key: const ValueKey('start-attack'),
      label: running == null ? l10n.attackStart : l10n.attackContinue,
      icon: running == null ? Icons.bolt : Icons.play_arrow,
      large: true,
      expand: true,
      onPressed: open,
    );
  }
}
