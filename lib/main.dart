import 'package:migraine_tracker/app/bootstrap.dart';
import 'package:migraine_tracker/config/app_config.dart';

/// Default entry point so a bare `flutter run` works. Runs the dev flavor;
/// release builds must use `main_prod.dart`.
Future<void> main() => bootstrap(AppFlavor.dev);
