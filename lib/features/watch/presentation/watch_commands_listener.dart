import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/features/watch/application/watch_commands.dart';
import 'package:migraine_tracker/features/watch/data/watch_link.dart';

/// Feeds everything the watch sends to the command handler while the app
/// runs.
class WatchCommandsListener extends ConsumerStatefulWidget {
  const WatchCommandsListener({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<WatchCommandsListener> createState() =>
      _WatchCommandsListenerState();
}

class _WatchCommandsListenerState extends ConsumerState<WatchCommandsListener> {
  StreamSubscription<Map<String, dynamic>>? _incoming;

  @override
  void initState() {
    super.initState();
    final handler = ref.read(watchCommandHandlerProvider);
    _incoming = ref
        .read(watchLinkProvider)
        .incoming()
        .listen((payload) => unawaited(handler.handle(payload)));
  }

  @override
  void dispose() {
    unawaited(_incoming?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
