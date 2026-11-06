import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/features/notifications/application/notification_actions.dart';
import 'package:migraine_tracker/features/notifications/data/local_notification_gateway.dart';

/// Connects notification taps and actions to the app: sets the foreground
/// handler on the platform gateway and replays an action that arrived
/// while the app was closed.
class NotificationResponses extends ConsumerStatefulWidget {
  const NotificationResponses({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<NotificationResponses> createState() =>
      _NotificationResponsesState();
}

class _NotificationResponsesState extends ConsumerState<NotificationResponses> {
  @override
  void initState() {
    super.initState();
    final gateway = ref.read(notificationGatewayProvider);
    if (gateway is LocalNotificationGateway) {
      gateway.onResponse = (response) =>
          NotificationActions.handle(ref.read(_refProvider), response);
    }
    final pending = backgroundNotificationResponse;
    if (pending != null) {
      backgroundNotificationResponse = null;
      unawaited(NotificationActions.handle(ref.read(_refProvider), pending));
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// Hands a long-lived [Ref] to the action handler.
final _refProvider = Provider<Ref>((ref) => ref);
