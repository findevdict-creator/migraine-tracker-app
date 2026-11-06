import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/core/db/app_database.dart'
    hide FactorWeight, RiskDay;
import 'package:migraine_tracker/core/settings/settings_keys.dart';
import 'package:migraine_tracker/core/settings/settings_repository.dart';
import 'package:migraine_tracker/features/notifications/application/notification_scheduler.dart';
import 'package:migraine_tracker/features/notifications/data/local_notification_gateway.dart';
import 'package:migraine_tracker/features/notifications/presentation/notification_settings_screen.dart';
import 'package:migraine_tracker/features/weather/data/weather_sources.dart';

import '../../support/pump_app.dart';
import '../../support/test_database.dart';
import '../weather/support/weather_fakes.dart';
import 'support/fake_gateway.dart';

void main() {
  late AppDatabase db;
  late RecordingGateway gateway;

  setUp(() {
    db = newTestDatabase();
    gateway = RecordingGateway();
  });
  tearDown(() => db.close());

  /// Pumps until [done] holds. The scheduler's database work schedules no
  /// frame, so pumpAndSettle alone returns before it is finished.
  Future<void> settleUntil(WidgetTester tester, bool Function() done) async {
    for (var i = 0; i < 400 && !done(); i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(done(), isTrue, reason: 'scheduler did not settle');
    await tester.pumpAndSettle();
  }

  ProviderContainer containerOf(WidgetTester tester) =>
      ProviderScope.containerOf(tester.element(find.byType(MaterialApp)));

  Future<void> open(WidgetTester tester) async {
    await tester.pumpApp(
      database: db,
      overrides: [
        notificationGatewayProvider.overrideWithValue(gateway),
        // No location and no weather: the plan comes from the log only.
        locationSourceProvider.overrideWithValue(FakeLocationSource(null)),
        weatherSourceProvider.overrideWithValue(
          FakeWeatherSource(null)..error = Exception('offline'),
        ),
      ],
    );
    // Let home's own refresh finish so it cannot interleave with the
    // actions below.
    final container = containerOf(tester);
    await settleUntil(
      tester,
      () => !container.read(notificationRefreshProvider).isLoading,
    );
    await tester.tap(find.byKey(const ValueKey('home-settings')));
    await tester.pumpAndSettle();
    await tester.scrollToKey('settings-notifications');
    await tester.tap(find.byKey(const ValueKey('settings-notifications')));
    await tester.pumpAndSettle();
    expect(find.byType(NotificationSettingsScreen), findsOneWidget);
  }

  /// Runs [act], then waits for the reschedule it triggers to finish.
  Future<void> actAndSettle(
    WidgetTester tester,
    Future<void> Function() act,
  ) async {
    final scheduler = containerOf(tester).read(notificationSchedulerProvider);
    final before = gateway.cancels;
    await act();
    await settleUntil(
      tester,
      () => gateway.cancels > before && scheduler.isIdle,
    );
  }

  bool switchOn(WidgetTester tester, String code) =>
      tester.widget<SwitchListTile>(find.byKey(ValueKey('notif-$code'))).value;

  testWidgets('five switches with their defaults; toggling asks for '
      'permission and persists', (tester) async {
    await open(tester);
    for (final code in [
      'riskRising',
      'pressureDrop',
      'attackOver',
      'checkin',
    ]) {
      await tester.scrollToKey('notif-$code');
      expect(switchOn(tester, code), isTrue, reason: code);
    }
    await tester.scrollToKey('notif-medication');
    expect(switchOn(tester, 'medication'), isFalse);

    await actAndSettle(
      tester,
      () => tester.tap(find.byKey(const ValueKey('notif-medication'))),
    );
    expect(switchOn(tester, 'medication'), isTrue);
    expect(gateway.permissionRequests, 1);
    expect(gateway.cancels, greaterThanOrEqualTo(1));
    expect(gateway.keys.where((k) => k.startsWith('medication')), isNotEmpty);
    expect(
      await SettingsRepository(db)
          .read<bool>(SettingsKeys.notificationType('medication')),
      isTrue,
    );

    await tester.scrollToKey('notif-checkin');
    await actAndSettle(
      tester,
      () => tester.tap(find.byKey(const ValueKey('notif-checkin'))),
    );
    expect(switchOn(tester, 'checkin'), isFalse);
    expect(gateway.permissionRequests, 1);
    expect(gateway.keys.where((k) => k.startsWith('checkin')), isEmpty);
  });

  testWidgets('a denied permission shows the hint', (tester) async {
    gateway = RecordingGateway(granted: false);
    await open(tester);
    await tester.scrollToKey('notif-medication');
    await actAndSettle(
      tester,
      () => tester.tap(find.byKey(const ValueKey('notif-medication'))),
    );
    // The hint sits above the switches; the list is lazy.
    await tester.scrollToKey('notif-denied');
    expect(find.byKey(const ValueKey('notif-denied')), findsOneWidget);
  });

  testWidgets('the pressure threshold slider updates the hint and the '
      'stored value', (tester) async {
    await open(tester);
    await tester.scrollToKey('notif-threshold');
    expect(find.text('Pressure drop threshold: 5 hPa in 24 h'), findsOneWidget);
    final slider = find.byKey(const ValueKey('notif-threshold-slider'));
    await actAndSettle(tester, () => tester.drag(slider, const Offset(400, 0)));
    expect(
      await SettingsRepository(db)
          .read<num>(SettingsKeys.notificationPressureThreshold),
      12,
    );
    expect(
      find.text('Pressure drop threshold: 12 hPa in 24 h'),
      findsOneWidget,
    );
  });

  testWidgets('the medication time row opens a picker and stores the time', (
    tester,
  ) async {
    await open(tester);
    await tester.scrollToKey('notif-medication-time');
    expect(find.text('9:00 PM'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('notif-medication-time')));
    await tester.pumpAndSettle();
    await actAndSettle(tester, () => tester.tap(find.text('OK')));
    expect(
      await SettingsRepository(db)
          .read<String>(SettingsKeys.notificationMedicationTime),
      '21:0',
    );
  });
}
