import SwiftUI

@main
struct StorybookStationaryiOSApp: App {
    init() {
        PaperPlaygroundThemeInstaller.installUIKitAppearance()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
