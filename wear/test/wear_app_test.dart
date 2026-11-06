import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker_wear/src/watch_controller.dart';
import 'package:migraine_tracker_wear/src/wear_app.dart';
import 'package:migraine_tracker_wear/src/wear_platform.dart';
import 'package:watch_protocol/watch_protocol.dart';

class FakeLink implements WearLink {
  final sent = <List<WatchCommand>>[];
  final phone = StreamController<Map<String, dynamic>>.broadcast();

  @override
  Stream<Map<String, dynamic>> incoming() => phone.stream;

  @override
  Future<void> send(Map<String, Object> wire) async =>
      sent.add(WatchCommand.batchFromJson(WatchWire.unwrap(wire)));
}

class MemoryStore implements WearStore {
  MemoryStore({this.state, this.queue = const CommandQueue()});

  WatchState? state;
  CommandQueue queue;

  @override
  Future<WatchState?> readState() async => state;

  @override
  Future<CommandQueue> readQueue() async => queue;

  @override
  Future<void> writeState(WatchState state) async => this.state = state;

  @override
  Future<void> writeQueue(CommandQueue queue) async => this.queue = queue;
}

class CountingTile implements TileUpdater {
  int updates = 0;

  @override
  Future<void> requestUpdate() async => updates++;
}

void main() {
  final now = DateTime(2026, 11, 6, 9, 30);
  late FakeLink link;
  late MemoryStore store;
  late CountingTile tile;
  late WatchController controller;
  var ids = 0;

  WatchState phoneState({WatchAttack? attack, List<String> acks = const []}) =>
      WatchState(
        sentAt: now.toUtc(),
        level: 'high',
        levelLabel: 'Level: High',
        headline: 'Top factor: Pressure drop',
        pressure: 'Pressure falling 4.3 hPa in 24 h',
        levelColor: 0xFFEF9A9A,
        accentColor: 0xFF5B5BD6,
        attack: attack,
        labels: const {WatchLabels.start: 'Start attack now'},
        acks: acks,
      );

  Future<void> pumpWear(WidgetTester tester, {WatchState? stored}) async {
    ids = 0;
    link = FakeLink();
    store = MemoryStore(state: stored);
    tile = CountingTile();
    controller = WatchController(
      link: link,
      store: store,
      tile: tile,
      clock: () => now,
      newId: () => 'c${ids++}',
    );
    await controller.start();
    await tester.pumpWidget(WearApp(controller: controller));
  }

  /// Disposes the controller before the pending-timer check runs.
  void testWear(String name, Future<void> Function(WidgetTester) body) =>
      testWidgets(name, (tester) async {
        await body(tester);
        await tester.pumpWidget(const SizedBox());
        controller.dispose();
      });

  Future<void> tapKey(WidgetTester tester, String key) async {
    await tester.ensureVisible(find.byKey(ValueKey(key)));
    await tester.tap(find.byKey(ValueKey(key)));
    await tester.pumpAndSettle();
  }

  testWear('before the phone has sent anything: a note and a start '
      'button with the fallback label', (tester) async {
    await pumpWear(tester);
    expect(find.byKey(const ValueKey('wear-no-phone')), findsOneWidget);
    expect(find.text('Start attack'), findsOneWidget);
  });

  testWear('shows the level from the phone and updates the tile', (
    tester,
  ) async {
    await pumpWear(tester);
    await controller.receive(WatchWire.wrap(phoneState().toJson()));
    await tester.pumpAndSettle();
    expect(find.text('Level: High'), findsOneWidget);
    expect(find.text('Pressure falling 4.3 hPa in 24 h'), findsOneWidget);
    expect(find.text('Start attack now'), findsOneWidget);
    expect(store.state!.levelLabel, 'Level: High');
    expect(tile.updates, 1);
  });

  testWear('start, intensity and end work offline and are sent until '
      'the phone acknowledges them', (tester) async {
    await pumpWear(tester, stored: phoneState());

    await tapKey(tester, 'wear-start');
    expect(find.byKey(const ValueKey('wear-since')), findsOneWidget);
    expect(find.text('Since 9:30 AM'), findsOneWidget);
    expect(find.byKey(const ValueKey('wear-pending')), findsOneWidget);
    expect(link.sent.last.map((c) => c.type), [WatchCommandType.start]);

    await tapKey(tester, 'wear-intensity-up');
    await tapKey(tester, 'wear-intensity-up');
    expect(find.text('2'), findsOneWidget);
    await tapKey(tester, 'wear-intensity-down');
    expect(find.text('1'), findsOneWidget);
    // Every send carries the whole unacknowledged queue.
    expect(link.sent.last.map((c) => c.id), ['c0', 'c1', 'c2', 'c3']);
    expect(store.queue.pending, hasLength(4));

    // The phone applied the first two and reports the attack.
    await controller.receive(
      WatchWire.wrap(
        phoneState(
          attack: WatchAttack(startedAt: now, intensity: 1),
          acks: const ['c0', 'c1'],
        ).toJson(),
      ),
    );
    await tester.pumpAndSettle();
    expect(store.queue.pending.map((c) => c.id), ['c2', 'c3']);

    await tapKey(tester, 'wear-stop');
    expect(find.byKey(const ValueKey('wear-start')), findsOneWidget);
    expect(link.sent.last.last.type, WatchCommandType.stop);

    await controller.receive(
      WatchWire.wrap(phoneState(acks: const ['c2', 'c3', 'c4']).toJson()),
    );
    await tester.pumpAndSettle();
    expect(store.queue.isEmpty, isTrue);
    expect(find.byKey(const ValueKey('wear-pending')), findsNothing);
  });

  testWear('commands left from last time are resent on start', (tester) async {
    ids = 0;
    link = FakeLink();
    store = MemoryStore(
      queue: const CommandQueue().add(
        WatchCommand(id: 'old', type: WatchCommandType.start, at: now),
      ),
    );
    controller = WatchController(
      link: link,
      store: store,
      tile: CountingTile(),
      clock: () => now,
    );
    await controller.start();
    expect(link.sent.single.single.id, 'old');
  });

  testWear('a late, older state and foreign payloads are ignored', (
    tester,
  ) async {
    await pumpWear(tester, stored: phoneState());
    await controller.receive({'other': 'x'});
    await controller.receive(
      WatchWire.wrap(
        WatchState(
          sentAt: now.toUtc().subtract(const Duration(hours: 1)),
          levelLabel: 'Level: Low',
        ).toJson(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Level: High'), findsOneWidget);
  });

  testWear('phone states arriving on the link are applied', (tester) async {
    await pumpWear(tester);
    link.phone.add(WatchWire.wrap(phoneState().toJson()));
    await tester.pumpAndSettle();
    expect(find.text('Level: High'), findsOneWidget);
  });
}
