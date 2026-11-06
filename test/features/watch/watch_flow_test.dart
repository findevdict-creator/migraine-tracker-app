import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/core/db/app_database.dart' hide RiskDay;
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/attack_log/data/attack_repository_impl.dart';
import 'package:migraine_tracker/features/attack_log/domain/attack_entity.dart';
import 'package:migraine_tracker/features/watch/application/watch_commands.dart';
import 'package:migraine_tracker/features/watch/data/watch_link.dart';
import 'package:migraine_tracker/features/weather/data/weather_sources.dart';
import 'package:watch_protocol/watch_protocol.dart';

import '../../support/pump_app.dart';
import '../../support/test_database.dart';
import '../weather/support/weather_fakes.dart';

/// Records the states the phone sends and plays back watch payloads.
class FakeWatchLink implements WatchLink {
  FakeWatchLink({this.leftWhileClosed = const []});

  final List<Map<String, dynamic>> leftWhileClosed;
  final pushed = <WatchState>[];
  final _live = StreamController<Map<String, dynamic>>.broadcast();

  void send(List<WatchCommand> commands) =>
      _live.add(WatchWire.wrap(WatchCommand.batchToJson(commands)));

  @override
  Future<void> pushState(Map<String, Object> wire) async =>
      pushed.add(WatchState.fromJson(WatchWire.unwrap(wire))!);

  @override
  Stream<Map<String, dynamic>> incoming() async* {
    for (final c in leftWhileClosed) {
      yield c;
    }
    yield* _live.stream;
  }
}

void main() {
  late AppDatabase db;
  var now = DateTime(2026, 11, 6, 9, 30);

  setUp(() {
    db = newTestDatabase();
    now = DateTime(2026, 11, 6, 9, 30);
  });
  tearDown(() => db.close());

  Future<void> settleUntil(WidgetTester tester, bool Function() done) async {
    for (var i = 0; i < 400 && !done(); i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(done(), isTrue, reason: 'did not settle');
    await tester.pumpAndSettle();
  }

  Future<void> pump(WidgetTester tester, FakeWatchLink link) => tester.pumpApp(
    database: db,
    overrides: [
      clockProvider.overrideWithValue(() => now),
      watchLinkProvider.overrideWithValue(link),
      locationSourceProvider.overrideWithValue(FakeLocationSource(null)),
      weatherSourceProvider.overrideWithValue(
        FakeWeatherSource(null)..error = Exception('offline'),
      ),
    ],
  );

  Future<List<AttackEntity>> attacks() =>
      DriftAttackRepository(db, clock: () => now).all();

  WatchCommand cmd(
    String id,
    WatchCommandType type,
    DateTime at, {
    int? intensity,
  }) => WatchCommand(id: id, type: type, at: at, intensity: intensity);

  testWidgets('opening the app sends the watch its state and labels', (
    tester,
  ) async {
    final link = FakeWatchLink();
    await pump(tester, link);
    await settleUntil(tester, () => link.pushed.isNotEmpty);
    final state = link.pushed.last;
    expect(state.attack, isNull);
    expect(state.pressure, 'No pressure forecast yet');
    expect(state.labels[WatchLabels.start], 'Start attack');
    expect(state.labels[WatchLabels.since], 'Since {time}');
    expect(state.labels.keys, containsAll(WatchLabels.keys));
    expect(state.accentColor, isNotNull);
    expect(state.acks, isEmpty);
  });

  testWidgets('start, intensity and stop from the watch land at the watch '
      'times, once each, and are acknowledged', (tester) async {
    final link = FakeWatchLink();
    await pump(tester, link);
    await settleUntil(tester, () => link.pushed.isNotEmpty);

    final started = now.subtract(const Duration(minutes: 40));
    final batch = [
      cmd('w1', WatchCommandType.start, started),
      cmd('w2', WatchCommandType.intensity, started, intensity: 7),
    ];
    link.send(batch);
    await settleUntil(tester, () => link.pushed.last.acks.length == 2);
    var all = await attacks();
    expect(all.single.startedAt.isAtSameMomentAs(started), isTrue);
    expect(all.single.intensity, 7);
    expect(link.pushed.last.attack!.intensity, 7);

    // The watch resends until it sees the acks: nothing applies twice.
    final before = link.pushed.length;
    link.send([...batch, cmd('w3', WatchCommandType.stop, now)]);
    await settleUntil(tester, () => link.pushed.last.acks.length == 3);
    expect(link.pushed.length, greaterThan(before));
    all = await attacks();
    expect(all, hasLength(1));
    expect(all.single.endedAt!.isAtSameMomentAs(now), isTrue);
    expect(link.pushed.last.attack, isNull);
    expect(link.pushed.last.acks, ['w1', 'w2', 'w3']);
  });

  testWidgets('taps queued while the phone app was closed are applied on '
      'open', (tester) async {
    final at = now.subtract(const Duration(hours: 2));
    final link = FakeWatchLink(
      leftWhileClosed: [
        WatchWire.wrap(
          WatchCommand.batchToJson([cmd('q1', WatchCommandType.start, at)]),
        ),
        {'something': 'else'},
      ],
    );
    await pump(tester, link);
    await settleUntil(tester, () => link.pushed.any((s) => s.acks.isNotEmpty));
    final all = await attacks();
    expect(all.single.startedAt.isAtSameMomentAs(at), isTrue);
    expect(all.single.isRunning, isTrue);
  });

  testWidgets('a future watch time is clamped; stop with nothing running '
      'is acknowledged and ignored', (tester) async {
    await pump(tester, FakeWatchLink());
    final handler = ProviderScope.containerOf(
      tester.element(find.byType(MaterialApp)),
    ).read(watchCommandHandlerProvider);

    final stop = await handler.handle(
      WatchWire.wrap(
        WatchCommand.batchToJson([cmd('s', WatchCommandType.stop, now)]),
      ),
    );
    expect(stop.map((c) => c.id), ['s']);
    expect(await attacks(), isEmpty);
    expect(await handler.handle({'not': 'ours'}), isEmpty);

    await handler.handle(
      WatchWire.wrap(
        WatchCommand.batchToJson([
          cmd('f', WatchCommandType.start, now.add(const Duration(hours: 1))),
        ]),
      ),
    );
    expect((await attacks()).single.startedAt.isAtSameMomentAs(now), isTrue);
  });
}
