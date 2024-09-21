// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Assertions",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
    ],
    products: [
        .library(
            name: "Assertions",
            targets: ["Assertions"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-custom-dump", from: "1.3.3")
    ],
    targets: [
        .target(
            name: "Assertions",
            dependencies: [
                .product(name: "CustomDump", package: "swift-custom-dump")
            ]
        ),
        .testTarget(
            name: "AssertionsTests",
            dependencies: ["Assertions"]
        )
    ]
)
