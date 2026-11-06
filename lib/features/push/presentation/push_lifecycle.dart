import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/features/push/application/push_registration.dart';

/// Starts push registration with the app and stops it with the app.
class PushWakeups extends ConsumerStatefulWidget {
  const PushWakeups({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<PushWakeups> createState() => _PushWakeupsState();
}

class _PushWakeupsState extends ConsumerState<PushWakeups> {
  PushSubscriptions? _subscriptions;

  @override
  void initState() {
    super.initState();
    _subscriptions = ref.read(pushRegistrarProvider).start();
  }

  @override
  void dispose() {
    unawaited(_subscriptions?.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
