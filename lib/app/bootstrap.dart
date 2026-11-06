import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/app/app.dart';
import 'package:migraine_tracker/config/app_config.dart';

/// Provides the resolved [AppConfig] to the whole widget tree.
///
/// Overridden in [bootstrap] with the flavor chosen by the entry point, and
/// in tests with whatever flavor the test needs.
final appConfigProvider = Provider<AppConfig>(
  (_) => throw UnimplementedError('appConfigProvider must be overridden'),
);

/// Starts the app for one flavor. Every `main_*.dart` calls this.
Future<void> bootstrap(AppFlavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = AppConfig(flavor: flavor);
  runApp(
    ProviderScope(
      overrides: [appConfigProvider.overrideWithValue(config)],
      child: const MigraineTrackerApp(),
    ),
  );
}
