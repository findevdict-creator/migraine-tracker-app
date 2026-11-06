import SwiftUI
import WatchProtocolKit

/// One scrolling column: the level, then either the start button or the
/// running attack with intensity and end.
struct ContentView: View {
    @EnvironmentObject private var store: WatchStore

    var body: some View {
        let current = store.view
        ScrollView {
            VStack(spacing: 8) {
                if let state = current.state {
                    Text(state.levelLabel)
                        .font(.headline)
                        .foregroundStyle(color(state.levelColor) ?? .primary)
                        .multilineTextAlignment(.center)
                    if current.attack == nil {
                        Text(state.headline)
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                        Text(state.pressure)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                } else {
                    Text(current.label(WatchLabels.noPhone))
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                }

                if let attack = current.attack {
                    Text(
                        current.label(WatchLabels.since).replacingOccurrences(
                            of: "{time}",
                            with: attack.startedAt.formatted(date: .omitted, time: .shortened)))
                    IntensityPicker(
                        label: current.label(WatchLabels.intensity),
                        value: attack.intensity
                    ) { store.setIntensity($0) }
                    Button(current.label(WatchLabels.stop)) { store.endAttack() }
                } else {
                    Button(current.label(WatchLabels.start)) { store.startAttack() }
                        .buttonStyle(.borderedProminent)
                        .tint(color(current.state?.accentColor) ?? .accentColor)
                }

                if current.pendingCount > 0 {
                    Text(current.label(WatchLabels.pending))
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
        }
    }
}

/// 0 to 10 with minus and plus buttons; empty until the first tap.
struct IntensityPicker: View {
    let label: String
    let value: Int?
    let onChange: (Int) -> Void

    var body: some View {
        VStack(spacing: 2) {
            Text(label).font(.caption2)
            HStack {
                Button {
                    onChange(max((value ?? 1) - 1, 0))
                } label: {
                    Image(systemName: "minus")
                }
                .disabled(value == 0)
                Text(value.map { String($0) } ?? "–")
                    .font(.title3)
                    .frame(minWidth: 32)
                    .accessibilityLabel(label)
                Button {
                    onChange(min((value ?? 0) + 1, 10))
                } label: {
                    Image(systemName: "plus")
                }
                .disabled(value == 10)
            }
        }
    }
}

/// A colour from the 32-bit ARGB value the phone sends.
func color(_ argb: UInt32?) -> Color? {
    guard let argb = argb else { return nil }
    return Color(
        .sRGB,
        red: Double((argb >> 16) & 0xFF) / 255,
        green: Double((argb >> 8) & 0xFF) / 255,
        blue: Double(argb & 0xFF) / 255,
        opacity: Double((argb >> 24) & 0xFF) / 255)
}
