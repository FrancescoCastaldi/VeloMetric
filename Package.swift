// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VeloMetric",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "VeloMetric",
            targets: ["VeloMetric"]),
    ],
    targets: [
        .target(
            name: "VeloMetric",
            path: "src/VeloMetric"
        ),
    ]
)
