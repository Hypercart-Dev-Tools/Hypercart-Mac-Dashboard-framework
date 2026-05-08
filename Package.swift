// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "HypercartMacOSDashboard",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "HypercartMacOSDashboard",
            targets: ["HypercartMacOSDashboard"]
        ),
        .library(
            name: "HypercartMacOSDashboardCore",
            targets: ["HypercartMacOSDashboardCore"]
        ),
        .library(
            name: "HypercartMacOSDashboardUI",
            targets: ["HypercartMacOSDashboardUI"]
        ),
        .executable(
            name: "HypercartMacOSDashboardDemo",
            targets: ["HypercartMacOSDashboardDemo"]
        )
    ],
    targets: [
        .target(
            name: "HypercartMacOSDashboard",
            dependencies: [
                "HypercartMacOSDashboardCore",
                "HypercartMacOSDashboardUI"
            ]
        ),
        .target(
            name: "HypercartMacOSDashboardCore"
        ),
        .target(
            name: "HypercartMacOSDashboardUI",
            dependencies: ["HypercartMacOSDashboardCore"]
        ),
        .executableTarget(
            name: "HypercartMacOSDashboardDemo",
            dependencies: [
                "HypercartMacOSDashboard"
            ]
        ),
        .testTarget(
            name: "HypercartMacOSDashboardCoreTests",
            dependencies: [
                "HypercartMacOSDashboardCore"
            ]
        )
    ]
)
