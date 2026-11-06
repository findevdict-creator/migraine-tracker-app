import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:migraine_tracker/app/router.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/account/data/firebase_auth_gateway.dart';
import 'package:migraine_tracker/features/account/domain/account.dart';
import 'package:migraine_tracker/features/backup/application/backup_service.dart';
import 'package:migraine_tracker/features/backup/domain/backup_envelope.dart';
import 'package:migraine_tracker/features/export/data/export_service.dart';
import 'package:migraine_tracker/features/premium/data/revenuecat_gateway.dart';
import 'package:migraine_tracker/features/premium/domain/premium.dart';
import 'package:migraine_tracker/features/premium/presentation/premium_lock.dart';
import 'package:migraine_tracker/features/premium/presentation/premium_screen.dart';
import 'package:migraine_tracker/features/weather/data/weather_sources.dart';

import '../../support/pump_app.dart';
import '../../support/test_database.dart';
import '../account/account_screen_test.dart' show FakeAuthGateway;
import '../backup/support/backup_fakes.dart';
import '../weather/support/weather_fakes.dart';
import 'support/premium_fakes.dart';

void main() {
  late AppDatabase db;
  var now = DateTime(2026, 11, 6, 9, 30);
  const user = AccountUser(
    uid: 'u1',
    email: 'me@example.com',
    method: SignInMethod.email,
  );

  setUp(() {
    db = newTestDatabase();
    now = DateTime(2026, 11, 6, 9, 30);
  });
  tearDown(() => db.close());

  bool shown(String key) => find.byKey(ValueKey(key)).evaluate().isNotEmpty;

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  Future<void> pump(
    WidgetTester tester, {
    PurchasesGateway? store,
    FakeAuthGateway? auth,
    AppFlavor flavor = AppFlavor.staging,
  }) async {
    await tester.pumpApp(
      database: db,
      flavor: flavor,
      overrides: [
        clockProvider.overrideWithValue(() => now),
        ?(store == null
            ? null
            : purchasesGatewayProvider.overrideWithValue(store)),
        authGatewayProvider.overrideWithValue(auth ?? FakeAuthGateway()),
        backupServiceProvider.overrideWithValue(
          BackupService(
            export: ExportService(db, clock: () => now),
            store: () async => MemoryBackupStore(now: () => now),
            clock: () => now,
            schemaVersion: db.schemaVersion,
            params: testKdf,
            derive: argon2idKey,
          ),
        ),
        locationSourceProvider.overrideWithValue(FakeLocationSource(null)),
        weatherSourceProvider.overrideWithValue(
          FakeWeatherSource(null)..error = Exception('offline'),
        ),
      ],
    );
  }

  Future<void> openSettingsTile(WidgetTester tester, String key) async {
    await tester.tap(find.byKey(const ValueKey('home-settings')));
    await tester.pumpAndSettle();
    await tester.scrollToKey(key);
    await tester.tap(find.byKey(ValueKey(key)));
    await tester.pumpAndSettle();
  }

  Future<void> back(WidgetTester tester) async {
    await tester.pageBack();
    await tester.pumpAndSettle();
  }

  Future<void> tapKey(WidgetTester tester, String key) async {
    await tester.scrollToKey(key);
    await tester.tap(find.byKey(ValueKey(key)));
    await tester.pumpAndSettle();
  }

  String textOf(WidgetTester tester, String key) =>
      tester.widget<Text>(find.byKey(ValueKey(key))).data ?? '';

  testWidgets('the free tier is never time-limited: ten years on, without '
      'Premium, every free feature opens with no lock', (tester) async {
    now = now.add(const Duration(days: 3650));
    await pump(tester, store: FakePurchasesGateway());
    final router = GoRouter.of(
      tester.element(find.byKey(const ValueKey('home-settings'))),
    );
    expect(shown('start-attack'), isTrue);
    for (final route in [
      AppRoutes.checkin(now.dateKey),
      AppRoutes.medications,
      AppRoutes.environment,
      AppRoutes.risk,
      AppRoutes.insights,
      AppRoutes.report,
      AppRoutes.questionnaires,
    ]) {
      unawaitedPush(router, route);
      await settle(tester);
      expect(find.byType(PremiumLockCard), findsNothing, reason: route);
      expect(find.byType(PremiumScreen), findsNothing, reason: route);
      router.pop();
      await settle(tester);
    }
  });

  testWidgets('paywall: store prices, what stays free, buy yearly; Premium '
      'turns on and experiments open', (tester) async {
    final store = FakePurchasesGateway();
    await pump(tester, store: store);
    await openSettingsTile(tester, 'settings-premium');
    expect(find.byType(PremiumScreen), findsOneWidget);
    for (final f in AppPremium.features) {
      expect(shown('premium-feature-${f.name}'), isTrue);
    }
    expect(shown('premium-free-note'), isTrue);
    await tester.scrollToKey(r'premium-offer-$rc_monthly');
    expect(find.text(r'Yearly, $19.99'), findsOneWidget);
    expect(find.text(r'Monthly, $2.99'), findsOneWidget);
    expect(shown('premium-account-tip'), isTrue);
    await tester.scrollToKey('premium-terms');
    expect(shown('premium-terms'), isTrue);

    await tapKey(tester, r'premium-offer-$rc_annual');
    expect(store.bought, [r'$rc_annual']);
    await tester.scrollToKey('premium-message');
    expect(textOf(tester, 'premium-message'), 'Thank you. Premium is on.');
    await tester.scrollToKey('premium-active');
    expect(textOf(tester, 'premium-period'), 'Renews on Dec 6, 2026.');
    expect(shown(r'premium-offer-$rc_annual'), isFalse);

    await back(tester);
    await tester.scrollToKey('settings-premium');
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('settings-premium')),
        matching: find.text('On'),
      ),
      findsOneWidget,
    );
    await tapKey(tester, 'settings-experiments');
    expect(shown('experiment-pick-cut_caffeine'), isTrue);
    expect(shown('premium-lock-experiments'), isFalse);
  });

  testWidgets('locked: experiments, backup and the share link show the lock, '
      'and the lock opens the paywall', (tester) async {
    await pump(
      tester,
      store: FakePurchasesGateway(),
      auth: FakeAuthGateway(current: user),
    );
    await openSettingsTile(tester, 'settings-experiments');
    expect(shown('premium-lock-experiments'), isTrue);
    expect(shown('experiment-pick-cut_caffeine'), isFalse);
    await tapKey(tester, 'premium-lock-open-experiments');
    expect(find.byType(PremiumScreen), findsOneWidget);
    await back(tester);
    await back(tester);

    await tapKey(tester, 'settings-backup');
    await tester.scrollToKey('premium-lock-backup');
    expect(shown('backup-now'), isFalse);
    expect(shown('backup-passphrase'), isFalse);
    await back(tester);

    await tapKey(tester, 'settings-report');
    for (var i = 0; i < 100 && !shown('report-share-link'); i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    await tapKey(tester, 'report-share-link');
    expect(shown('premium-lock-shareLink'), isTrue);
    expect(shown('share-link-create'), isFalse);
    await tapKey(tester, 'premium-lock-open-shareLink');
    expect(find.byType(PremiumScreen), findsOneWidget);
    expect(shown('share-link-sheet'), isFalse);
  });

  testWidgets('a change from the store applies at once', (tester) async {
    final store = FakePurchasesGateway(current: FakePurchasesGateway.active);
    await pump(tester, store: store);
    await openSettingsTile(tester, 'settings-experiments');
    expect(shown('experiment-pick-cut_caffeine'), isTrue);
    store.push(PremiumStatus.none);
    await tester.pumpAndSettle();
    expect(shown('premium-lock-experiments'), isTrue);
  });

  testWidgets('restore, cancel and a pending purchase each say the right '
      'thing', (tester) async {
    final store = FakePurchasesGateway();
    await pump(tester, store: store);
    await openSettingsTile(tester, 'settings-premium');

    await tapKey(tester, 'premium-restore');
    await tester.scrollToKey('premium-message');
    expect(
      textOf(tester, 'premium-message'),
      'No Premium purchase was found for this store account.',
    );

    store.failWith = PurchaseError.cancelled;
    await tapKey(tester, r'premium-offer-$rc_monthly');
    expect(shown('premium-message'), isFalse);

    store.failWith = PurchaseError.pending;
    await tapKey(tester, r'premium-offer-$rc_monthly');
    await tester.scrollToKey('premium-message');
    expect(textOf(tester, 'premium-message'), startsWith('The purchase is '));

    store
      ..failWith = null
      ..restorable = FakePurchasesGateway.active;
    await tapKey(tester, 'premium-restore');
    await tester.scrollToKey('premium-active');
    expect(shown('premium-active'), isTrue);
  });

  testWidgets('signing in ties purchases to the account; signing out undoes '
      'it', (tester) async {
    final store = FakePurchasesGateway();
    final auth = FakeAuthGateway();
    await pump(tester, store: store, auth: auth);
    expect(store.identified, isEmpty);
    await auth.signInWithEmail('me@example.com', 'password1');
    await tester.pumpAndSettle();
    expect(store.identified, ['u1']);
    await auth.signOut();
    await tester.pumpAndSettle();
    expect(store.identified, ['u1', null]);
  });

  testWidgets('without a store key, staging stays locked and says so', (
    tester,
  ) async {
    await pump(tester);
    await openSettingsTile(tester, 'settings-premium');
    expect(shown('premium-unavailable'), isTrue);
    expect(shown('premium-restore'), isFalse);
    await back(tester);
    await tapKey(tester, 'settings-experiments');
    expect(shown('premium-lock-experiments'), isTrue);
  });

  testWidgets('dev build without a store key unlocks everything', (
    tester,
  ) async {
    await pump(tester, flavor: AppFlavor.dev);
    await openSettingsTile(tester, 'settings-premium');
    expect(shown('premium-dev-unlocked'), isTrue);
    await back(tester);
    await tapKey(tester, 'settings-experiments');
    expect(shown('experiment-pick-cut_caffeine'), isTrue);
  });
}

void unawaitedPush(GoRouter router, String route) {
  // The pushed screen's result is not needed.
  router.push<void>(route).ignore();
}
