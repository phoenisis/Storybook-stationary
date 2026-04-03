import ComposableArchitecture
import Dependencies
import SwiftUI

@main
struct StorybookStationarymacOSApp: App {
    init() {
        prepareDependencies {
            try! $0.bootstrapDatabase()
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
