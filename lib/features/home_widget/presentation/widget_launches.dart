import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/app/router.dart';
import 'package:migraine_tracker/features/attack_log/data/attack_repository_impl.dart';
import 'package:migraine_tracker/features/attack_log/presentation/attack_log_controller.dart';
import 'package:migraine_tracker/features/home_widget/data/home_widget_gateway.dart';
import 'package:migraine_tracker/features/home_widget/domain/widget_snapshot.dart';

/// Turns widget taps into app actions: the start button starts an attack
/// (or opens the running one) and lands on the attack screen.
class HomeWidgetLaunches extends ConsumerStatefulWidget {
  const HomeWidgetLaunches({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<HomeWidgetLaunches> createState() => _HomeWidgetLaunchesState();
}

class _HomeWidgetLaunchesState extends ConsumerState<HomeWidgetLaunches> {
  StreamSubscription<Uri?>? _taps;

  @override
  void initState() {
    super.initState();
    final gateway = ref.read(homeWidgetGatewayProvider);
    final handler = ref.read(widgetLaunchHandlerProvider);
    _taps = gateway.launches.listen((uri) => unawaited(handler.handle(uri)));
    unawaited(gateway.initialLaunch().then(handler.handle));
  }

  @override
  void dispose() {
    unawaited(_taps?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

final widgetLaunchHandlerProvider = Provider<WidgetLaunchHandler>(
  WidgetLaunchHandler.new,
);

class WidgetLaunchHandler {
  WidgetLaunchHandler(this._ref);

  final Ref _ref;
  bool _busy = false;

  /// Returns the attack id it opened, or null when the link asked for
  /// nothing more than opening the app.
  Future<String?> handle(Uri? uri) async {
    if (WidgetLink.parse(uri) != WidgetAction.startAttack || _busy) {
      return null;
    }
    _busy = true;
    try {
      final running = await _ref.read(attackRepositoryProvider).running();
      final id = running?.id ?? await _ref.read(attackStarterProvider).start();
      unawaited(_ref.read(routerProvider).push(AppRoutes.attack(id)));
      return id;
    } on Object catch (error) {
      debugPrint('widget start-attack failed: $error');
      return null;
    } finally {
      _busy = false;
    }
  }
}
