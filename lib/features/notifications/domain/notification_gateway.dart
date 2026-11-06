import 'package:migraine_tracker/features/notifications/domain/planned_notification.dart';

/// Rendered copy for one notification.
class NotificationCopy {
  const NotificationCopy({required this.title, required this.body});

  final String title;
  final String body;
}

/// The OS notification layer. One implementation talks to the platform,
/// one records calls for tests.
abstract interface class NotificationGateway {
  /// Prepares the platform (channels, categories, time zone). Idempotent.
  Future<void> initialize();

  /// Asks the OS for permission; true when granted (or already granted).
  Future<bool> requestPermission();

  Future<void> schedule(
    PlannedNotification notification,
    NotificationCopy copy,
  );

  /// Drops every pending (not yet delivered) notification.
  Future<void> cancelPending();
}

/// Does nothing. Used on platforms without notifications and in tests
/// that do not care.
class NoNotificationGateway implements NotificationGateway {
  const NoNotificationGateway();

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> requestPermission() async => false;

  @override
  Future<void> schedule(
    PlannedNotification notification,
    NotificationCopy copy,
  ) async {}

  @override
  Future<void> cancelPending() async {}
}
