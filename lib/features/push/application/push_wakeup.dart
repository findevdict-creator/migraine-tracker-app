import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/app/bootstrap.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/firebase/firebase_bootstrap.dart';
import 'package:migraine_tracker/features/notifications/application/notification_scheduler.dart';
import 'package:migraine_tracker/features/risk/application/risk_engine.dart';
import 'package:migraine_tracker/features/weather/application/weather_sync.dart';

/// What a wake-up does, in the foreground or the background: refresh the
/// forecast for the current cell, score the days ahead, re-plan the local
/// alerts. Every step is tolerant of failure so a dead network still
/// leaves the stored plan in place.
abstract final class PushWakeup {
  /// True when the message is the wake-up the function sends.
  static bool isWakeup(Map<String, Object?> data) =>
      data['type'] == AppBackgroundTasks.pushWakeupType;

  static Future<WakeupOutcome> run(Ref ref) async {
    final weather = await ref.read(weatherSyncProvider).refresh(force: true);
    var scored = 0;
    try {
      scored = (await ref.read(riskEngineProvider).scoreUpcoming()).length;
    } on Object catch (error) {
      debugPrint('wake-up scoring failed: $error');
    }
    var planned = 0;
    try {
      planned =
          (await ref.read(notificationSchedulerProvider).reschedule()).length;
    } on Object catch (error) {
      debugPrint('wake-up reschedule failed: $error');
    }
    return WakeupOutcome(
      fetched: weather.fetched,
      scoredDays: scored,
      plannedNotifications: planned,
    );
  }
}

@immutable
class WakeupOutcome {
  const WakeupOutcome({
    required this.fetched,
    required this.scoredDays,
    required this.plannedNotifications,
  });

  final bool fetched;
  final int scoredDays;
  final int plannedNotifications;
}

/// Entry point for a silent push while the app is closed or in the
/// background. Runs in its own isolate, so it builds a container the way
/// the weather background task does; the flavor comes from the env file.
@pragma('vm:entry-point')
Future<void> pushWakeupBackgroundHandler(RemoteMessage message) async {
  if (!PushWakeup.isWakeup(message.data)) return;
  WidgetsFlutterBinding.ensureInitialized();
  final config = AppConfig(flavor: AppFlavor.fromEnvironment());
  final firebase = await initializeFirebase(config);
  final container = ProviderContainer(
    overrides: [
      appConfigProvider.overrideWithValue(config),
      firebaseStatusProvider.overrideWithValue(firebase),
    ],
  );
  try {
    await PushWakeup.run(container.read(_refProvider));
  } finally {
    container.dispose();
  }
}

final _refProvider = Provider<Ref>((ref) => ref);
