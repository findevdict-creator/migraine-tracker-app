import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/config/app_config.dart';

/// User preference for reduced motion, in addition to the OS setting. Set
/// from the settings screen; defaults to following the OS.
final reduceMotionPreferenceProvider =
    NotifierProvider<ReduceMotionPreference, bool>(ReduceMotionPreference.new);

class ReduceMotionPreference extends Notifier<bool> {
  @override
  bool build() => false;

  // ignore: avoid_setters_without_getters, the notifier state is the getter.
  set enabled(bool value) => state = value;
}

/// Animation helpers that honour reduce-motion (OS flag or app preference).
abstract final class AppMotion {
  /// True when animations should be skipped or reduced to fades.
  static bool reduced(BuildContext context, {bool preference = false}) =>
      preference || MediaQuery.disableAnimationsOf(context);

  static Duration short(BuildContext context, {bool preference = false}) =>
      reduced(context, preference: preference)
      ? Duration.zero
      : AppThemeTokens.animationShort;

  static Duration medium(BuildContext context, {bool preference = false}) =>
      reduced(context, preference: preference)
      ? Duration.zero
      : AppThemeTokens.animationMedium;
}
