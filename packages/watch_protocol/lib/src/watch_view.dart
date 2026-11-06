import 'package:meta/meta.dart';
import 'package:watch_protocol/src/command_queue.dart';
import 'package:watch_protocol/src/watch_command.dart';
import 'package:watch_protocol/src/watch_labels.dart';
import 'package:watch_protocol/src/watch_state.dart';

/// What the watch screen shows: the phone's last state with the commands
/// still waiting for the phone applied on top, so a tap shows at once even
/// with the phone away.
@immutable
class WatchView {
  /// Creates a view.
  const WatchView({
    required this.labels,
    this.state,
    this.attack,
    this.pendingCount = 0,
  });

  /// Projects [state] and [queue] into a view.
  factory WatchView.of(WatchState? state, CommandQueue queue) {
    final acked = state?.acks.toSet() ?? const <String>{};
    var attack = state?.attack;
    var count = 0;
    for (final c in queue.pending) {
      if (acked.contains(c.id)) continue;
      count++;
      switch (c.type) {
        case WatchCommandType.start:
          attack ??= WatchAttack(startedAt: c.at);
        case WatchCommandType.stop:
          attack = null;
        case WatchCommandType.intensity:
          if (attack != null) {
            attack = WatchAttack(
              startedAt: attack.startedAt,
              intensity: c.intensity,
            );
          }
      }
    }
    return WatchView(
      state: state,
      attack: attack,
      pendingCount: count,
      labels: WatchLabels.resolve(state?.labels),
    );
  }

  /// The phone's last state, null before the first one.
  final WatchState? state;

  /// The attack as the watch should show it, null when none is running.
  final WatchAttack? attack;

  /// Commands still waiting for the phone.
  final int pendingCount;

  /// Labels with fallbacks filled in.
  final Map<String, String> labels;

  /// Whether the phone has ever sent a state.
  bool get hasPhone => state != null;

  /// Whether an attack is running.
  bool get running => attack != null;

  /// The label for [key], see `WatchLabels`.
  String label(String key) => labels[key] ?? WatchLabels.fallback[key] ?? key;
}
