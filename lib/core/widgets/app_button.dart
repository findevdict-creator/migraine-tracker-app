import 'package:flutter/material.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';

enum AppButtonVariant { primary, secondary, text }

/// The app's button. Primary is filled, secondary outlined, text plain.
///
/// Honours the 48 dp minimum tap target, and 56 pt inside the attack theme.
/// Pass [large] to force the attack size anywhere (for example the home
/// screen's start-attack button).
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.large = false,
    this.expand = false,
    this.semanticLabel,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool large;
  final bool expand;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final target = large || context.isAttackTheme
        ? AppThemeTokens.attackTapTarget
        : AppThemeTokens.minTapTarget;
    final style = ButtonStyle(
      minimumSize: WidgetStatePropertyAll(Size(target, target)),
    );
    final child = icon == null
        ? Text(label)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: target / 2.5),
              const SizedBox(width: AppThemeTokens.space2),
              Flexible(child: Text(label)),
            ],
          );
    final button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
        onPressed: onPressed,
        style: style,
        child: child,
      ),
      AppButtonVariant.secondary => OutlinedButton(
        onPressed: onPressed,
        style: style,
        child: child,
      ),
      AppButtonVariant.text => TextButton(
        onPressed: onPressed,
        style: style,
        child: child,
      ),
    };
    return Semantics(
      label: semanticLabel,
      button: true,
      child: expand ? SizedBox(width: double.infinity, child: button) : button,
    );
  }
}
