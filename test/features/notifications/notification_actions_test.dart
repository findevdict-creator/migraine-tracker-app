import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/db/app_database.dart'
    hide FactorWeight, RiskDay;
import 'package:migraine_tracker/core/db/database_provider.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/attack_log/data/attack_repository_impl.dart';
import 'package:migraine_tracker/features/attack_log/domain/attack_entity.dart';
import 'package:migraine_tracker/features/notifications/application/notification_actions.dart';
import 'package:migraine_tracker/features/notifications/data/local_notification_gateway.dart';

import '../../support/test_database.dart';
import 'support/fake_gateway.dart';

void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late RecordingGateway gateway;
  final now = DateTime(2026, 11, 6, 9, 30);

  setUp(() {
    db = newTestDatabase();
    gateway = RecordingGateway();
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        clockProvider.overrideWithValue(() => now),
        notificationGatewayProvider.overrideWithValue(gateway),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  Ref ref() => container.read(_refProvider);

  test(
    'the end-attack action ends the running attack and reschedules',
    () async {
      final repo = container.read(attackRepositoryProvider);
      await repo.save(
        AttackEntity(
          id: 'run',
          startedAt: now.subtract(const Duration(hours: 3)),
          finishLater: true,
        ),
      );
      final handled = await NotificationActions.handle(
        ref(),
        const NotificationResponse(
          notificationResponseType:
              NotificationResponseType.selectedNotificationAction,
          actionId: AppNotificationChannels.endAttackAction,
          payload: 'run',
        ),
      );
      expect(handled, isTrue);
      final attack = (await repo.byId('run'))!;
      expect(attack.endedAt, now);
      expect(attack.finishLater, isFalse);
      expect(await repo.running(), isNull);
      expect(gateway.cancels, 1);
      expect(gateway.keys.where((k) => k.startsWith('attackOver')), isEmpty);
    },
  );

  test('a plain tap, an unknown id or an ended attack do nothing', () async {
    final repo = container.read(attackRepositoryProvider);
    await repo.save(
      AttackEntity(
        id: 'done',
        startedAt: now.subtract(const Duration(hours: 3)),
        endedAt: now.subtract(const Duration(hours: 1)),
      ),
    );
    expect(
      await NotificationActions.handle(
        ref(),
        const NotificationResponse(
          notificationResponseType:
              NotificationResponseType.selectedNotification,
          payload: 'done',
        ),
      ),
      isFalse,
    );
    expect(
      await NotificationActions.handle(
        ref(),
        const NotificationResponse(
          notificationResponseType:
              NotificationResponseType.selectedNotificationAction,
          actionId: AppNotificationChannels.endAttackAction,
          payload: 'missing',
        ),
      ),
      isFalse,
    );
    expect(
      await NotificationActions.handle(
        ref(),
        const NotificationResponse(
          notificationResponseType:
              NotificationResponseType.selectedNotificationAction,
          actionId: AppNotificationChannels.endAttackAction,
          payload: 'done',
        ),
      ),
      isFalse,
    );
    expect(gateway.cancels, 0);
  });
}

final _refProvider = Provider<Ref>((ref) => ref);
