import Foundation
import XCTest
@testable import WatchProtocolKit

/// Decodes the Dart package's fixtures (packages/watch_protocol/test/
/// fixtures), the contract between the phone and the Apple Watch.
final class WatchProtocolKitTests: XCTestCase {
    private func fixture(_ name: String) throws -> [String: Any] {
        var root = URL(fileURLWithPath: #filePath)
        for _ in 0..<6 { root.deleteLastPathComponent() }
        let url = root.appendingPathComponent("packages/watch_protocol/test/fixtures/\(name)")
        let data = try Data(contentsOf: url)
        return try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: Any])
    }

    private func wire(_ json: [String: Any]) throws -> [String: Any] {
        let data = try JSONSerialization.data(withJSONObject: json)
        return [WatchWire.payloadKey: try XCTUnwrap(String(data: data, encoding: .utf8))]
    }

    func testStateFixtureDecodesAndReencodes() throws {
        let json = try fixture("state.json")
        let state = try XCTUnwrap(WatchState(json: WatchWire.unwrap(try wire(json))))
        XCTAssertEqual(state.levelColor, 0xFFEF_9A9A)
        XCTAssertEqual(state.accentColor, 0xFF5B_5BD6)
        XCTAssertEqual(state.levelLabel, "Level: High")
        XCTAssertEqual(state.attack?.intensity, 6)
        XCTAssertEqual(state.acks, ["w1", "w2"])
        XCTAssertEqual(Set(state.labels.keys), Set(WatchLabels.fallback.keys))

        var encoded = state.json
        encoded["v"] = WatchWire.version
        XCTAssertEqual(NSDictionary(dictionary: encoded), NSDictionary(dictionary: json))
    }

    func testCommandsFixtureDecodesAndReencodes() throws {
        let json = try fixture("commands.json")
        let commands = WatchCommand.batch(from: json)
        XCTAssertEqual(commands.map { $0.type }, [.start, .intensity, .stop])
        XCTAssertEqual(commands[1].intensity, 6)

        var encoded = WatchCommand.batchJSON(commands)
        encoded["v"] = WatchWire.version
        XCTAssertEqual(NSDictionary(dictionary: encoded), NSDictionary(dictionary: json))
    }

    func testWireRefusesForeignAndNewerPayloads() throws {
        XCTAssertNil(WatchWire.unwrap(nil))
        XCTAssertNil(WatchWire.unwrap(["other": "x"]))
        XCTAssertNil(WatchWire.unwrap([WatchWire.payloadKey: "{not json"]))
        XCTAssertNil(WatchWire.unwrap(try wire(["v": WatchWire.version + 1])))
        let wrapped = WatchWire.wrap(["a": 1])
        XCTAssertEqual(WatchWire.unwrap(wrapped)?["a"] as? Int, 1)
    }

    func testMalformedCommandsAreDropped() {
        let good: [String: Any] = ["id": "ok", "type": "start", "at": "2026-11-06T09:00:00Z"]
        var noIntensity = good
        noIntensity["type"] = "intensity"
        var badType = good
        badType["type"] = "dance"
        let batch = WatchCommand.batch(from: ["commands": [good, "x", noIntensity, badType]])
        XCTAssertEqual(batch.map { $0.id }, ["ok"])
        XCTAssertEqual(
            WatchCommand(id: "i", type: .intensity, at: Date(), intensity: 14).intensity, 10)
    }

    func testViewAppliesPendingCommandsOnTopOfThePhoneState() {
        let t0 = Date(timeIntervalSince1970: 1_793_000_000)
        let queue = CommandQueue()
            .adding(WatchCommand(id: "s", type: .start, at: t0))
            .adding(WatchCommand(id: "i", type: .intensity, at: t0, intensity: 8))
        let offline = WatchView(state: nil, queue: queue)
        XCTAssertTrue(offline.running)
        XCTAssertEqual(offline.attack?.intensity, 8)
        XCTAssertEqual(offline.pendingCount, 2)
        XCTAssertEqual(offline.label(WatchLabels.start), "Start attack")

        let phone = WatchState(
            sentAt: t0,
            attack: WatchAttack(startedAt: t0, intensity: 8),
            labels: [WatchLabels.start: "Anfall starten"],
            acks: ["s", "i"])
        let synced = WatchView(state: phone, queue: queue.acknowledging(phone.acks))
        XCTAssertEqual(synced.pendingCount, 0)
        XCTAssertEqual(synced.label(WatchLabels.start), "Anfall starten")

        let stopped = WatchView(
            state: phone, queue: CommandQueue().adding(WatchCommand(id: "x", type: .stop, at: t0)))
        XCTAssertFalse(stopped.running)
    }

    func testStorageRoundTripsStateAndQueue() throws {
        let defaults = try XCTUnwrap(UserDefaults(suiteName: "watch-protocol-tests"))
        defaults.removePersistentDomain(forName: "watch-protocol-tests")
        let storage = WatchStorage(defaults: defaults)
        XCTAssertNil(storage.loadState())
        XCTAssertTrue(storage.loadQueue().isEmpty)

        let t0 = Date(timeIntervalSince1970: 1_793_000_000)
        let state = WatchState(sentAt: t0, levelLabel: "Level: Low", levelColor: 0xFF81_C784)
        let queue = CommandQueue().adding(WatchCommand(id: "a", type: .stop, at: t0))
        storage.save(state)
        storage.save(queue)
        XCTAssertEqual(storage.loadState(), state)
        XCTAssertEqual(storage.loadQueue(), queue)
    }

    func testQueueKeepsTheNewestCommandsPastTheCap() {
        var queue = CommandQueue()
        for i in 0..<(CommandQueue.maxLength + 5) {
            queue = queue.adding(WatchCommand(id: "\(i)", type: .start, at: Date()))
        }
        XCTAssertEqual(queue.pending.count, CommandQueue.maxLength)
        XCTAssertEqual(queue.pending.first?.id, "5")
    }
}
