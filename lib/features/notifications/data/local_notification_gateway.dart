import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/generated/app_localizations.dart';
import 'package:migraine_tracker/features/notifications/domain/notification_gateway.dart';
import 'package:migraine_tracker/features/notifications/domain/planned_notification.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Called with every tap or action, in the foreground isolate.
typedef NotificationResponseHandler = Future<void> Function(
  NotificationResponse,
);

/// Phones get the platform plugin; everything else (tests, desktop) the
/// silent gateway.
final notificationGatewayProvider = Provider<NotificationGateway>((ref) {
  if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
    return const NoNotificationGateway();
  }
  return LocalNotificationGateway(
    l10n: lookupAppLocalizations(AppLocales.fallback),
  );
});

/// `flutter_local_notifications` behind [NotificationGateway]. Schedules
/// in the device's zone with inexact alarms (no exact-alarm permission),
/// which is fine for reminders and evening/morning alerts.
class LocalNotificationGateway implements NotificationGateway {
  LocalNotificationGateway({
    required this.l10n,
    FlutterLocalNotificationsPlugin? plugin,
    this.onResponse,
  }) : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final AppLocalizations l10n;
  final FlutterLocalNotificationsPlugin _plugin;

  /// Set by the app before [initialize] so taps and actions reach it.
  NotificationResponseHandler? onResponse;

  bool _ready = false;

  @override
  Future<void> initialize() async {
    if (_ready) return;
    tzdata.initializeTimeZones();
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } on Object catch (error) {
      debugPrint('time zone fell back to UTC: $error');
    }
    await _plugin.initialize(
      settings: InitializationSettings(
        android: const AndroidInitializationSettings(
          AppNotificationChannels.androidIcon,
        ),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          notificationCategories: [
            DarwinNotificationCategory(
              AppNotificationChannels.attackCategory,
              actions: [
                DarwinNotificationAction.plain(
                  AppNotificationChannels.endAttackAction,
                  l10n.notifEndAttackAction,
                ),
              ],
            ),
          ],
        ),
      ),
      onDidReceiveNotificationResponse: (response) {
        final handler = onResponse;
        if (handler != null) unawaited(handler(response));
      },
      onDidReceiveBackgroundNotificationResponse: notificationBackgroundHandler,
    );
    _ready = true;
  }

  @override
  Future<bool> requestPermission() async {
    await initialize();
    if (Platform.isAndroid) {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      return await android?.requestNotificationsPermission() ?? false;
    }
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    return await ios?.requestPermissions(
          alert: true,
          sound: true,
          badge: true,
        ) ??
        false;
  }

  @override
  Future<void> schedule(
    PlannedNotification notification,
    NotificationCopy copy,
  ) async {
    await initialize();
    final channel = notification.type.channel;
    await _plugin.zonedSchedule(
      id: notification.id,
      title: copy.title,
      body: copy.body,
      scheduledDate: tz.TZDateTime.from(notification.at, tz.local),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          channel,
          _channelName(channel),
          channelDescription: _channelDescription(channel),
          importance: Importance.high,
          priority: Priority.high,
          actions: notification.withEndAttackAction
              ? [
                  AndroidNotificationAction(
                    AppNotificationChannels.endAttackAction,
                    l10n.notifEndAttackAction,
                  ),
                ]
              : null,
        ),
        iOS: DarwinNotificationDetails(
          categoryIdentifier: notification.withEndAttackAction
              ? AppNotificationChannels.attackCategory
              : null,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: notification.payload,
    );
  }

  @override
  Future<void> cancelPending() async {
    await initialize();
    await _plugin.cancelAllPendingNotifications();
  }

  String _channelName(String id) => switch (id) {
    AppNotificationChannels.alerts => l10n.notifChannelAlerts,
    AppNotificationChannels.reminders => l10n.notifChannelReminders,
    _ => l10n.notifChannelAttack,
  };

  String _channelDescription(String id) => switch (id) {
    AppNotificationChannels.alerts => l10n.notifChannelAlertsDescription,
    AppNotificationChannels.reminders => l10n.notifChannelRemindersDescription,
    _ => l10n.notifChannelAttackDescription,
  };
}

/// Entry point for actions pressed while the app is not running. It
/// hands the response to the same handler the foreground uses, inside a
/// fresh container (see `notification_actions.dart`).
@pragma('vm:entry-point')
void notificationBackgroundHandler(NotificationResponse response) {
  backgroundNotificationResponse = response;
}

/// The last background response, consumed by the app's action handler
/// on the next start. Kept simple on purpose: the only action is "end
/// attack", which the app also offers on its first screen.
NotificationResponse? backgroundNotificationResponse;
