import 'dart:convert';

import 'package:test/test.dart';
import 'package:watch_protocol/watch_protocol.dart';

void main() {
  final t0 = DateTime.utc(2026, 11, 6, 9);

  WatchCommand cmd(
    String id,
    WatchCommandType type, {
    int minutes = 0,
    int? intensity,
  }) => WatchCommand(
    id: id,
    type: type,
    at: t0.add(Duration(minutes: minutes)),
    intensity: intensity,
  );

  group('WatchWire', () {
    test('wraps into one string and unwraps', () {
      final wrapped = WatchWire.wrap({'a': 1});
      expect(wrapped.keys, [WatchWire.payloadKey]);
      expect(wrapped.values.single, isA<String>());
      expect(WatchWire.unwrap(wrapped), {'v': WatchWire.version, 'a': 1});
    });

    test('ignores foreign, malformed and newer payloads', () {
      expect(WatchWire.unwrap(null), isNull);
      expect(WatchWire.unwrap({'other': 'x'}), isNull);
      expect(WatchWire.unwrap({WatchWire.payloadKey: 3}), isNull);
      expect(WatchWire.unwrap({WatchWire.payloadKey: '{not json'}), isNull);
      expect(WatchWire.unwrap({WatchWire.payloadKey: '[1]'}), isNull);
      expect(WatchWire.unwrap({WatchWire.payloadKey: '{"a":1}'}), isNull);
      expect(
        WatchWire.unwrap({
          WatchWire.payloadKey: jsonEncode({'v': WatchWire.version + 1}),
        }),
        isNull,
      );
    });
  });

  group('WatchCommand', () {
    test('round-trips every type through a batch', () {
      final commands = [
        cmd('a', WatchCommandType.start),
        cmd('b', WatchCommandType.intensity, minutes: 1, intensity: 7),
        cmd('c', WatchCommandType.stop, minutes: 90),
      ];
      final wire = WatchWire.wrap(WatchCommand.batchToJson(commands));
      final back = WatchCommand.batchFromJson(WatchWire.unwrap(wire));
      expect(back, commands);
      expect(back.map((c) => c.hashCode), commands.map((c) => c.hashCode));
      expect(back.first.toString(), contains('start'));
    });

    test('clamps intensity and requires it for the intensity type', () {
      expect(cmd('x', WatchCommandType.intensity, intensity: 14).intensity, 10);
      expect(() => cmd('x', WatchCommandType.intensity), throwsArgumentError);
    });

    test('drops malformed entries', () {
      final good = cmd('ok', WatchCommandType.start).toJson();
      final batch = WatchCommand.batchFromJson({
        'commands': [
          good,
          'nope',
          {...good, 'id': ''},
          {...good, 'type': 'dance'},
          {...good, 'at': 'yesterday'},
          {...good, 'at': 5},
          {...good, 'type': 'intensity'},
        ],
      });
      expect(batch.map((c) => c.id), ['ok']);
      expect(WatchCommand.batchFromJson(null), isEmpty);
      expect(WatchCommand.batchFromJson({'commands': 'x'}), isEmpty);
      expect(WatchCommandType.fromCode('stop'), WatchCommandType.stop);
    });
  });

  group('WatchState', () {
    test('round-trips', () {
      final state = WatchState(
        sentAt: t0,
        level: 'high',
        levelLabel: 'Level: High',
        headline: 'Top factor: Pressure drop',
        pressure: 'Pressure falling 4.3 hPa in 24 h',
        updated: 'Updated 09:00',
        levelColor: 0xFFEF9A9A,
        accentColor: 0xFF5B5BD6,
        attack: WatchAttack(startedAt: t0, intensity: 6),
        labels: const {WatchLabels.start: 'Start'},
        acks: const ['a', 'b'],
      );
      final back = WatchState.fromJson(
        WatchWire.unwrap(WatchWire.wrap(state.toJson())),
      )!;
      expect(back.sentAt, t0);
      expect(back.level, 'high');
      expect(back.levelLabel, 'Level: High');
      expect(back.headline, state.headline);
      expect(back.pressure, state.pressure);
      expect(back.updated, state.updated);
      expect(back.levelColor, 0xFFEF9A9A);
      expect(back.accentColor, 0xFF5B5BD6);
      expect(back.attack, state.attack);
      expect(back.attack.hashCode, state.attack.hashCode);
      expect(back.labels, state.labels);
      expect(back.acks, ['a', 'b']);
    });

    test('tolerates missing and wrong-typed fields', () {
      expect(WatchState.fromJson(null), isNull);
      expect(WatchState.fromJson({'sentAt': 'later'}), isNull);
      final s = WatchState.fromJson({
        'sentAt': t0.toIso8601String(),
        'level': 3,
        'attack': {'startedAt': 'never'},
        'labels': {'start': 1, 'stop': 'End'},
        'acks': ['a', 2],
      })!;
      expect(s.level, '');
      expect(s.attack, isNull);
      expect(s.labels, {'stop': 'End'});
      expect(s.acks, ['a']);
      expect(s.levelColor, isNull);
      expect(WatchAttack.fromJson('x'), isNull);
      expect(
        WatchState.fromJson({
          'sentAt': t0.toIso8601String(),
          'labels': 'x',
          'acks': 'y',
        })!.labels,
        isEmpty,
      );
    });
  });

  group('CommandQueue', () {
    test('adds, acknowledges and survives storage', () {
      var q = const CommandQueue();
      expect(q.isEmpty, isTrue);
      q = q
          .add(cmd('a', WatchCommandType.start))
          .add(cmd('b', WatchCommandType.stop, minutes: 5));
      expect(identical(q.acknowledge(['zzz']), q), isTrue);
      q = q.acknowledge(['a']);
      expect(q.pending.map((c) => c.id), ['b']);
      expect(CommandQueue.fromJson(q.toJson()).pending, q.pending);
      expect(CommandQueue.fromJson('junk').isEmpty, isTrue);
    });

    test('keeps only the newest commands past the cap', () {
      var q = const CommandQueue();
      for (var i = 0; i < CommandQueue.maxLength + 5; i++) {
        q = q.add(cmd('$i', WatchCommandType.start, minutes: i));
      }
      expect(q.pending.length, CommandQueue.maxLength);
      expect(q.pending.first.id, '5');
    });
  });

  group('CommandLedger', () {
    test('records once, caps and windows the acks', () {
      var l = const CommandLedger().record(['a', 'b']).record(['b', 'c']);
      expect(l.ids, ['a', 'b', 'c']);
      expect(l.contains('b'), isTrue);
      expect(l.acks, ['a', 'b', 'c']);
      l = l.record([for (var i = 0; i < CommandLedger.maxLength; i++) '$i']);
      expect(l.ids.length, CommandLedger.maxLength);
      expect(l.contains('a'), isFalse);
      expect(l.acks.length, CommandLedger.ackWindow);
      expect(l.acks.last, '${CommandLedger.maxLength - 1}');
    });
  });

  group('WatchView', () {
    test('before any phone state: fallback labels, nothing running', () {
      final v = WatchView.of(null, const CommandQueue());
      expect(v.hasPhone, isFalse);
      expect(v.running, isFalse);
      expect(v.label(WatchLabels.start), 'Start attack');
      expect(v.label('unknown'), 'unknown');
      expect(WatchLabels.keys.every(WatchLabels.fallback.containsKey), isTrue);
    });

    test('pending commands apply on top of the phone state', () {
      final queue = const CommandQueue()
          .add(cmd('s', WatchCommandType.start, minutes: 1))
          .add(cmd('i', WatchCommandType.intensity, minutes: 2, intensity: 8));
      final v = WatchView.of(WatchState(sentAt: t0), queue);
      expect(v.running, isTrue);
      expect(v.attack!.startedAt, t0.add(const Duration(minutes: 1)));
      expect(v.attack!.intensity, 8);
      expect(v.pendingCount, 2);

      final stopped = WatchView.of(
        WatchState(sentAt: t0),
        queue.add(cmd('x', WatchCommandType.stop, minutes: 3)),
      );
      expect(stopped.running, isFalse);
    });

    test('acknowledged commands are not applied twice', () {
      final phone = WatchState(
        sentAt: t0,
        attack: WatchAttack(startedAt: t0, intensity: 4),
        acks: const ['s'],
        labels: const {WatchLabels.start: 'Anfall starten'},
      );
      final queue = const CommandQueue()
          .add(cmd('s', WatchCommandType.start, minutes: 9))
          .add(cmd('i', WatchCommandType.intensity, intensity: 2));
      final v = WatchView.of(phone, queue);
      expect(v.attack!.startedAt, t0);
      expect(v.attack!.intensity, 2);
      expect(v.pendingCount, 1);
      expect(v.label(WatchLabels.start), 'Anfall starten');
      expect(v.label(WatchLabels.stop), 'End attack');
    });

    test('intensity without a running attack does nothing', () {
      final v = WatchView.of(
        null,
        const CommandQueue().add(
          cmd('i', WatchCommandType.intensity, intensity: 5),
        ),
      );
      expect(v.running, isFalse);
      expect(v.pendingCount, 1);
    });
  });
}
