import 'package:migraine_tracker/app/bootstrap.dart';
import 'package:migraine_tracker/config/app_config.dart';

/// Entry point for the prod flavor.
Future<void> main() => bootstrap(AppFlavor.prod);
