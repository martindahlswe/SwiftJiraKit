// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "SwiftJiraKit",
    platforms: [
        .macOS(.v12), .iOS(.v14)
    ],
    products: [
        .library(
            name: "SwiftJiraKit",
            targets: ["SwiftJiraKit"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftJiraKit",
            dependencies: []),
        .testTarget(
            name: "SwiftJiraKitTests",
            dependencies: ["SwiftJiraKit"]),
    ]
)
