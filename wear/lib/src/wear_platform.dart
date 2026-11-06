import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_connectivity/watch_connectivity.dart';
import 'package:watch_protocol/watch_protocol.dart';

/// The watch's side of the data layer.
abstract interface class WearLink {
  /// The phone's payloads: the last state it left, then live updates.
  Stream<Map<String, dynamic>> incoming();

  /// Sends [wire] to the phone, as a message for a running phone app and as
  /// the watch's context so a closed phone app finds it on open.
  Future<void> send(Map<String, Object> wire);
}

class PluginWearLink implements WearLink {
  PluginWearLink([WatchConnectivity? plugin])
    : _plugin = plugin ?? WatchConnectivity();

  final WatchConnectivity _plugin;

  @override
  Stream<Map<String, dynamic>> incoming() async* {
    try {
      yield* Stream.fromIterable(await _plugin.receivedApplicationContexts);
    } on Object catch (e) {
      debugPrint('wear: $e');
    }
    final live = StreamGroup2.merge([
      _plugin.contextStream,
      _plugin.messageStream,
    ]);
    yield* live.handleError((Object e) => debugPrint('wear: $e'));
  }

  @override
  Future<void> send(Map<String, Object> wire) async {
    try {
      await _plugin.updateApplicationContext(wire);
      await _plugin.sendMessage(wire);
    } on Object catch (e) {
      // Not reachable: the queue keeps the commands for the next try.
      debugPrint('wear: $e');
    }
  }
}

/// Merges broadcast streams without another dependency.
abstract final class StreamGroup2 {
  static Stream<T> merge<T>(List<Stream<T>> streams) {
    final out = StreamController<T>();
    final subs = <StreamSubscription<T>>[];
    out
      ..onListen = () {
        for (final s in streams) {
          subs.add(s.listen(out.add, onError: out.addError));
        }
      }
      ..onCancel = () async {
        for (final s in subs) {
          await s.cancel();
        }
      };
    return out.stream;
  }
}

/// The watch's own storage: the last phone state, the unsent commands and
/// the strings the tile shows.
abstract interface class WearStore {
  Future<WatchState?> readState();
  Future<CommandQueue> readQueue();
  Future<void> writeState(WatchState state);
  Future<void> writeQueue(CommandQueue queue);
}

class PrefsWearStore implements WearStore {
  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  @override
  Future<WatchState?> readState() async {
    final raw = (await _prefs).getString(WatchConfig.storedState);
    if (raw == null) return null;
    try {
      return WatchState.fromJson(jsonDecode(raw) as Map<String, Object?>);
    } on Object {
      return null;
    }
  }

  @override
  Future<CommandQueue> readQueue() async {
    final raw = (await _prefs).getString(WatchConfig.storedQueue);
    if (raw == null) return const CommandQueue();
    try {
      return CommandQueue.fromJson(jsonDecode(raw));
    } on Object {
      return const CommandQueue();
    }
  }

  @override
  Future<void> writeState(WatchState state) async {
    final prefs = await _prefs;
    await prefs.setString(WatchConfig.storedState, jsonEncode(state.toJson()));
    // The tile reads these keys natively (RiskTileService.kt).
    await prefs.setString(WatchConfig.tileLevelLabel, state.levelLabel);
    await prefs.setString(WatchConfig.tileHeadline, state.headline);
    await prefs.setString(WatchConfig.tilePressure, state.pressure);
    await prefs.setString(
      WatchConfig.tileLevelColor,
      state.levelColor?.toString() ?? '',
    );
  }

  @override
  Future<void> writeQueue(CommandQueue queue) async {
    await (await _prefs).setString(
      WatchConfig.storedQueue,
      jsonEncode(queue.toJson()),
    );
  }
}

/// Asks the tile to redraw from the stored strings.
abstract interface class TileUpdater {
  Future<void> requestUpdate();
}

class ChannelTileUpdater implements TileUpdater {
  const ChannelTileUpdater();

  static const _channel = MethodChannel(WatchConfig.tileChannel);

  @override
  Future<void> requestUpdate() async {
    try {
      await _channel.invokeMethod<void>('update');
    } on Object catch (e) {
      debugPrint('tile: $e');
    }
  }
}
