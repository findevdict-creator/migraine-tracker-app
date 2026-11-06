import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/settings/settings_keys.dart';
import 'package:migraine_tracker/core/settings/settings_repository.dart';

final _reduceMotionSettingProvider = StreamProvider<bool?>(
  (ref) => ref
      .watch(settingsRepositoryProvider)
      .watch<bool>(SettingsKeys.reduceMotion),
);

/// The app's own reduce-motion switch (Settings), on top of the phone's
/// setting. Off until the person turns it on.
final reduceMotionPreferenceProvider = Provider<bool>(
  (ref) => ref.watch(_reduceMotionSettingProvider).value ?? false,
);

/// Saves the reduce-motion switch.
final reduceMotionActionsProvider = Provider<ReduceMotionActions>(
  ReduceMotionActions.new,
);

class ReduceMotionActions {
  ReduceMotionActions(this._ref);

  final Ref _ref;

  Future<void> set({required bool enabled}) => _ref
      .read(settingsRepositoryProvider)
      .write(SettingsKeys.reduceMotion, enabled);
}

/// Animation helpers that honour reduce-motion. The app root folds its own
/// switch into `MediaQuery.disableAnimations`, so below it the OS flag and
/// the app switch read the same.
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

/// Page transitions that cut straight to the new screen under reduce
/// motion and use the platform's usual transition otherwise.
class ReducedMotionPageTransitionsBuilder extends PageTransitionsBuilder {
  const ReducedMotionPageTransitionsBuilder(this.normal);

  final PageTransitionsBuilder normal;

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => MediaQuery.disableAnimationsOf(context)
      ? child
      : normal.buildTransitions(
          route,
          context,
          animation,
          secondaryAnimation,
          child,
        );
}

/// The app's page transitions (predictive back on Android, the iOS slide),
/// each cut to nothing under reduce motion.
const PageTransitionsTheme appPageTransitions = PageTransitionsTheme(
  builders: {
    TargetPlatform.android: ReducedMotionPageTransitionsBuilder(
      PredictiveBackPageTransitionsBuilder(),
    ),
    TargetPlatform.iOS: ReducedMotionPageTransitionsBuilder(
      CupertinoPageTransitionsBuilder(),
    ),
  },
);
