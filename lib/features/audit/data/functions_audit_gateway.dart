import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/app/bootstrap.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/firebase/firebase_bootstrap.dart';
import 'package:migraine_tracker/features/audit/domain/audit_upload.dart';

final auditGatewayProvider = Provider<AuditGateway>((ref) {
  if (!ref.watch(firebaseStatusProvider).enabled) {
    return const UnavailableAuditGateway();
  }
  final flavor = ref.watch(appConfigProvider).flavor;
  return FunctionsAuditGateway(
    useEmulator: AppFeatureFlags.useEmulators(flavor),
  );
});

/// Calls `auditCounts`. No account is needed: the counts are not tied to
/// anyone. App Check covers the call.
class FunctionsAuditGateway implements AuditGateway {
  FunctionsAuditGateway({required bool useEmulator}) {
    final functions = FirebaseFunctions.instanceFor(
      region: AppEnv.functionsRegion,
    );
    if (useEmulator) functions.useFunctionsEmulator(AppEnv.emulatorHost, 5001);
    _call = functions.httpsCallable(
      AppEndpoints.auditCountsFunction,
      options: HttpsCallableOptions(timeout: const Duration(seconds: 30)),
    );
  }

  late final HttpsCallable _call;

  @override
  bool get available => true;

  @override
  Future<void> send(Map<String, Object> payload) async {
    await _call.call<Object?>(payload);
  }
}
