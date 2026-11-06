import 'dart:ui' show Locale, PlatformDispatcher;

import 'package:flutter/widgets.dart' show basicLocaleListResolution;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/config/app_config.dart';

/// The supported language closest to the phone's, for copy made outside
/// the widget tree: notifications, the home widget, the watch.
Locale deviceAppLocale([List<Locale>? device]) => basicLocaleListResolution(
  device ?? PlatformDispatcher.instance.locales,
  AppLocales.supported,
);

/// [deviceAppLocale], overridable in tests.
final deviceLocaleProvider = Provider<Locale>((ref) => deviceAppLocale());
