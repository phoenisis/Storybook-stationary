import ProjectDescription

let project = Project(
    name: "Storybook stationary",
    packages: [
        .package(path: "Packages/PaperPlaygroundDesignSystem"),
        .package(url: "https://github.com/pointfreeco/swift-case-paths", from: "1.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.21.0"),
        .package(url: "https://github.com/pointfreeco/swift-navigation", from: "2.0.0"),
    ],
    targets: [
        .target(
            name: "StorybookShowcase-iOS",
            destinations: .iOS,
            product: .app,
            bundleId: "com.storybookstationary.showcase.ios",
            deploymentTargets: .iOS("26.0"),
            infoPlist: .extendingDefault(with: [
                "UILaunchScreen": .dictionary([:]),
                "UIDeviceFamily": .array([
                    .integer(1),
                    .integer(2),
                ]),
            ]),
            sources: [
                "StorybookShowcase/Sources/Shared/**",
                "StorybookShowcase/Sources/iOS/**",
            ],
            resources: [
                "StorybookShowcase/Resources/**",
            ],
            dependencies: [
                .package(product: "PaperPlaygroundDesignSystem"),
                .package(product: "ComposableArchitecture"),
                .package(product: "CasePaths"),
                .package(product: "SwiftUINavigation"),
            ]
        ),
        .target(
            name: "StorybookStationary-iOS",
            destinations: .iOS,
            product: .app,
            bundleId: "com.storybookstationary.ios",
            deploymentTargets: .iOS("26.0"),
            infoPlist: .extendingDefault(with: [
                "UILaunchScreen": .dictionary([:]),
                "UIDeviceFamily": .array([
                    .integer(1), // iPhone
                    .integer(2), // iPad
                ]),
            ]),
            sources: [
                "StorybookShowcase/Sources/Shared/**",
                "StorybookStationary/Sources/Shared/**",
                "StorybookStationary/Sources/iOS/**",
            ],
            resources: [
                "StorybookStationary/Resources/**",
            ],
            dependencies: [
                .package(product: "PaperPlaygroundDesignSystem"),
                .package(product: "ComposableArchitecture"),
                .package(product: "CasePaths"),
                .package(product: "SwiftUINavigation"),
            ]
        ),
        .target(
            name: "StorybookStationary-macOS",
            destinations: .macOS,
            product: .app,
            bundleId: "com.storybookstationary.macos",
            deploymentTargets: .macOS("26.0"),
            infoPlist: .extendingDefault(with: [:]),
            sources: [
                "StorybookStationary/Sources/Shared/**",
                "StorybookStationary/Sources/macOS/**",
            ],
            resources: [
                "StorybookStationary/Resources/**",
            ],
            dependencies: [
                .package(product: "PaperPlaygroundDesignSystem"),
                .package(product: "ComposableArchitecture"),
            ]
        ),
    ]
)
