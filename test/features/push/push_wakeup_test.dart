import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/core/db/app_database.dart'
    hide FactorWeight, RiskDay;
import 'package:migraine_tracker/core/db/database_provider.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/notifications/data/local_notification_gateway.dart';
import 'package:migraine_tracker/features/push/application/push_wakeup.dart';
import 'package:migraine_tracker/features/risk/data/risk_repository_impl.dart';
import 'package:migraine_tracker/features/weather/data/weather_repository_impl.dart';
import 'package:migraine_tracker/features/weather/data/weather_sources.dart';

import '../../support/test_database.dart';
import '../notifications/support/fake_gateway.dart';
import '../risk/support/risk_seed.dart';
import '../weather/support/weather_fakes.dart';

void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late FakeWeatherSource weather;
  late RecordingGateway notifications;
  final now = DateTime(2026, 11, 6, 9, 30);

  setUp(() {
    db = newTestDatabase();
    weather = FakeWeatherSource(weatherPayload(now: now));
    notifications = RecordingGateway();
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        clockProvider.overrideWithValue(() => now),
        weatherSourceProvider.overrideWithValue(weather),
        locationSourceProvider.overrideWithValue(FakeLocationSource(null)),
        notificationGatewayProvider.overrideWithValue(notifications),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  Ref ref() => container.read(_refProvider);

  test("isWakeup matches the function's message type only", () {
    expect(PushWakeup.isWakeup({'type': 'wakeup'}), isTrue);
    expect(PushWakeup.isWakeup({'type': 'other'}), isFalse);
    expect(PushWakeup.isWakeup({}), isFalse);
  });

  test('a wake-up fetches the forecast even when fresh, scores the days '
      'ahead and re-plans the alerts', () async {
    await seedCell(container);
    // A fresh fetch already in the store: a plain refresh would skip it.
    await container.read(weatherRepositoryProvider).upsertHours([]);
    final first = await PushWakeup.run(ref());
    expect(first.fetched, isTrue);
    expect(weather.calls.length, 1);
    expect(first.scoredDays, greaterThan(0));
    expect(await container.read(riskRepositoryProvider).allRisk(), isNotEmpty);
    expect(notifications.cancels, 1);
    expect(first.plannedNotifications, notifications.scheduled.length);

    final second = await PushWakeup.run(ref());
    expect(second.fetched, isTrue, reason: 'force bypasses the cache window');
    expect(weather.calls.length, 2);
  });

  test('without a cell nothing is fetched and the plan still runs', () async {
    final outcome = await PushWakeup.run(ref());
    expect(outcome.fetched, isFalse);
    expect(weather.calls, isEmpty);
    expect(notifications.cancels, 1);
  });

  test('a failing fetch leaves the stored plan in place', () async {
    await seedCell(container);
    weather.error = Exception('offline');
    final outcome = await PushWakeup.run(ref());
    expect(outcome.fetched, isFalse);
    expect(notifications.cancels, 1);
  });
}

final _refProvider = Provider<Ref>((ref) => ref);
