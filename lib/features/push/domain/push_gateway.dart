/// The push layer the app talks to. One implementation wraps Firebase
/// Messaging; one does nothing (desktop, tests, no Firebase).
abstract interface class PushGateway {
  /// The device token, or null when none can be had yet (no APNs token on
  /// iOS, no Google services, permission refused).
  Future<String?> token();

  /// New tokens as the platform rotates them.
  Stream<String> get tokenRefreshes;

  /// `data` of messages that arrive while the app is in the foreground.
  Stream<Map<String, String>> get foregroundMessages;
}

/// Sends the token to the server (the `registerPushToken` function).
abstract interface class PushTokenRegistry {
  Future<void> register({required String token, required String platform});
}

class NoPushGateway implements PushGateway {
  const NoPushGateway();

  @override
  Future<String?> token() async => null;

  @override
  Stream<String> get tokenRefreshes => const Stream.empty();

  @override
  Stream<Map<String, String>> get foregroundMessages => const Stream.empty();
}

class NoPushTokenRegistry implements PushTokenRegistry {
  const NoPushTokenRegistry();

  @override
  Future<void> register({
    required String token,
    required String platform,
  }) async {}
}
