import ComposableArchitecture
import Dependencies
import SwiftUI

@main
struct StorybookStationarymacOSApp: App {
    init() {
        prepareDependencies {
            do {
                try $0.bootstrapDatabase()
            } catch {
                assertionFailure("Failed to bootstrap database: \(error)")
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            AppRootView(
                store: Store(initialState: AppFeature.State()) {
                    AppFeature()
                }
            )
                .frame(minWidth: 640, minHeight: 420)
        }
    }
}
