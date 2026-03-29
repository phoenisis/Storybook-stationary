import ProjectDescription

let project = Project(
    name: "Storybook stationary",
    packages: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.21.0"),
    ],
    targets: [
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
                "StorybookStationary/Sources/Shared/**",
                "StorybookStationary/Sources/iOS/**",
            ],
            resources: [
                "StorybookStationary/Resources/**",
            ],
            dependencies: [
                .package(product: "ComposableArchitecture"),
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
                .package(product: "ComposableArchitecture"),
            ]
        ),
    ]
)
