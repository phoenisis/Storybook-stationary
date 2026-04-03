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
            item: Binding(projectedValue: $store.destination).avatarEditor,
            id: \.id
        ) { $avatarEditor in
            ProfileAvatarSheet(
                state: $avatarEditor,
                activeProfileName: store.activeProfileName,
                onClose: { store.send(.destinationDismissed) },
                onAgeChanged: { age in store.send(.avatarEditorAgeChanged(age)) },
                onGenderChanged: { gender in store.send(.avatarEditorGenderChanged(gender)) },
                onGenerate: { store.send(.avatarGenerateTapped) },
                onPlaygroundCompleted: { url in store.send(.avatarPlaygroundCompleted(url)) },
                onPlaygroundCancelled: { store.send(.avatarPlaygroundCancelled) },
                onPlaygroundFailed: { message in store.send(.avatarPlaygroundFailed(message)) },
                onSave: { store.send(.avatarSaveTapped) }
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
