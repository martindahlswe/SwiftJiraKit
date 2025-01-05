// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "SwiftJiraKit",
    platforms: [
        .macOS(.v14),
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "SwiftJiraKit",
            targets: ["SwiftJiraKit"]
        ),
    ],
    dependencies: [
        // Add the swift-log dependency
        .package(url: "https://github.com/apple/swift-log.git", from: "1.4.0"),
    ],
    targets: [
        .target(
            name: "SwiftJiraKit",
            dependencies: [
                .product(name: "Logging", package: "swift-log")
            ]
        ),
        .testTarget(
            name: "SwiftJiraKitTests",
            dependencies: ["SwiftJiraKit"]
        ),
    ]
)
