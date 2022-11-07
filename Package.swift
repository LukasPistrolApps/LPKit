// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "LPKit",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8),
    ],
    products: [
        .library(
            name: "LPKit",
            targets: ["LPKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/lukepistrol/SwiftLintPlugin", from: "0.1.0"),
    ],
    targets: [
        .target(
            name: "LPKit",
            dependencies: []),
        .testTarget(
            name: "LPKitTests",
            dependencies: ["LPKit"]),
    ]
)
