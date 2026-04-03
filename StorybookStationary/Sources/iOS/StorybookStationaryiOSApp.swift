import ComposableArchitecture
import SwiftUI

@main
struct StorybookStationaryiOSApp: App {
    init() {
        PaperPlaygroundThemeInstaller.installUIKitAppearance()
    }

    var body: some Scene {
        WindowGroup {
            ContentView(
                store: Store(initialState: StorybookStationaryFeature.State()) {
                    StorybookStationaryFeature()
                }
            )
        }
    }
}
