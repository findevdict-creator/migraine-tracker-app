import 'package:flutter/material.dart';
import 'package:migraine_tracker/config/app_config.dart';

/// Semantic colours that Material's [ColorScheme] does not carry.
///
/// Read with `Theme.of(context).extension<AppColors>()!` or the
/// `context.appColors` shortcut. Values come from [AppThemeTokens].
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.riskLow,
    required this.riskModerate,
    required this.riskHigh,
    required this.onRisk,
    required this.success,
    required this.warning,
    required this.danger,
    required this.info,
    required this.attackAccent,
    required this.attackMuted,
  });

  const AppColors.light()
    : this(
        riskLow: AppThemeTokens.riskLow,
        riskModerate: AppThemeTokens.riskModerate,
        riskHigh: AppThemeTokens.riskHigh,
        onRisk: Colors.white,
        success: AppThemeTokens.success,
        warning: AppThemeTokens.warning,
        danger: AppThemeTokens.danger,
        info: AppThemeTokens.info,
        attackAccent: AppThemeTokens.attackAccent,
        attackMuted: AppThemeTokens.attackMuted,
      );

  const AppColors.dark()
    : this(
        riskLow: AppThemeTokens.riskLowDark,
        riskModerate: AppThemeTokens.riskModerateDark,
        riskHigh: AppThemeTokens.riskHighDark,
        onRisk: Colors.black,
        success: AppThemeTokens.riskLowDark,
        warning: AppThemeTokens.riskModerateDark,
        danger: AppThemeTokens.riskHighDark,
        info: AppThemeTokens.infoDark,
        attackAccent: AppThemeTokens.attackAccent,
        attackMuted: AppThemeTokens.attackMuted,
      );

  final Color riskLow;
  final Color riskModerate;
  final Color riskHigh;
  final Color onRisk;
  final Color success;
  final Color warning;
  final Color danger;
  final Color info;
  final Color attackAccent;
  final Color attackMuted;

  @override
  AppColors copyWith({
    Color? riskLow,
    Color? riskModerate,
    Color? riskHigh,
    Color? onRisk,
    Color? success,
    Color? warning,
    Color? danger,
    Color? info,
    Color? attackAccent,
    Color? attackMuted,
  }) => AppColors(
    riskLow: riskLow ?? this.riskLow,
    riskModerate: riskModerate ?? this.riskModerate,
    riskHigh: riskHigh ?? this.riskHigh,
    onRisk: onRisk ?? this.onRisk,
    success: success ?? this.success,
    warning: warning ?? this.warning,
    danger: danger ?? this.danger,
    info: info ?? this.info,
    attackAccent: attackAccent ?? this.attackAccent,
    attackMuted: attackMuted ?? this.attackMuted,
  );

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      riskLow: Color.lerp(riskLow, other.riskLow, t)!,
      riskModerate: Color.lerp(riskModerate, other.riskModerate, t)!,
      riskHigh: Color.lerp(riskHigh, other.riskHigh, t)!,
      onRisk: Color.lerp(onRisk, other.onRisk, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      info: Color.lerp(info, other.info, t)!,
      attackAccent: Color.lerp(attackAccent, other.attackAccent, t)!,
      attackMuted: Color.lerp(attackMuted, other.attackMuted, t)!,
    );
  }
}

/// Shortcuts for theme access in widgets.
extension AppThemeX on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textStyles => Theme.of(this).textTheme;
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;

  /// True when the current theme is the attack theme.
  bool get isAttackTheme =>
      Theme.of(this).extension<AttackThemeMarker>() != null;
}

/// Marker extension present only on the attack theme, so widgets can pick
/// the larger tap targets without a flag being threaded through.
@immutable
class AttackThemeMarker extends ThemeExtension<AttackThemeMarker> {
  const AttackThemeMarker();

  @override
  AttackThemeMarker copyWith() => this;

  @override
  AttackThemeMarker lerp(AttackThemeMarker? other, double t) => this;
}
