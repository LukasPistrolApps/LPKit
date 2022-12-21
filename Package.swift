// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "LPKit",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8),
        .macCatalyst(.v15),
    ],
    products: [
        .library(
            name: "LPNetworkManager",
            targets: ["LPNetworkManager"]),
        .library(
            name: "LPJSONPicker",
            targets: ["LPJSONPicker"]),
        .library(
            name: "LPDocumentPicker",
            targets: ["LPDocumentPicker"]),
        .library(
            name: "LPPicker",
            targets: ["LPPicker"]),
        .library(
            name: "LPFlowLayout",
            targets: ["LPFlowLayout"]),
        .library(
            name: "Acknowledgements",
            targets: ["Acknowledgements"]),
    ],
    dependencies: [
        .package(url: "https://github.com/lukepistrol/SwiftLintPlugin", from: "0.1.0"),
    ],
    targets: [
        .target(
            name: "LPNetworkManager",
            dependencies: [],
            plugins: [
                .plugin(name: "SwiftLint", package: "SwiftLintPlugin")
            ]),
        .target(
            name: "LPJSONPicker",
            dependencies: [],
            plugins: [
                .plugin(name: "SwiftLint", package: "SwiftLintPlugin")
            ]),
        .target(
            name: "LPDocumentPicker",
            dependencies: [],
            plugins: [
                .plugin(name: "SwiftLint", package: "SwiftLintPlugin")
            ]),
        .target(
            name: "LPPicker",
            dependencies: [],
            plugins: [
                .plugin(name: "SwiftLint", package: "SwiftLintPlugin")
            ]),
        .target(
            name: "LPFlowLayout",
            dependencies: [],
            plugins: [
                .plugin(name: "SwiftLint", package: "SwiftLintPlugin")
            ]),
        .target(
            name: "Acknowledgements",
            dependencies: [],
            plugins: [
                .plugin(name: "SwiftLint", package: "SwiftLintPlugin")
            ]),

        .testTarget(
            name: "LPNetworkManagerTests",
            dependencies: ["LPNetworkManager"]),
        .testTarget(
            name: "AcknowledgementsTests",
            dependencies: ["Acknowledgements"],
            resources: [.copy("Resources/Test.resolved")]),
    ]
)
