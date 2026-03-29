import ComposableArchitecture
import SwiftUI

@main
struct StorybookShowcaseiOSApp: App {
    init() {
        PaperPlaygroundThemeInstaller.installUIKitAppearance()
    }

    var body: some Scene {
        WindowGroup {
            StorybookShowcaseRootView(
                store: Store(initialState: StorybookShowcase.State()) {
                    StorybookShowcase()
                }
            )
        }
    }
}
