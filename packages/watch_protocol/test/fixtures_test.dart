import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:watch_protocol/watch_protocol.dart';

/// The fixtures are the contract with the Swift watch app, whose tests in
/// `ios/RiskWatch/WatchProtocolKit` decode the same files. A change here
/// that breaks them breaks the Apple Watch.
void main() {
  Map<String, Object?> fixture(String name) =>
      jsonDecode(File('test/fixtures/$name').readAsStringSync())
          as Map<String, Object?>;

  test('state fixture decodes and re-encodes to the same JSON', () {
    final json = fixture('state.json');
    final wire = {WatchWire.payloadKey: jsonEncode(json)};
    final state = WatchState.fromJson(WatchWire.unwrap(wire))!;
    expect(state.levelColor, 0xFFEF9A9A);
    expect(state.attack!.intensity, 6);
    expect(state.labels.keys, unorderedEquals(WatchLabels.keys));
    expect({'v': WatchWire.version, ...state.toJson()}, json);
  });

  test('commands fixture decodes and re-encodes to the same JSON', () {
    final json = fixture('commands.json');
    final commands = WatchCommand.batchFromJson(json);
    expect(commands.map((c) => c.type), [
      WatchCommandType.start,
      WatchCommandType.intensity,
      WatchCommandType.stop,
    ]);
    expect({
      'v': WatchWire.version,
      ...WatchCommand.batchToJson(commands),
    }, json);
  });
}
