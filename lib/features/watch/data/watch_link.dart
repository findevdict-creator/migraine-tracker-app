import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

/// The phone's connection to a paired watch: Wear OS through the Wearable
/// data layer, Apple Watch through WatchConnectivity.
abstract interface class WatchLink {
  /// Replaces the state the watch reads, delivered even when the watch app
  /// is closed.
  Future<void> pushState(Map<String, Object> wire);

  /// Every payload from the watch: the contexts it left while the phone
  /// app was closed, then live messages and context updates.
  Stream<Map<String, dynamic>> incoming();
}

final watchLinkProvider = Provider<WatchLink>(
  (ref) => !kIsWeb && (Platform.isAndroid || Platform.isIOS)
      ? PluginWatchLink()
      : const NoWatchLink(),
);

class PluginWatchLink implements WatchLink {
  PluginWatchLink([WatchConnectivity? plugin])
    : _plugin = plugin ?? WatchConnectivity();

  final WatchConnectivity _plugin;
  Future<bool>? _supported;

  /// Whether this phone can talk to a watch at all. Checked once; pairing
  /// is checked on every push because a watch can be paired later.
  Future<bool> _isSupported() => _supported ??= () async {
    try {
      return await _plugin.isSupported;
    } on Object {
      return false;
    }
  }();

  Future<bool> _ready() async {
    if (!await _isSupported()) return false;
    try {
      return await _plugin.isPaired;
    } on Object {
      return false;
    }
  }

  @override
  Future<void> pushState(Map<String, Object> wire) async {
    if (!await _ready()) return;
    await _plugin.updateApplicationContext(wire);
  }

  @override
  Stream<Map<String, dynamic>> incoming() {
    final out = StreamController<Map<String, dynamic>>();
    final subs = <StreamSubscription<Map<String, dynamic>>>[];
    void forward(Stream<Map<String, dynamic>> s) => subs.add(
      s.listen(out.add, onError: (Object e) => debugPrint('watch: $e')),
    );
    out
      ..onListen = () async {
        if (!await _isSupported()) return;
        try {
          (await _plugin.receivedApplicationContexts).forEach(out.add);
        } on Object catch (e) {
          debugPrint('watch: $e');
        }
        forward(_plugin.messageStream);
        forward(_plugin.contextStream);
      }
      ..onCancel = () async {
        for (final s in subs) {
          await s.cancel();
        }
      };
    return out.stream;
  }
}

/// Platforms without watches, and tests.
class NoWatchLink implements WatchLink {
  const NoWatchLink();

  @override
  Future<void> pushState(Map<String, Object> wire) async {}

  @override
  Stream<Map<String, dynamic>> incoming() => const Stream.empty();
}
