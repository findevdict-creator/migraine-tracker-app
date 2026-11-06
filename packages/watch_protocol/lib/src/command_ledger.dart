import 'package:meta/meta.dart';

/// The ids of commands the phone already applied, newest last. A watch
/// resends its whole queue until it sees an id here, so this is what makes
/// each command apply once.
@immutable
class CommandLedger {
  /// Creates a ledger from [ids], oldest first.
  const CommandLedger([this.ids = const []]);

  /// Ids kept. Comfortably more than a watch queue holds.
  static const int maxLength = 400;

  /// How many of the newest ids go back to the watch with each state.
  static const int ackWindow = 200;

  /// Applied ids, oldest first.
  final List<String> ids;

  /// Whether [id] was applied.
  bool contains(String id) => ids.contains(id);

  /// Records [newIds] as applied.
  CommandLedger record(Iterable<String> newIds) {
    final next = [...ids, ...newIds.where((id) => !ids.contains(id))];
    return CommandLedger(
      next.length > maxLength ? next.sublist(next.length - maxLength) : next,
    );
  }

  /// The ids to acknowledge to the watch.
  List<String> get acks =>
      ids.length > ackWindow ? ids.sublist(ids.length - ackWindow) : ids;
}
