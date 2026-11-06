/// The fourteen factors the model scores. Ids are stored in the
/// `factor_weights` and `risk_days` tables and must never change.
enum Factor {
  /// Sea-level pressure falling over 24 h.
  pressureDrop('pressure_drop'),

  /// High relative humidity.
  humidity('humidity'),

  /// Large day-to-day temperature change.
  temperatureSwing('temperature_swing'),

  /// Poor air quality (US AQI).
  airQuality('air_quality'),

  /// High pollen.
  pollen('pollen'),

  /// Bright light or a high UV index.
  brightLight('bright_light'),

  /// Long screen time.
  screenTime('screen_time'),

  /// Poor or short sleep.
  poorSleep('poor_sleep'),

  /// High stress.
  stress('stress'),

  /// Neck tension.
  neckTension('neck_tension'),

  /// A lot of caffeine.
  caffeine('caffeine'),

  /// Alcohol.
  alcohol('alcohol'),

  /// Low hydration.
  dehydration('dehydration'),

  /// The days around the start of a period.
  cyclePhase('cycle_phase');

  Factor(this.id);

  /// Stable storage id.
  final String id;

  /// The factor with this [id], or null.
  static Factor? fromId(String id) {
    for (final f in values) {
      if (f.id == id) return f;
    }
    return null;
  }
}
