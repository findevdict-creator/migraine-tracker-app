import SwiftUI
import WidgetKit

// Home-screen widget (phase 26): today's level, top factor, pressure trend
// and a start-attack button. All text is written by the app
// (HomeWidgetSync) in the person's language; this file only draws it.
//
// Mirrors of lib/config/app_config.dart:
// - kind: AppHomeWidgets.iosKind
// - App Group: AppHomeWidgets.iosAppGroup
// - data keys: AppHomeWidgets.key*
// - start link: AppHomeWidgets.startAttackUri
// - refresh: AppThresholds.widgetRefresh (30 minutes)

private let appGroup = "group.app.aurawell.mobile"
private let startAttackURL = URL(string: "aurawell://widget/start-attack?homeWidget")!
private let refreshMinutes = 30

struct RiskEntry: TimelineEntry {
  let date: Date
  let level: String
  let levelLabel: String
  let headline: String
  let pressure: String
  let updated: String
  let startLabel: String

  static let placeholder = RiskEntry(
    date: Date(),
    level: "",
    levelLabel: "Open the app to load today's level",
    headline: "",
    pressure: "",
    updated: "",
    startLabel: "Start attack"
  )

  static func load() -> RiskEntry {
    let data = UserDefaults(suiteName: appGroup)
    func read(_ key: String, _ fallback: String) -> String {
      data?.string(forKey: key) ?? fallback
    }
    return RiskEntry(
      date: Date(),
      level: read("level", ""),
      levelLabel: read("levelLabel", placeholder.levelLabel),
      headline: read("headline", ""),
      pressure: read("pressure", ""),
      updated: read("updated", ""),
      startLabel: read("startLabel", placeholder.startLabel)
    )
  }
}

struct RiskProvider: TimelineProvider {
  func placeholder(in context: Context) -> RiskEntry { .placeholder }

  func getSnapshot(in context: Context, completion: @escaping (RiskEntry) -> Void) {
    completion(context.isPreview ? .placeholder : .load())
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<RiskEntry>) -> Void) {
    let next = Calendar.current.date(byAdding: .minute, value: refreshMinutes, to: Date())!
    completion(Timeline(entries: [.load()], policy: .after(next)))
  }
}

// Mirrors of AppThemeTokens.riskLow, riskModerate, riskHigh (light) and
// their *Dark variants.
private func levelColor(_ level: String, _ scheme: ColorScheme) -> Color {
  let dark = scheme == .dark
  switch level {
  case "high": return dark ? Color(red: 0.94, green: 0.60, blue: 0.60) : Color(red: 0.78, green: 0.16, blue: 0.16)
  case "moderate": return dark ? Color(red: 1.0, green: 0.72, blue: 0.30) : Color(red: 0.60, green: 0.36, blue: 0.0)
  case "low": return dark ? Color(red: 0.51, green: 0.78, blue: 0.52) : Color(red: 0.18, green: 0.49, blue: 0.20)
  default: return .primary
  }
}

struct RiskWidgetView: View {
  @Environment(\.colorScheme) var scheme
  var entry: RiskEntry

  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(entry.levelLabel)
        .font(.headline)
        .foregroundColor(levelColor(entry.level, scheme))
        .lineLimit(2)
      if !entry.headline.isEmpty {
        Text(entry.headline).font(.caption).lineLimit(1)
      }
      if !entry.pressure.isEmpty {
        Text(entry.pressure).font(.caption).lineLimit(1)
      }
      Spacer(minLength: 0)
      Link(destination: startAttackURL) {
        Text(entry.startLabel)
          .font(.subheadline.bold())
          .frame(maxWidth: .infinity, minHeight: 36)
          .foregroundColor(.white)
          .background(Color(red: 0.78, green: 0.16, blue: 0.16))
          .cornerRadius(10)
      }
      if !entry.updated.isEmpty {
        Text(entry.updated).font(.caption2).foregroundColor(.secondary)
      }
    }
    .widgetBackgroundCompat()
  }
}

private extension View {
  @ViewBuilder
  func widgetBackgroundCompat() -> some View {
    if #available(iOS 17.0, *) {
      containerBackground(.background, for: .widget)
    } else {
      padding()
    }
  }
}

@main
struct RiskWidget: Widget {
  let kind = "RiskWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: RiskProvider()) { entry in
      RiskWidgetView(entry: entry)
    }
    .configurationDisplayName("Aurawell")
    .description("Today's level, the pressure trend and a start-attack button")
    .supportedFamilies([.systemSmall, .systemMedium])
  }
}
