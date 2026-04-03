import ComposableArchitecture
import Dependencies
import SwiftUI

@main
struct StorybookStationaryiOSApp: App {
    init() {
        prepareDependencies {
            do {
                try $0.bootstrapDatabase()
            } catch {
                assertionFailure("Failed to bootstrap database: \(error)")
            }
        }
        PaperPlaygroundThemeInstaller.installUIKitAppearance()
    }

    var body: some Scene {
        WindowGroup {
            AppRootView(
                store: Store(initialState: AppFeature.State()) {
                    #if DEBUG
                    AppFeature()
                        ._printChanges()
                    #else
                    AppFeature()
                    #endif
                }
                
            )
        }
    }
}
