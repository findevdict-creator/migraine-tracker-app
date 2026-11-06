import 'dart:io' show Platform;

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/app/bootstrap.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/firebase/firebase_bootstrap.dart';
import 'package:migraine_tracker/features/push/domain/push_gateway.dart';

/// True on a phone with Firebase configured and the feature on.
bool pushAvailable(FirebaseStatus status) =>
    AppFeatureFlags.pushWakeupAvailable &&
    status.enabled &&
    !kIsWeb &&
    (Platform.isAndroid || Platform.isIOS);

final pushGatewayProvider = Provider<PushGateway>((ref) {
  final status = ref.watch(firebaseStatusProvider);
  if (!pushAvailable(status)) return const NoPushGateway();
  return FirebasePushGateway();
});

final pushTokenRegistryProvider = Provider<PushTokenRegistry>((ref) {
  final status = ref.watch(firebaseStatusProvider);
  if (!pushAvailable(status)) return const NoPushTokenRegistry();
  final config = ref.watch(appConfigProvider);
  return FunctionsPushTokenRegistry(useEmulator: config.useEmulators);
});

/// The platform name the server stores.
String get pushPlatformName => Platform.isIOS ? 'ios' : 'android';

/// Firebase Messaging. Permission is never requested here: silent pushes
/// need none on either platform, and the alert permission belongs to the
/// local notifications (phase 21).
class FirebasePushGateway implements PushGateway {
  FirebasePushGateway({FirebaseMessaging? messaging})
    : _messaging = messaging ?? FirebaseMessaging.instance;

  final FirebaseMessaging _messaging;

  // The server targets registration tokens with sendEachForMulticast, so
  // the token API stays in use; the installation-id API (register /
  // onRegistered) is for direct-send, which firebase-admin does not take.
  @override
  Future<String?> token() async {
    try {
      // ignore: deprecated_member_use, see above
      return await _messaging.getToken();
    } on Object catch (error) {
      // iOS before the APNs token arrives, or no Google services.
      debugPrint('push token unavailable: $error');
      return null;
    }
  }

  @override
  // ignore: deprecated_member_use, see above
  Stream<String> get tokenRefreshes => _messaging.onTokenRefresh;

  @override
  Stream<Map<String, String>> get foregroundMessages => FirebaseMessaging
      .onMessage
      .map((m) => {for (final e in m.data.entries) e.key: e.value.toString()});
}

/// Calls `registerPushToken`. App Check covers the call; no account.
class FunctionsPushTokenRegistry implements PushTokenRegistry {
  FunctionsPushTokenRegistry({required bool useEmulator}) {
    final functions = FirebaseFunctions.instanceFor(
      region: AppEnv.functionsRegion,
    );
    if (useEmulator) {
      functions.useFunctionsEmulator(AppEnv.emulatorHost, 5001);
    }
    _callable = functions.httpsCallable(
      AppEndpoints.registerPushTokenFunction,
      options: HttpsCallableOptions(timeout: const Duration(seconds: 15)),
    );
  }

  late final HttpsCallable _callable;

  @override
  Future<void> register({
    required String token,
    required String platform,
  }) async {
    await _callable.call<Object?>({'token': token, 'platform': platform});
  }
}
