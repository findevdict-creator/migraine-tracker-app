import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/firebase/firebase_bootstrap.dart';
import 'package:migraine_tracker/features/account/domain/account.dart';

/// Firebase Auth when the build has a Firebase project, otherwise the
/// stand-in that keeps the app signed out.
final authGatewayProvider = Provider<AuthGateway>(
  (ref) => ref.watch(firebaseStatusProvider).enabled
      ? FirebaseAuthGateway()
      : const UnavailableAuthGateway(),
);

class FirebaseAuthGateway implements AuthGateway {
  FirebaseAuthGateway({FirebaseAuth? auth, GoogleSignIn? google})
    : _auth = auth ?? FirebaseAuth.instance,
      _google = google ?? GoogleSignIn.instance;

  final FirebaseAuth _auth;
  final GoogleSignIn _google;
  Future<void>? _googleReady;

  @override
  bool get available => true;

  @override
  Stream<AccountUser?> userChanges() => _auth.userChanges().map(
    (u) => u == null
        ? null
        : AccountUser(uid: u.uid, email: u.email, method: methodOf(u)),
  );

  static SignInMethod? methodOf(User user) {
    for (final info in user.providerData) {
      switch (info.providerId) {
        case 'apple.com':
          return SignInMethod.apple;
        case 'google.com':
          return SignInMethod.google;
        case 'password':
          return SignInMethod.email;
      }
    }
    return null;
  }

  @override
  Future<void> signInWithApple() =>
      _guard(() => _auth.signInWithProvider(AppleAuthProvider()));

  @override
  Future<void> signInWithGoogle() => _guard(() async {
    await _auth.signInWithCredential(await _googleCredential());
  });

  @override
  Future<void> signInWithEmail(String email, String password) => _guard(
    () => _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    ),
  );

  @override
  Future<void> createAccount(String email, String password) => _guard(
    () => _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    ),
  );

  @override
  Future<void> sendPasswordReset(String email) =>
      _guard(() => _auth.sendPasswordResetEmail(email: email.trim()));

  @override
  Future<void> signOut() async {
    final wasGoogle =
        _auth.currentUser != null &&
        methodOf(_auth.currentUser!) == SignInMethod.google;
    await _auth.signOut();
    if (wasGoogle) await _google.signOut();
  }

  @override
  Future<void> deleteAccount({String? password}) => _guard(() async {
    final user = _auth.currentUser;
    if (user == null) return;
    switch (methodOf(user)) {
      case SignInMethod.apple:
        // Apple requires the app to revoke its token when the account goes.
        final again = await user.reauthenticateWithProvider(
          AppleAuthProvider(),
        );
        final code = again.additionalUserInfo?.authorizationCode;
        if (code != null) await _auth.revokeTokenWithAuthorizationCode(code);
      case SignInMethod.google:
        await user.reauthenticateWithCredential(await _googleCredential());
      case SignInMethod.email:
        await user.reauthenticateWithCredential(
          EmailAuthProvider.credential(
            email: user.email ?? '',
            password: password ?? '',
          ),
        );
      case null:
        break;
    }
    final wasGoogle = methodOf(user) == SignInMethod.google;
    await user.delete();
    if (wasGoogle) await _google.signOut();
  });

  Future<OAuthCredential> _googleCredential() async {
    await (_googleReady ??= _google.initialize(
      clientId: AppEnv.googleIosClientId.isEmpty
          ? null
          : AppEnv.googleIosClientId,
      serverClientId: AppEnv.googleServerClientId.isEmpty
          ? null
          : AppEnv.googleServerClientId,
    ));
    final account = await _google.authenticate();
    return GoogleAuthProvider.credential(
      idToken: account.authentication.idToken,
    );
  }

  static Future<void> _guard(Future<void> Function() action) async {
    try {
      await action();
    } on FirebaseAuthException catch (e) {
      throw AccountException(errorFor(e.code));
    } on GoogleSignInException catch (e) {
      throw AccountException(
        e.code == GoogleSignInExceptionCode.canceled
            ? AccountError.cancelled
            : AccountError.unknown,
      );
    }
  }

  /// Firebase error codes to what the screen says.
  static AccountError errorFor(String code) => switch (code) {
    'user-not-found' ||
    'wrong-password' ||
    'invalid-credential' ||
    'invalid-login-credentials' => AccountError.wrongCredentials,
    'email-already-in-use' ||
    'account-exists-with-different-credential' => AccountError.emailInUse,
    'weak-password' => AccountError.weakPassword,
    'invalid-email' => AccountError.invalidEmail,
    'network-request-failed' => AccountError.network,
    'requires-recent-login' => AccountError.needsRecentSignIn,
    'canceled' ||
    'cancelled' ||
    'web-context-canceled' ||
    'web-context-cancelled' ||
    'user-cancelled' => AccountError.cancelled,
    _ => AccountError.unknown,
  };
}
