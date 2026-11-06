import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/features/weather/application/weather_sync.dart';

/// Re-runs the foreground weather refresh when the app returns to the
/// foreground. The refresh itself returns early while the cache is within
/// the configured window, so this is cheap.
class WeatherRefreshOnResume extends ConsumerStatefulWidget {
  const WeatherRefreshOnResume({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<WeatherRefreshOnResume> createState() =>
      _WeatherRefreshOnResumeState();
}

class _WeatherRefreshOnResumeState extends ConsumerState<WeatherRefreshOnResume>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(weatherRefreshProvider);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
