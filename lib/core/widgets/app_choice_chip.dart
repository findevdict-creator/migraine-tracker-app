import 'package:flutter/material.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';

/// Selectable chip used for symptoms, head locations and options.
///
/// Sized to the tap target of the current theme (56 pt in attack mode) so a
/// chip can be hit one-handed on a dark screen.
class AppChoiceChip extends StatelessWidget {
  const AppChoiceChip({
    required this.label,
    required this.selected,
    required this.onSelected,
    this.icon,
    super.key,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final target = context.isAttackTheme
        ? AppThemeTokens.attackTapTarget
        : AppThemeTokens.minTapTarget;
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: target, minWidth: target),
      child: FilterChip(
        label: Text(label),
        avatar: icon == null ? null : Icon(icon, size: target / 2.5),
        selected: selected,
        onSelected: onSelected,
        showCheckmark: icon == null,
        padding: EdgeInsets.symmetric(
          horizontal: AppThemeTokens.space3,
          vertical: (target - AppThemeTokens.fontLabel * 2) / 2,
        ),
      ),
    );
  }
}
