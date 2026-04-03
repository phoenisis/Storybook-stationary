import ProjectDescription

let project = Project(
    name: "Storybook stationary",
    packages: [
        .package(path: "Packages/PaperPlaygroundDesignSystem"),
        .package(url: "https://github.com/pointfreeco/swift-case-paths", from: "1.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.21.0"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-identified-collections", from: "1.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-navigation", from: "2.0.0"),
        .package(url: "https://github.com/pointfreeco/sqlite-data", from: "1.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-structured-queries", from: "0.1.0"),
    ],
    settings: .settings(base: [
        "ENABLE_USER_SCRIPT_SANDBOXING": "YES",
        "STRING_CATALOG_GENERATE_SYMBOLS": "YES",
        "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "YES",
    ]),
    targets: [
        .target(
            name: "StorybookShowcase-iOS",
            destinations: .iOS,
            product: .app,
            bundleId: "com.storybookstationary.showcase.ios",
            deploymentTargets: .iOS("26.0"),
            infoPlist: .extendingDefault(with: [
                "UILaunchScreen": .dictionary([:]),
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
                .package(product: "Dependencies"),
                .package(product: "IdentifiedCollections"),
                .package(product: "SQLiteData"),
                .package(product: "StructuredQueries"),
                .package(product: "StructuredQueriesSQLite"),
                .package(product: "SwiftUINavigation"),
            ]
            settings: .settings(base: [
                "EXTRACT_APP_INTENTS_METADATA": "NO",
                "SWIFT_DEFAULT_ACTOR_ISOLATION": "MainActor",
                "ENABLE_USER_SCRIPT_SANDBOXING": "YES",
                "STRING_CATALOG_GENERATE_SYMBOLS": "YES",
                "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "YES",
            ])
        ),
        .target(
            name: "StorybookStationary-iOS",
            destinations: .iOS,
            product: .app,
            bundleId: "com.storybookstationary.ios",
            deploymentTargets: .iOS("26.0"),
            infoPlist: .extendingDefault(with: [
                "UILaunchScreen": .dictionary([:]),
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
                .package(product: "Dependencies"),
                .package(product: "IdentifiedCollections"),
                .package(product: "SQLiteData"),
                .package(product: "StructuredQueries"),
                .package(product: "StructuredQueriesSQLite"),
                .package(product: "SwiftUINavigation"),
            ],
            settings: .settings(base: [
                "EXTRACT_APP_INTENTS_METADATA": "NO",
                "SWIFT_DEFAULT_ACTOR_ISOLATION": "MainActor",
                "ENABLE_USER_SCRIPT_SANDBOXING": "YES",
                "STRING_CATALOG_GENERATE_SYMBOLS": "YES",
                "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "YES",
            ])
        ),
        .target(
            name: "StorybookStationary-iOSTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.storybookstationary.ios.tests",
            deploymentTargets: .iOS("26.0"),
            sources: [
                "StorybookStationary/Tests/**",
            ],
            dependencies: [
                .target(name: "StorybookStationary-iOS"),
                .package(product: "ComposableArchitecture"),
                .package(product: "DependenciesTestSupport"),
                .package(product: "IdentifiedCollections"),
                .package(product: "SQLiteData"),
                .package(product: "StructuredQueries"),
                .package(product: "StructuredQueriesSQLite"),
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
                .package(product: "CasePaths"),
                .package(product: "Dependencies"),
                .package(product: "IdentifiedCollections"),
                .package(product: "SQLiteData"),
                .package(product: "StructuredQueries"),
                .package(product: "StructuredQueriesSQLite"),
                .package(product: "SwiftUINavigation"),
            ],
            settings: .settings(base: [
                "SWIFT_DEFAULT_ACTOR_ISOLATION": "MainActor",
                "ENABLE_USER_SCRIPT_SANDBOXING": "YES",
                "STRING_CATALOG_GENERATE_SYMBOLS": "YES",
                "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "YES",
            ])
        ),
    ]
)
