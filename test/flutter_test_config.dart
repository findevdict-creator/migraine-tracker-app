import 'dart:async';

import 'package:alchemist/alchemist.dart';

/// Golden tests use the CI configuration everywhere (Ahem font, no platform
/// rendering differences), so a golden generated on a laptop matches the one
/// CI compares against. Regenerate with `flutter test --update-goldens`.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  return AlchemistConfig.runWithConfig(
    config: const AlchemistConfig(
      platformGoldensConfig: PlatformGoldensConfig(enabled: false),
      ciGoldensConfig: CiGoldensConfig(),
    ),
    run: testMain,
  );
}
