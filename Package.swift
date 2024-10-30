// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "ViralTechSDK",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v15),
        .watchOS(.v6),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "ViralTech",
            targets: ["ViralTech"]),
    ],
    targets: [
        .target(
            name: "ViralTech"),
    ]
)
