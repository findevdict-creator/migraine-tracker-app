import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/attack_log/data/attack_repository_impl.dart';
import 'package:migraine_tracker/features/notifications/application/notification_scheduler.dart';
import 'package:migraine_tracker/features/risk/application/risk_engine.dart';

/// What a tap or an action on a notification does. Shared by the
/// foreground callback and the background entry point.
abstract final class NotificationActions {
  /// "End attack" ends the attack named in the payload (if still
  /// running), re-learns and reschedules. A plain tap does nothing here:
  /// the app opens on home, where the running attack is one tap away.
  static Future<bool> handle(Ref ref, NotificationResponse response) async {
    if (response.actionId != AppNotificationChannels.endAttackAction) {
      return false;
    }
    final id = response.payload;
    if (id == null) return false;
    final repo = ref.read(attackRepositoryProvider);
    final attack = await repo.byId(id);
    if (attack == null || !attack.isRunning) return false;
    await repo.save(
      attack.copyWith(endedAt: ref.read(clockProvider)(), finishLater: false),
    );
    await relearnQuietly(ref);
    try {
      await ref.read(notificationSchedulerProvider).reschedule();
    } on Object catch (error) {
      debugPrint('reschedule after end-attack failed: $error');
    }
    return true;
  }
}
