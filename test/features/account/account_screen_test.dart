import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/features/account/data/firebase_auth_gateway.dart';
import 'package:migraine_tracker/features/account/domain/account.dart';
import 'package:migraine_tracker/features/account/presentation/account_screen.dart';
import 'package:migraine_tracker/features/weather/data/weather_sources.dart';

import '../../support/pump_app.dart';
import '../../support/test_database.dart';
import '../weather/support/weather_fakes.dart';

/// Records calls and plays the account stream like Firebase would.
class FakeAuthGateway implements AuthGateway {
  FakeAuthGateway({this.current});

  AccountUser? current;
  AccountException? failWith;
  final calls = <String>[];
  String? deletePassword;
  final _changes = StreamController<AccountUser?>.broadcast();

  @override
  bool get available => true;

  @override
  Future<String?> idToken() async => current == null ? null : 'token-u1';

  @override
  Stream<AccountUser?> userChanges() async* {
    yield current;
    yield* _changes.stream;
  }

  Future<void> _do(String call, {AccountUser? signsIn, bool out = false}) {
    calls.add(call);
    final failure = failWith;
    if (failure != null) return Future.error(failure);
    if (signsIn != null || out) {
      current = signsIn;
      _changes.add(signsIn);
    }
    return Future.value();
  }

  static AccountUser _email(String email) =>
      AccountUser(uid: 'u1', email: email, method: SignInMethod.email);

  @override
  Future<void> signInWithApple() => _do(
    'apple',
    signsIn: const AccountUser(uid: 'u1', method: SignInMethod.apple),
  );
  @override
  Future<void> signInWithGoogle() => _do(
    'google',
    signsIn: const AccountUser(
      uid: 'u1',
      email: 'g@example.com',
      method: SignInMethod.google,
    ),
  );
  @override
  Future<void> signInWithEmail(String email, String password) =>
      _do('signIn $email', signsIn: _email(email));
  @override
  Future<void> createAccount(String email, String password) =>
      _do('create $email', signsIn: _email(email));
  @override
  Future<void> sendPasswordReset(String email) => _do('reset $email');
  @override
  Future<void> signOut() => _do('signOut', out: true);
  @override
  Future<void> deleteAccount({String? password}) {
    deletePassword = password;
    return _do('delete', out: true);
  }
}

void main() {
  late AppDatabase db;

  setUp(() => db = newTestDatabase());
  tearDown(() => db.close());

  bool shown(String key) => find.byKey(ValueKey(key)).evaluate().isNotEmpty;

  Future<void> open(WidgetTester tester, {AuthGateway? gateway}) async {
    await tester.pumpApp(
      database: db,
      overrides: [
        if (gateway != null) authGatewayProvider.overrideWithValue(gateway),
        locationSourceProvider.overrideWithValue(FakeLocationSource(null)),
        weatherSourceProvider.overrideWithValue(
          FakeWeatherSource(null)..error = Exception('offline'),
        ),
      ],
    );
    await tester.tap(find.byKey(const ValueKey('home-settings')));
    await tester.pumpAndSettle();
    await tester.scrollToKey('settings-account');
    await tester.tap(find.byKey(const ValueKey('settings-account')));
    await tester.pumpAndSettle();
    expect(find.byType(AccountScreen), findsOneWidget);
  }

  Future<void> tapKey(WidgetTester tester, String key) async {
    await tester.scrollToKey(key);
    await tester.tap(find.byKey(ValueKey(key)));
    await tester.pumpAndSettle();
  }

  Future<void> type(WidgetTester tester, String key, String text) async {
    await tester.scrollToKey(key);
    await tester.enterText(find.byKey(ValueKey(key)), text);
  }

  String message(WidgetTester tester) =>
      tester.widget<Text>(find.byKey(const ValueKey('account-message'))).data ??
      '';

  testWidgets('without a Firebase project it says accounts are optional and '
      'not set up, and offers nothing to tap', (tester) async {
    await open(tester);
    expect(find.textContaining('An account is optional'), findsOneWidget);
    expect(shown('account-unavailable'), isTrue);
    expect(shown('account-google'), isFalse);
    expect(shown('account-email'), isFalse);
  });

  testWidgets('create an email account: the form is checked first, then the '
      'account shows as signed in', (tester) async {
    final gateway = FakeAuthGateway();
    await open(tester, gateway: gateway);
    await type(tester, 'account-email', 'not-an-email');
    await tapKey(tester, 'account-create');
    expect(message(tester), 'Check the email address.');

    await type(tester, 'account-email', 'me@example.com');
    await type(tester, 'account-password', 'short');
    await tapKey(tester, 'account-create');
    expect(message(tester), 'Choose a longer password.');
    expect(gateway.calls, isEmpty);

    await type(tester, 'account-password', 'long enough');
    await tapKey(tester, 'account-create');
    expect(gateway.calls, ['create me@example.com']);
    expect(find.text('Signed in as me@example.com'), findsOneWidget);
    expect(find.textContaining('Signing out deletes nothing'), findsOneWidget);
  });

  testWidgets('a wrong password is explained; a reset link can be asked for', (
    tester,
  ) async {
    final gateway = FakeAuthGateway()
      ..failWith = const AccountException(AccountError.wrongCredentials);
    await open(tester, gateway: gateway);
    await type(tester, 'account-email', 'me@example.com');
    await type(tester, 'account-password', 'whatever1');
    await tapKey(tester, 'account-sign-in');
    expect(message(tester), "That email and password don't match.");
    expect(shown('account-signed-in'), isFalse);

    gateway.failWith = null;
    await tapKey(tester, 'account-forgot');
    expect(gateway.calls.last, 'reset me@example.com');
    expect(message(tester), startsWith('If that email has an account'));
  });

  testWidgets('cancelling Google sign-in says nothing', (tester) async {
    final gateway = FakeAuthGateway()
      ..failWith = const AccountException(AccountError.cancelled);
    await open(tester, gateway: gateway);
    await tapKey(tester, 'account-google');
    expect(gateway.calls, ['google']);
    expect(shown('account-message'), isFalse);
  });

  testWidgets('Apple is offered on iOS only', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    try {
      final gateway = FakeAuthGateway();
      await open(tester, gateway: gateway);
      await tapKey(tester, 'account-apple');
      expect(find.text('Signed in with Apple'), findsOneWidget);
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });

  testWidgets('Apple is not offered on Android', (tester) async {
    await open(tester, gateway: FakeAuthGateway());
    expect(shown('account-apple'), isFalse);
    expect(shown('account-google'), isTrue);
  });

  testWidgets('sign out returns to the signed-out screen', (tester) async {
    final gateway = FakeAuthGateway(
      current: const AccountUser(
        uid: 'u1',
        email: 'g@example.com',
        method: SignInMethod.google,
      ),
    );
    await open(tester, gateway: gateway);
    await tapKey(tester, 'account-sign-out');
    expect(gateway.calls, ['signOut']);
    expect(shown('account-google'), isTrue);
  });

  testWidgets('deleting an email account asks for the password, explains the '
      '24-hour purge and keeps the phone data', (tester) async {
    final gateway = FakeAuthGateway(
      current: const AccountUser(
        uid: 'u1',
        email: 'me@example.com',
        method: SignInMethod.email,
      ),
    );
    await open(tester, gateway: gateway);
    await tapKey(tester, 'account-delete');
    expect(shown('account-delete-dialog'), isTrue);
    expect(find.textContaining('Within 24 hours'), findsOneWidget);
    expect(
      find.textContaining('Everything on this phone stays'),
      findsOneWidget,
    );

    // "Keep account" changes nothing.
    await tester.tap(find.text('Keep account'));
    await tester.pumpAndSettle();
    expect(gateway.calls, isEmpty);

    await tapKey(tester, 'account-delete');
    await tester.enterText(
      find.byKey(const ValueKey('account-delete-password')),
      'my password',
    );
    await tester.tap(find.byKey(const ValueKey('account-delete-confirm')));
    await tester.pumpAndSettle();
    expect(gateway.calls, ['delete']);
    expect(gateway.deletePassword, 'my password');
    expect(
      find.text(
        'Account deleted. Its server data will be gone within 24 '
        'hours.',
      ),
      findsOneWidget,
    );
    expect(shown('account-email'), isTrue);
  });

  testWidgets('a Google account is deleted without a password', (tester) async {
    final gateway = FakeAuthGateway(
      current: const AccountUser(
        uid: 'u1',
        email: 'g@example.com',
        method: SignInMethod.google,
      ),
    );
    await open(tester, gateway: gateway);
    await tapKey(tester, 'account-delete');
    expect(shown('account-delete-password'), isFalse);
    await tester.tap(find.byKey(const ValueKey('account-delete-confirm')));
    await tester.pumpAndSettle();
    expect(gateway.deletePassword, isNull);
  });

  group('rules', () {
    test('Firebase error codes map to messages the screen knows', () {
      expect(
        FirebaseAuthGateway.errorFor('invalid-credential'),
        AccountError.wrongCredentials,
      );
      expect(
        FirebaseAuthGateway.errorFor('email-already-in-use'),
        AccountError.emailInUse,
      );
      expect(
        FirebaseAuthGateway.errorFor('requires-recent-login'),
        AccountError.needsRecentSignIn,
      );
      expect(
        FirebaseAuthGateway.errorFor('web-context-cancelled'),
        AccountError.cancelled,
      );
      expect(
        FirebaseAuthGateway.errorFor('something-new'),
        AccountError.unknown,
      );
    });

    test('form checks', () {
      expect(AccountForm.validEmail(' me@example.com '), isTrue);
      expect(AccountForm.validEmail('me@example'), isFalse);
      expect(AccountForm.validPassword('1234567'), isFalse);
      expect(AccountForm.validPassword('12345678'), isTrue);
    });

    test('without Firebase every call is refused and the app stays signed '
        'out', () async {
      const gateway = UnavailableAuthGateway();
      expect(await gateway.userChanges().first, isNull);
      await expectLater(
        gateway.signInWithGoogle(),
        throwsA(
          isA<AccountException>().having(
            (e) => e.error,
            'error',
            AccountError.unavailable,
          ),
        ),
      );
    });
  });
}
