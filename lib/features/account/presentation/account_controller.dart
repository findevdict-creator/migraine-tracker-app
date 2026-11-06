import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/features/account/data/firebase_auth_gateway.dart';
import 'package:migraine_tracker/features/account/domain/account.dart';

/// The signed-in account, or null. Signed out is a normal, complete state.
final accountProvider = StreamProvider<AccountUser?>(
  (ref) => ref.watch(authGatewayProvider).userChanges(),
);
