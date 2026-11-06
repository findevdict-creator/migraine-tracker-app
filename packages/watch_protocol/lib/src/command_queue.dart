import 'package:meta/meta.dart';
import 'package:watch_protocol/src/watch_command.dart';

/// The watch's commands that the phone has not acknowledged yet, oldest
/// first. Immutable: every change returns a new queue.
@immutable
class CommandQueue {
  /// Creates a queue from [pending], oldest first.
  const CommandQueue([this.pending = const []]);

  /// Reads the storage form; malformed entries are dropped.
  factory CommandQueue.fromJson(Object? json) => CommandQueue(
    json is List ? [for (final e in json) ?WatchCommand.fromJson(e)] : const [],
  );

  /// Most commands kept. The oldest are dropped past this, which only
  /// happens after weeks away from the phone.
  static const int maxLength = 200;

  /// Unacknowledged commands, oldest first.
  final List<WatchCommand> pending;

  /// Whether nothing is waiting.
  bool get isEmpty => pending.isEmpty;

  /// Appends [command].
  CommandQueue add(WatchCommand command) {
    final next = [...pending, command];
    return CommandQueue(
      next.length > maxLength ? next.sublist(next.length - maxLength) : next,
    );
  }

  /// Drops every command whose id is in [acks].
  CommandQueue acknowledge(Iterable<String> acks) {
    final done = acks.toSet();
    if (!pending.any((c) => done.contains(c.id))) return this;
    return CommandQueue(pending.where((c) => !done.contains(c.id)).toList());
  }

  /// Storage form.
  List<Map<String, Object?>> toJson() => [for (final c in pending) c.toJson()];
}
