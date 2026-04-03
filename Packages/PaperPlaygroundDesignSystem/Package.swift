// swift-tools-version: 6.3
import PackageDescription

let package = Package(
    name: "PaperPlaygroundDesignSystem",
    platforms: [
        .iOS("26.0"),
        .macOS("26.0"),
    ],
    products: [
        .library(
            name: "PaperPlaygroundDesignSystem",
            targets: ["PaperPlaygroundDesignSystem"]
        ),
    ],
    targets: [
        .target(
            name: "PaperPlaygroundDesignSystem",
            swiftSettings: [
                .defaultIsolation(MainActor.self),
            ]
        ),
    ]
)
