import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/features/audit/application/self_audit_controller.dart';

/// Sends last month's audit counts on start and on resume, when the person
/// has turned sharing on. Does nothing otherwise.
class AuditMonthlySend extends ConsumerStatefulWidget {
  const AuditMonthlySend({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<AuditMonthlySend> createState() => _AuditMonthlySendState();
}

class _AuditMonthlySendState extends ConsumerState<AuditMonthlySend> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onResume: _send);
    _send();
  }

  void _send() => unawaited(ref.read(auditUploaderProvider).sendIfDue());

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
