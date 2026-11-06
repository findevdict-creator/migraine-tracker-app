import 'package:migraine_tracker/features/notifications/domain/notification_gateway.dart';
import 'package:migraine_tracker/features/notifications/domain/planned_notification.dart';

/// Records every call so tests can assert on the plan handed to the OS.
class RecordingGateway implements NotificationGateway {
  RecordingGateway({this.granted = true});

  final bool granted;
  final List<(PlannedNotification, NotificationCopy)> scheduled = [];
  int cancels = 0;
  int permissionRequests = 0;
  bool initialized = false;

  List<String> get keys => [for (final s in scheduled) s.$1.key];

  @override
  Future<void> initialize() async => initialized = true;

  @override
  Future<bool> requestPermission() async {
    permissionRequests++;
    return granted;
  }

  @override
  Future<void> schedule(
    PlannedNotification notification,
    NotificationCopy copy,
  ) async => scheduled.add((notification, copy));

  @override
  Future<void> cancelPending() async {
    cancels++;
    scheduled.clear();
  }
}
