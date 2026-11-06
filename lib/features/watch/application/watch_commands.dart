import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/attack_log/data/attack_repository_impl.dart';
import 'package:migraine_tracker/features/attack_log/presentation/attack_log_controller.dart';
import 'package:migraine_tracker/features/home_widget/application/home_widget_sync.dart';
import 'package:migraine_tracker/features/watch/application/watch_sync.dart';
import 'package:watch_protocol/watch_protocol.dart';

final watchCommandHandlerProvider = Provider<WatchCommandHandler>(
  WatchCommandHandler.new,
);

/// Applies the watch's start, stop and intensity commands to the attack
/// log, each id once, at the time it was made on the watch, then sends the
/// watch a fresh state that acknowledges them.
class WatchCommandHandler {
  WatchCommandHandler(this._ref);

  final Ref _ref;

  /// Payloads arrive from messages and context updates at once; applying
  /// them one after another keeps the ledger check meaningful.
  Future<void> _queue = Future.value();

  /// Returns the commands applied now; ids seen before are skipped.
  Future<List<WatchCommand>> handle(Map<String, dynamic>? payload) {
    if (!AppFeatureFlags.watchAvailable) return Future.value(const []);
    final commands = WatchCommand.batchFromJson(WatchWire.unwrap(payload));
    if (commands.isEmpty) return Future.value(const []);
    final run = _queue.then((_) => _apply(commands));
    _queue = run.then((_) {}, onError: (_) {});
    return run;
  }

  Future<List<WatchCommand>> _apply(List<WatchCommand> commands) async {
    final store = _ref.read(watchLedgerStoreProvider);
    var ledger = await store.read();
    final applied = <WatchCommand>[];
    for (final command in commands) {
      if (ledger.contains(command.id)) continue;
      try {
        await _applyOne(command);
      } on Object catch (error) {
        // Recorded anyway: a command that cannot apply would otherwise be
        // resent by the watch forever.
        debugPrint('watch command ${command.id} failed: $error');
      }
      ledger = ledger.record([command.id]);
      applied.add(command);
    }
    if (applied.isEmpty) return applied;
    await store.write(ledger);
    await _ref.read(homeWidgetSyncProvider).publishQuietly();
    return applied;
  }

  Future<void> _applyOne(WatchCommand command) async {
    final now = _ref.read(clockProvider)();
    // A watch clock ahead of the phone never stamps the future.
    final at = command.at.isAfter(now) ? now : command.at.toLocal();
    switch (command.type) {
      case WatchCommandType.start:
        await _ref.read(attackStarterProvider).start(at: at);
      case WatchCommandType.stop:
        final editor = await _runningEditor();
        await editor?.end(at: at);
      case WatchCommandType.intensity:
        final editor = await _runningEditor();
        await editor?.setIntensity(command.intensity!);
    }
  }

  Future<AttackEditor?> _runningEditor() async {
    final running = await _ref.read(attackRepositoryProvider).running();
    if (running == null) return null;
    final provider = attackEditorProvider(running.id);
    await _ref.read(provider.future);
    final editor = _ref.read(provider.notifier);
    return editor;
  }
}
