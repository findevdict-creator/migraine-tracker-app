import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:migraine_tracker/config/app_config.dart';

/// Writes the widget strings and asks the OS to redraw; reports widget
/// launches back to the app.
abstract interface class HomeWidgetGateway {
  Future<void> publish(Map<String, String> data);

  /// The link the app was cold-started from, if a widget started it.
  Future<Uri?> initialLaunch();

  /// Links from widget taps while the app runs.
  Stream<Uri?> get launches;
}

final homeWidgetGatewayProvider = Provider<HomeWidgetGateway>(
  (ref) => !kIsWeb && (Platform.isAndroid || Platform.isIOS)
      ? PluginHomeWidgetGateway()
      : const NoHomeWidgetGateway(),
);

class PluginHomeWidgetGateway implements HomeWidgetGateway {
  bool _groupSet = false;

  @override
  Future<void> publish(Map<String, String> data) async {
    if (Platform.isIOS && !_groupSet) {
      await HomeWidget.setAppGroupId(AppHomeWidgets.iosAppGroup);
      _groupSet = true;
    }
    for (final e in data.entries) {
      await HomeWidget.saveWidgetData<String>(e.key, e.value);
    }
    await HomeWidget.updateWidget(
      androidName: AppHomeWidgets.androidProvider,
      iOSName: AppHomeWidgets.iosKind,
    );
  }

  @override
  Future<Uri?> initialLaunch() => HomeWidget.initiallyLaunchedFromHomeWidget();

  @override
  Stream<Uri?> get launches => HomeWidget.widgetClicked;
}

/// Platforms without home widgets, and tests.
class NoHomeWidgetGateway implements HomeWidgetGateway {
  const NoHomeWidgetGateway();

  @override
  Future<void> publish(Map<String, String> data) async {}

  @override
  Future<Uri?> initialLaunch() async => null;

  @override
  Stream<Uri?> get launches => const Stream.empty();
}
