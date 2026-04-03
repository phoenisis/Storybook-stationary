import ComposableArchitecture
import SwiftUI

@main
struct StorybookStationarymacOSApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                store: Store(initialState: StorybookStationaryFeature.State()) {
                    StorybookStationaryFeature()
                }
            )
                .frame(minWidth: 640, minHeight: 420)
        }
    }
}
