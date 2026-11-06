import 'package:flutter/foundation.dart';
import 'package:migraine_tracker/config/app_config.dart';

/// How the person signed in.
enum SignInMethod { apple, google, email }

/// The signed-in account. The app keeps no health data on it: entries stay
/// on the phone (FR-23).
@immutable
class AccountUser {
  const AccountUser({required this.uid, this.email, this.method});

  final String uid;
  final String? email;
  final SignInMethod? method;

  @override
  bool operator ==(Object other) =>
      other is AccountUser &&
      other.uid == uid &&
      other.email == email &&
      other.method == method;

  @override
  int get hashCode => Object.hash(uid, email, method);
}

/// What can go wrong, in terms the screen can explain.
enum AccountError {
  cancelled,
  wrongCredentials,
  emailInUse,
  weakPassword,
  invalidEmail,
  network,
  needsRecentSignIn,
  unavailable,
  unknown,
}

class AccountException implements Exception {
  const AccountException(this.error);

  final AccountError error;

  @override
  String toString() => 'AccountException($error)';
}

/// Sign-in and account deletion. Implemented over Firebase Auth, and by a
/// stand-in when the build has no Firebase project.
abstract interface class AuthGateway {
  /// False when accounts cannot work in this build.
  bool get available;

  Stream<AccountUser?> userChanges();

  Future<void> signInWithApple();
  Future<void> signInWithGoogle();
  Future<void> signInWithEmail(String email, String password);
  Future<void> createAccount(String email, String password);
  Future<void> sendPasswordReset(String email);
  Future<void> signOut();

  /// Deletes the account after confirming it is really them: Apple and
  /// Google ask again, email needs [password]. The server then purges the
  /// backup and share links (functions/src/account).
  Future<void> deleteAccount({String? password});
}

/// Used when Firebase is not configured: signed out, every call refused.
class UnavailableAuthGateway implements AuthGateway {
  const UnavailableAuthGateway();

  static const _refused = AccountException(AccountError.unavailable);

  @override
  bool get available => false;

  @override
  Stream<AccountUser?> userChanges() => Stream.value(null);

  @override
  Future<void> signInWithApple() => Future.error(_refused);
  @override
  Future<void> signInWithGoogle() => Future.error(_refused);
  @override
  Future<void> signInWithEmail(String email, String password) =>
      Future.error(_refused);
  @override
  Future<void> createAccount(String email, String password) =>
      Future.error(_refused);
  @override
  Future<void> sendPasswordReset(String email) => Future.error(_refused);
  @override
  Future<void> signOut() async {}
  @override
  Future<void> deleteAccount({String? password}) => Future.error(_refused);
}

/// Checks run before anything is sent.
abstract final class AccountForm {
  static final _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static bool validEmail(String email) => _email.hasMatch(email.trim());

  static bool validPassword(String password) =>
      password.length >= AppAccounts.minPasswordLength;
}
