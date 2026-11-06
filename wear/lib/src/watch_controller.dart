import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:migraine_tracker_wear/src/wear_platform.dart';
import 'package:watch_protocol/watch_protocol.dart';

/// Holds what the watch shows and turns taps into queued commands that are
/// sent to the phone until it acknowledges them.
class WatchController extends ChangeNotifier {
  WatchController({
    required this._link,
    required this._store,
    required this._tile,
    DateTime Function()? clock,
    String Function()? newId,
  }) : _clock = clock ?? DateTime.now,
       _newId = newId ?? _randomId;

  final WearLink _link;
  final WearStore _store;
  final TileUpdater _tile;
  final DateTime Function() _clock;
  final String Function() _newId;

  WatchState? _state;
  CommandQueue _queue = const CommandQueue();
  StreamSubscription<Map<String, dynamic>>? _incoming;
  Timer? _resend;

  WatchView get view => WatchView.of(_state, _queue);

  /// Loads what was stored, listens to the phone and resends anything
  /// still waiting.
  Future<void> start() async {
    _state = await _store.readState();
    _queue = await _store.readQueue();
    notifyListeners();
    _incoming = _link.incoming().listen(
      (payload) => unawaited(receive(payload)),
    );
    _resend = Timer.periodic(WatchConfig.resendEvery, (_) {
      if (!_queue.isEmpty) unawaited(_send());
    });
    if (!_queue.isEmpty) await _send();
  }

  /// Takes a state from the phone; anything else is ignored.
  Future<void> receive(Map<String, dynamic>? payload) async {
    final json = WatchWire.unwrap(payload);
    final state = WatchState.fromJson(json);
    if (state == null) return;
    // An older state arriving late never replaces a newer one.
    final current = _state;
    if (current != null && state.sentAt.isBefore(current.sentAt)) return;
    _state = state;
    _queue = _queue.acknowledge(state.acks);
    notifyListeners();
    await _store.writeState(state);
    await _store.writeQueue(_queue);
    await _tile.requestUpdate();
  }

  Future<void> startAttack() => _add(WatchCommandType.start);

  Future<void> endAttack() => _add(WatchCommandType.stop);

  Future<void> setIntensity(int value) =>
      _add(WatchCommandType.intensity, intensity: value.clamp(0, 10));

  Future<void> _add(WatchCommandType type, {int? intensity}) async {
    _queue = _queue.add(
      WatchCommand(
        id: _newId(),
        type: type,
        at: _clock(),
        intensity: intensity,
      ),
    );
    notifyListeners();
    await _store.writeQueue(_queue);
    await _send();
  }

  Future<void> _send() =>
      _link.send(WatchWire.wrap(WatchCommand.batchToJson(_queue.pending)));

  @override
  void dispose() {
    unawaited(_incoming?.cancel());
    _resend?.cancel();
    super.dispose();
  }

  static final _random = Random.secure();

  static String _randomId() => List.generate(
    16,
    (_) => _random.nextInt(256).toRadixString(16).padLeft(2, '0'),
  ).join();
}
