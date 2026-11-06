import 'package:flutter/material.dart';
import 'package:migraine_tracker_wear/src/watch_controller.dart';
import 'package:migraine_tracker_wear/src/wear_app.dart';
import 'package:migraine_tracker_wear/src/wear_platform.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = WatchController(
    link: PluginWearLink(),
    store: PrefsWearStore(),
    tile: const ChannelTileUpdater(),
  );
  await controller.start();
  runApp(WearApp(controller: controller));
}
