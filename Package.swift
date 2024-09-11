// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ETDistribution",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "ETDistribution",
            type: .dynamic,
            targets: ["ETDistribution"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ETDistribution",
            dependencies: [],
            path: "ETDistribution"
        ),
    ]
)
