import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/db/app_database.dart'
    hide FactorWeight, RiskDay;
import 'package:migraine_tracker/core/db/database_provider.dart';
import 'package:migraine_tracker/core/settings/settings_keys.dart';
import 'package:migraine_tracker/core/settings/settings_repository.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/notifications/data/local_notification_gateway.dart';
import 'package:migraine_tracker/features/push/application/push_registration.dart';
import 'package:migraine_tracker/features/push/data/firebase_push_gateway.dart';
import 'package:migraine_tracker/features/push/domain/push_gateway.dart';
import 'package:migraine_tracker/features/weather/data/weather_sources.dart';

import '../../support/test_database.dart';
import '../notifications/support/fake_gateway.dart';
import '../risk/support/risk_seed.dart';
import '../weather/support/weather_fakes.dart';

class FakePushGateway implements PushGateway {
  FakePushGateway(this.current);

  String? current;
  final refreshes = StreamController<String>.broadcast();
  final messages = StreamController<Map<String, String>>.broadcast();

  @override
  Future<String?> token() async => current;

  @override
  Stream<String> get tokenRefreshes => refreshes.stream;

  @override
  Stream<Map<String, String>> get foregroundMessages => messages.stream;
}

class RecordingRegistry implements PushTokenRegistry {
  final calls = <(String, String)>[];
  Exception? error;

  @override
  Future<void> register({
    required String token,
    required String platform,
  }) async {
    if (error != null) throw error!;
    calls.add((token, platform));
  }
}

void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late FakePushGateway push;
  late RecordingRegistry registry;
  late FakeWeatherSource weather;
  late RecordingGateway notifications;
  var now = DateTime(2026, 11, 6, 9, 30);

  setUp(() {
    now = DateTime(2026, 11, 6, 9, 30);
    db = newTestDatabase();
    push = FakePushGateway('tok-1');
    registry = RecordingRegistry();
    weather = FakeWeatherSource(weatherPayload(now: now));
    notifications = RecordingGateway();
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        clockProvider.overrideWithValue(() => now),
        pushGatewayProvider.overrideWithValue(push),
        pushTokenRegistryProvider.overrideWithValue(registry),
        weatherSourceProvider.overrideWithValue(weather),
        locationSourceProvider.overrideWithValue(FakeLocationSource(null)),
        notificationGatewayProvider.overrideWithValue(notifications),
        pushRegistrarProvider.overrideWith(
          (ref) => PushRegistrar(ref, platform: 'android'),
        ),
      ],
    );
  });

  tearDown(() async {
    await push.refreshes.close();
    await push.messages.close();
    container.dispose();
    await db.close();
  });

  PushRegistrar registrar() => container.read(pushRegistrarProvider);
  SettingsRepository settings() => container.read(settingsRepositoryProvider);

  test('registers once, then not again while fresh', () async {
    expect(await registrar().ensureRegistered(), isTrue);
    expect(registry.calls, [('tok-1', 'android')]);
    expect(await settings().read<String>(SettingsKeys.pushToken), 'tok-1');
    expect(await registrar().ensureRegistered(), isFalse);
    expect(registry.calls.length, 1);
  });

  test('registers again when the token changes or the registration is '
      'older than the refresh window', () async {
    await registrar().ensureRegistered();
    push.current = 'tok-2';
    expect(await registrar().ensureRegistered(), isTrue);
    expect(registry.calls.last, ('tok-2', 'android'));

    now = now.add(AppThresholds.pushTokenRefresh - const Duration(hours: 1));
    expect(await registrar().ensureRegistered(), isFalse);
    now = now.add(const Duration(hours: 2));
    expect(await registrar().ensureRegistered(), isTrue);
    expect(registry.calls.length, 3);
  });

  test('no token: nothing is sent or stored', () async {
    push.current = null;
    expect(await registrar().ensureRegistered(), isFalse);
    expect(registry.calls, isEmpty);
    expect(await settings().read<String>(SettingsKeys.pushToken), isNull);
  });

  test('a failed call leaves nothing stored so the next run retries', () async {
    registry.error = Exception('offline');
    expect(await registrar().ensureRegistered(), isFalse);
    expect(await settings().read<String>(SettingsKeys.pushToken), isNull);
    registry.error = null;
    expect(await registrar().ensureRegistered(), isTrue);
  });

  test('start registers, follows token rotation and runs a foreground '
      'wake-up', () async {
    await seedCell(container);
    final handle = registrar().start();
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(registry.calls, [('tok-1', 'android')]);

    push.refreshes.add('tok-rotated');
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(registry.calls.last, ('tok-rotated', 'android'));
    expect(
      await settings().read<String>(SettingsKeys.pushToken),
      'tok-rotated',
    );

    push.messages.add({'type': 'other'});
    push.messages.add({'type': AppBackgroundTasks.pushWakeupType});
    await Future<void>.delayed(const Duration(milliseconds: 200));
    expect(weather.calls.length, 1);
    expect(notifications.cancels, 1);

    await handle.dispose();
    push.refreshes.add('tok-after');
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(registry.calls.last, ('tok-rotated', 'android'));
  });
}
