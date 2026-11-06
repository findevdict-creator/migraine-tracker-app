import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/app/bootstrap.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/firebase/firebase_bootstrap.dart';
import 'package:migraine_tracker/features/weather/application/weather_sync.dart';
import 'package:workmanager/workmanager.dart';

/// Schedules the daily background weather refresh. Android uses
/// WorkManager; iOS uses BGTaskScheduler with the identifier also listed
/// in Info.plist and registered in AppDelegate.
Future<void> scheduleWeatherBackgroundRefresh(AppFlavor flavor) async {
  await Workmanager().initialize(weatherBackgroundDispatcher);
  await Workmanager().registerPeriodicTask(
    AppBackgroundTasks.weatherRefresh,
    AppBackgroundTasks.weatherRefresh,
    frequency: AppThresholds.weatherBackgroundRefresh,
    inputData: {'flavor': flavor.name},
    existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
    constraints: Constraints(networkType: NetworkType.connected),
  );
}

/// Entry point for the background isolate. Builds a container the same way
/// `bootstrap` does (config from the flavor saved by the entry point), then
/// runs one refresh. Returning true tells the OS the job succeeded.
@pragma('vm:entry-point')
void weatherBackgroundDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();
    final flavorName = inputData?['flavor'] as String? ?? AppFlavor.prod.name;
    final flavor = AppFlavor.values.firstWhere(
      (f) => f.name == flavorName,
      orElse: () => AppFlavor.prod,
    );
    final config = AppConfig(flavor: flavor);
    final firebase = await initializeFirebase(config);
    final container = ProviderContainer(
      overrides: [
        appConfigProvider.overrideWithValue(config),
        firebaseStatusProvider.overrideWithValue(firebase),
      ],
    );
    try {
      final result = await container.read(weatherSyncProvider).refresh();
      return result.error == null;
    } finally {
      container.dispose();
    }
  });
}
