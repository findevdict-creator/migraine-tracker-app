// swift-tools-version:5.9
// Swift side of packages/watch_protocol. The tests decode the Dart
// package's fixtures, so the two cannot drift apart unnoticed.
import PackageDescription

let package = Package(
    name: "WatchProtocolKit",
    platforms: [.watchOS(.v10), .iOS(.v17), .macOS(.v13)],
    products: [
        .library(name: "WatchProtocolKit", targets: ["WatchProtocolKit"]),
    ],
    targets: [
        .target(name: "WatchProtocolKit"),
        .testTarget(
            name: "WatchProtocolKitTests",
            dependencies: ["WatchProtocolKit"]
        ),
    ]
)
