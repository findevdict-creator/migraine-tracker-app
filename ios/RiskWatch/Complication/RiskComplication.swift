import SwiftUI
import WatchProtocolKit
import WidgetKit

/// Today's level on the watch face, from the state the watch app stored.
struct RiskEntry: TimelineEntry {
    let date: Date
    let state: WatchState?
}

struct RiskProvider: TimelineProvider {
    func placeholder(in context: Context) -> RiskEntry {
        RiskEntry(date: Date(), state: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (RiskEntry) -> Void) {
        completion(RiskEntry(date: Date(), state: WatchStorage().loadState()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<RiskEntry>) -> Void) {
        let now = Date()
        let entry = RiskEntry(date: now, state: WatchStorage().loadState())
        let next = now.addingTimeInterval(WatchConfig.complicationRefresh)
        completion(Timeline(entries: [entry], policy: .after(next)))
    }
}

struct RiskComplicationView: View {
    @Environment(\.widgetFamily) private var family
    let entry: RiskEntry

    private var label: String {
        let text = entry.state?.levelLabel ?? ""
        return text.isEmpty ? "–" : text
    }

    /// 1, 2 or 3 for low, moderate and high; 0 before any level.
    private var step: Double {
        switch entry.state?.level {
        case "low": return 1
        case "moderate": return 2
        case "high": return 3
        default: return 0
        }
    }

    var body: some View {
        switch family {
        case .accessoryInline:
            Text(label)
        case .accessoryCircular, .accessoryCorner:
            Gauge(value: step, in: 0...3) {
                Image(systemName: "cloud.bolt")
            }
            .gaugeStyle(.accessoryCircularCapacity)
            .tint(color(entry.state?.levelColor) ?? .gray)
            .accessibilityLabel(label)
        default:
            VStack(alignment: .leading) {
                Text(label).font(.headline)
                Text(entry.state?.pressure ?? "").font(.caption)
            }
        }
    }
}

@main
struct RiskComplication: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: WatchConfig.complicationKind, provider: RiskProvider()) { entry in
            RiskComplicationView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Migraine level")
        .description("Today's level and pressure trend")
        .supportedFamilies([
            .accessoryCircular, .accessoryCorner, .accessoryRectangular, .accessoryInline,
        ])
    }
}

/// Same colour helper as the app.
func color(_ argb: UInt32?) -> Color? {
    guard let argb = argb else { return nil }
    return Color(
        .sRGB,
        red: Double((argb >> 16) & 0xFF) / 255,
        green: Double((argb >> 8) & 0xFF) / 255,
        blue: Double(argb & 0xFF) / 255,
        opacity: Double((argb >> 24) & 0xFF) / 255)
}
