import ComposableArchitecture
import Dependencies
import SwiftUI

@main
struct StorybookStationaryiOSApp: App {
    init() {
        prepareDependencies {
            try! $0.bootstrapDatabase()
        }
        PaperPlaygroundThemeInstaller.installUIKitAppearance()
    }

    var body: some Scene {
        WindowGroup {
            AppRootView(
                store: Store(initialState: AppFeature.State()) {
                    AppFeature()
                }
            )
        }
    }
}
