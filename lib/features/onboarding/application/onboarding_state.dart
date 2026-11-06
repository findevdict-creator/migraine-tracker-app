import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/core/settings/settings_keys.dart';
import 'package:migraine_tracker/core/settings/settings_repository.dart';

/// Whether the first-run flow has been completed: null while the flag is
/// being read, then true or false. The router redirects on false.
final onboardingStateProvider = NotifierProvider<OnboardingState, bool?>(
  OnboardingState.new,
);

class OnboardingState extends Notifier<bool?> {
  @override
  bool? build() {
    unawaited(_load());
    return null;
  }

  Future<void> _load() async {
    final done = await ref
        .read(settingsRepositoryProvider)
        .read<bool>(SettingsKeys.onboardingCompleted);
    if (state == null) state = done ?? false;
  }

  /// Marks the flow done. Called at the end of the flow and by "skip".
  Future<void> complete() async {
    await ref
        .read(settingsRepositoryProvider)
        .write(SettingsKeys.onboardingCompleted, true);
    state = true;
  }
}

/// Bridges the provider to GoRouter's `refreshListenable`.
class OnboardingListenable extends ChangeNotifier {
  OnboardingListenable(Ref ref) {
    ref.listen<bool?>(onboardingStateProvider, (_, _) => notifyListeners());
  }
}
