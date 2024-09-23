// swift-tools-version: 5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Flutterapp Packages",
    platforms: [
        // Minimum platform version
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "Libcore",
            targets: ["Libcore"]),
    ],
    dependencies: [
        // No dependencies
    ],
    targets: [
        .binaryTarget(
            name: "Libcore",
            path: "../XCFrameworks/Libcore.xcframework"
        )
    ]
)
