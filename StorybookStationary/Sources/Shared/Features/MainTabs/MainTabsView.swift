import ComposableArchitecture
import SwiftUI
import SwiftUINavigation

struct ContentView: View {
    @Bindable var store: StoreOf<StorybookStationaryFeature>

    var body: some View {
        TabView(selection: $store.selectedTab) {
            StorybookStationaryLibraryTabView(store: store)
                .tabItem {
                    Label("Library", systemImage: "books.vertical.fill")
                }
                .tag(StorybookStationaryFeature.Tab.library)

            StorybookPlaceholderTabView(title: "Read now", icon: "book.fill")
                .tabItem {
                    Label("Read now", systemImage: "book.fill")
                }
                .tag(StorybookStationaryFeature.Tab.readNow)

            StorybookPlaceholderTabView(title: "Badges", icon: "trophy.fill")
                .tabItem {
                    Label("Badges", systemImage: "trophy.fill")
                }
                .tag(StorybookStationaryFeature.Tab.badges)

            StorybookStationaryProfileTabView(store: store)
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(StorybookStationaryFeature.Tab.profile)
        }
        .sheet(
            item: Binding(projectedValue: $store.destination).profileSettings,
            id: \.id
        ) { $profileSettings in
            ProfileSettingsSheet(
                keepAudioEnabled: $profileSettings.keepAudioEnabled,
                onClose: { store.send(.destinationDismissed) }
            )
        }
        .paperPlaygroundTabBarStyle()
    }
}

#Preview {
    ContentView(
        store: Store(initialState: StorybookStationaryFeature.State()) {
            StorybookStationaryFeature()
        }
    )
}
