import Foundation

/// The phone's last state with the commands still waiting for the phone
/// applied on top. Mirrors `WatchView` in the Dart package.
public struct WatchView: Equatable {
    public let state: WatchState?
    public let attack: WatchAttack?
    public let pendingCount: Int
    public let labels: [String: String]

    public init(state: WatchState?, queue: CommandQueue) {
        let acked = Set(state?.acks ?? [])
        var attack = state?.attack
        var count = 0
        for command in queue.pending where !acked.contains(command.id) {
            count += 1
            switch command.type {
            case .start:
                if attack == nil { attack = WatchAttack(startedAt: command.at) }
            case .stop:
                attack = nil
            case .intensity:
                if let current = attack {
                    attack = WatchAttack(
                        startedAt: current.startedAt, intensity: command.intensity)
                }
            }
        }
        self.state = state
        self.attack = attack
        self.pendingCount = count
        self.labels = WatchLabels.resolve(state?.labels)
    }

    public var hasPhone: Bool { state != nil }
    public var running: Bool { attack != nil }

    public func label(_ key: String) -> String {
        labels[key] ?? WatchLabels.fallback[key] ?? key
    }
}
