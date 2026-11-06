import Combine
import Foundation
import WatchConnectivity
import WatchProtocolKit
import WidgetKit

/// Holds what the watch shows and turns taps into queued commands that are
/// sent to the phone until it acknowledges them. Same behaviour as the
/// Wear OS app's WatchController.
final class WatchStore: NSObject, ObservableObject, WCSessionDelegate {
    @Published private(set) var view: WatchView

    private var state: WatchState?
    private var queue: CommandQueue
    private let storage = WatchStorage()
    private var timer: Timer?

    override init() {
        state = storage.loadState()
        queue = storage.loadQueue()
        view = WatchView(state: state, queue: queue)
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
        timer = Timer.scheduledTimer(
            withTimeInterval: WatchConfig.resendEvery, repeats: true
        ) { [weak self] _ in
            self?.send()
        }
    }

    func startAttack() { add(.start) }

    func endAttack() { add(.stop) }

    func setIntensity(_ value: Int) { add(.intensity, intensity: value) }

    private func add(_ type: WatchCommandType, intensity: Int? = nil) {
        let command = WatchCommand(
            id: UUID().uuidString, type: type, at: Date(), intensity: intensity)
        queue = queue.adding(command)
        storage.save(queue)
        refresh()
        send()
    }

    private func refresh() {
        view = WatchView(state: state, queue: queue)
    }

    /// Sends the whole unacknowledged queue: as the application context so
    /// a closed phone app finds it on open, and as a message when the phone
    /// is reachable. The phone applies each id once.
    private func send() {
        guard !queue.isEmpty, WCSession.isSupported() else { return }
        let session = WCSession.default
        guard session.activationState == .activated else { return }
        let wire = WatchWire.wrap(WatchCommand.batchJSON(queue.pending))
        try? session.updateApplicationContext(wire)
        if session.isReachable {
            session.sendMessage(wire, replyHandler: nil, errorHandler: nil)
        }
    }

    private func receive(_ payload: [String: Any]) {
        guard let incoming = WatchState(json: WatchWire.unwrap(payload)) else { return }
        // An older state arriving late never replaces a newer one.
        if let current = state, incoming.sentAt < current.sentAt { return }
        state = incoming
        queue = queue.acknowledging(incoming.acks)
        storage.save(incoming)
        storage.save(queue)
        refresh()
        WidgetCenter.shared.reloadAllTimelines()
    }

    // MARK: WCSessionDelegate (called off the main thread)

    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
        let context = session.receivedApplicationContext
        DispatchQueue.main.async {
            if !context.isEmpty { self.receive(context) }
            self.send()
        }
    }

    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        DispatchQueue.main.async { self.receive(applicationContext) }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        DispatchQueue.main.async { self.receive(message) }
    }

    func sessionReachabilityDidChange(_ session: WCSession) {
        DispatchQueue.main.async { self.send() }
    }
}
