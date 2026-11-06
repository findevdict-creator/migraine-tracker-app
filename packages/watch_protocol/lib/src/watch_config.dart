/// Watch settings both the phone app and the Wear OS app read. This is the
/// one file to change for watch behaviour; the phone's
/// `lib/config/app_config.dart` points here (`AppWatch`).
abstract final class WatchConfig {
  /// How often the Wear OS tile asks for a redraw from the stored strings.
  /// Fresh strings arrive whenever the phone sends a state.
  static const Duration tileFreshness = Duration(minutes: 30);

  /// How often the watch resends unacknowledged commands while its app is
  /// open. Each send is cheap and the phone ignores ids it already applied.
  static const Duration resendEvery = Duration(seconds: 30);

  /// Method channel between the Wear OS Flutter code and its tile service.
  static const String tileChannel = 'app.migrainetracker/wear_tile';

  /// Shared-preferences keys (without Flutter's `flutter.` prefix) the
  /// Wear OS app writes and its tile reads. Mirrored in
  /// `wear/android/app/src/main/kotlin/.../RiskTileService.kt`.
  static const String tileLevelLabel = 'tile.levelLabel';

  /// The top-factor line.
  static const String tileHeadline = 'tile.headline';

  /// The pressure line.
  static const String tilePressure = 'tile.pressure';

  /// ARGB level colour as a decimal string, empty when none.
  static const String tileLevelColor = 'tile.levelColor';

  /// The watch's stored copy of the last phone state (JSON).
  static const String storedState = 'watch.state';

  /// The watch's unacknowledged commands (JSON).
  static const String storedQueue = 'watch.queue';
}
