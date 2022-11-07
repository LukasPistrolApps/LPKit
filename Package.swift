// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "LPKit",
    products: [
        .library(
            name: "LPKit",
            targets: ["LPKit"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "LPKit",
            dependencies: []),
        .testTarget(
            name: "LPKitTests",
            dependencies: ["LPKit"]),
    ]
)
