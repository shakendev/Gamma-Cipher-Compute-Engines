// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Subrosa Confidential",
    platforms: [
        .iOS(.v18),
        .macCatalyst(.v18),
        .macOS(.v15),
        .tvOS(.v18),
        .visionOS(.v2)
    ],
    products: [
        .library(
            name: "ConfidentialKit",
            targets: ["ConfidentialKit-Release"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "ConfidentialKit-Debug",
            path: "./XCFramework/ConfidentialKit-Debug.xcframework"
        ),
        .binaryTarget(
            name: "ConfidentialKit-Release",
            path: "./XCFramework/ConfidentialKit-Release.xcframework"
        )
    ],
    swiftLanguageModes: [.v6]
)
