import SwiftUI

/// Apple Watch companion (phase 28): start and end an attack, set the
/// intensity, see today's level. Talks only to the phone.
@main
struct RiskWatchApp: App {
    @StateObject private var store = WatchStore()

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(store)
        }
    }
}
