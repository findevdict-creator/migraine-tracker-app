import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/settings/settings_keys.dart';
import 'package:migraine_tracker/core/settings/settings_repository.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/push/application/push_wakeup.dart';
import 'package:migraine_tracker/features/push/data/firebase_push_gateway.dart';
import 'package:migraine_tracker/features/push/domain/push_gateway.dart';

final pushRegistrarProvider = Provider<PushRegistrar>(PushRegistrar.new);

/// Keeps the server's copy of this device's token current and routes
/// foreground wake-ups. Token registration needs no account: the token is
/// the only thing sent, and the server keeps nothing else about the device.
class PushRegistrar {
  PushRegistrar(this._ref, {String? platform})
    : _platform = platform ?? pushPlatformName;

  final Ref _ref;
  final String _platform;

  PushGateway get _gateway => _ref.read(pushGatewayProvider);
  PushTokenRegistry get _registry => _ref.read(pushTokenRegistryProvider);
  SettingsRepository get _settings => _ref.read(settingsRepositoryProvider);
  DateTime get _now => _ref.read(clockProvider)();

  /// Registers the token when it changed or the last registration is
  /// older than [AppThresholds.pushTokenRefresh]. Returns true when a
  /// call to the server was made.
  Future<bool> ensureRegistered() async {
    final token = await _gateway.token();
    if (token == null) return false;
    return await _register(token, force: false);
  }

  Future<bool> _register(String token, {required bool force}) async {
    final stored = await _settings.read<String>(SettingsKeys.pushToken);
    final raw = await _settings.read<String>(
      SettingsKeys.pushTokenRegisteredAt,
    );
    final registeredAt = raw == null ? null : DateTime.tryParse(raw);
    final now = _now;
    final fresh =
        !force &&
        stored == token &&
        registeredAt != null &&
        now.difference(registeredAt) < AppThresholds.pushTokenRefresh;
    if (fresh) return false;
    try {
      await _registry.register(token: token, platform: _platform);
    } on Object catch (error) {
      debugPrint('push token registration failed: $error');
      return false;
    }
    await _settings.write(SettingsKeys.pushToken, token);
    await _settings.write(
      SettingsKeys.pushTokenRegisteredAt,
      now.toIso8601String(),
    );
    return true;
  }

  /// Registers now, then follows token rotations and foreground wake-ups
  /// until the returned handle is disposed.
  PushSubscriptions start() {
    unawaited(
      ensureRegistered().catchError((Object error) {
        debugPrint('push registration failed: $error');
        return false;
      }),
    );
    return PushSubscriptions._(
      _gateway.tokenRefreshes.listen(
        (token) => unawaited(_register(token, force: true)),
        onError: (Object error) => debugPrint('token refresh error: $error'),
      ),
      _gateway.foregroundMessages.listen((data) {
        if (PushWakeup.isWakeup(data)) unawaited(PushWakeup.run(_ref));
      }, onError: (Object error) => debugPrint('push message error: $error')),
    );
  }
}

/// The registrar's stream subscriptions; dispose with the app.
class PushSubscriptions {
  PushSubscriptions._(this._tokens, this._messages);

  final StreamSubscription<String> _tokens;
  final StreamSubscription<Map<String, String>> _messages;

  Future<void> dispose() async {
    await _tokens.cancel();
    await _messages.cancel();
  }
}
