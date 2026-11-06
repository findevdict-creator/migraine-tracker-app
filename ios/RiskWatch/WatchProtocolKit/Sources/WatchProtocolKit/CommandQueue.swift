import Foundation

/// The watch's commands the phone has not acknowledged yet, oldest first.
public struct CommandQueue: Equatable {
    /// Mirrors `CommandQueue.maxLength` in the Dart package.
    public static let maxLength = 200

    public private(set) var pending: [WatchCommand]

    public init(_ pending: [WatchCommand] = []) {
        self.pending = pending
    }

    public var isEmpty: Bool { pending.isEmpty }

    public func adding(_ command: WatchCommand) -> CommandQueue {
        CommandQueue(Array((pending + [command]).suffix(CommandQueue.maxLength)))
    }

    public func acknowledging(_ acks: [String]) -> CommandQueue {
        let done = Set(acks)
        return CommandQueue(pending.filter { !done.contains($0.id) })
    }

    public var json: [[String: Any]] { pending.map { $0.json } }

    public init(json: Any?) {
        self.init((json as? [Any] ?? []).compactMap { WatchCommand(json: $0) })
    }
}
