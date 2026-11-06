/// Button and status labels the watch shows. The phone sends them in its
/// language with every state; [WatchLabels.fallback] is used until the
/// first state arrives.
abstract final class WatchLabels {
  /// "Start attack".
  static const String start = 'start';

  /// "End attack".
  static const String stop = 'stop';

  /// "Intensity".
  static const String intensity = 'intensity';

  /// "Since {time}", with `{time}` replaced on the watch.
  static const String since = 'since';

  /// Shown while commands wait for the phone.
  static const String pending = 'pending';

  /// Shown before the phone has ever sent a state.
  static const String noPhone = 'noPhone';

  /// Every key, for completeness checks.
  static const List<String> keys = [
    start,
    stop,
    intensity,
    since,
    pending,
    noPhone,
  ];

  /// English labels for a watch that has not heard from the phone yet.
  static const Map<String, String> fallback = {
    start: 'Start attack',
    stop: 'End attack',
    intensity: 'Intensity',
    since: 'Since {time}',
    pending: 'Saved on the watch. Sends when your phone is near.',
    noPhone: 'Open the app on your phone once to connect the watch.',
  };

  /// [labels] with fallbacks filled in for missing keys.
  static Map<String, String> resolve(Map<String, String>? labels) => {
    ...fallback,
    ...?labels,
  };
}
