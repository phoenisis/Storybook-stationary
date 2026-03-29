import ComposableArchitecture
import SwiftUI

struct StorybookShowcaseRootView: View {
    @Bindable var store: StoreOf<StorybookShowcase>

    var body: some View {
        TabView(selection: $store.navSelected) {
            ShowcaseTabPage(title: "Theme") {
                ShowcaseColorSemanticsSection()
                ShowcaseGradientSemanticsSection(selectedIndex: $store.gradientIndex)
            }
            .tabItem {
                Label("Theme", systemImage: "paintpalette.fill")
            }
            .tag(StorybookShowcase.Tab.theme)

            ShowcaseTabPage(title: "Tokens") {
                ShowcaseTypographySection()
                ShowcaseScalarTokensSection(
                    spacingIndex: $store.spacingIndex,
                    sizeIndex: $store.sizeIndex,
                    radiusIndex: $store.radiusIndex,
                    strokeIndex: $store.strokeIndex,
                    metricIndex: $store.metricIndex
                )
            }
            .tabItem {
                Label("Tokens", systemImage: "dial.low.fill")
            }
            .tag(StorybookShowcase.Tab.tokens)

            ShowcaseTabPage(title: "Components") {
                ShowcaseComponentsSection(progressPreviewState: $store.progressPreviewState)
            }
            .tabItem {
                Label("Components", systemImage: "square.grid.2x2.fill")
            }
            .tag(StorybookShowcase.Tab.components)

            ShowcaseTabPage(title: "Motion") {
                ShowcaseMotionSection(
                    showcaseAnimationState: store.showcaseAnimationState,
                    buttonMotionButtonTapped: {
                        store.send(.buttonMotionButtonTapped, animation: .appButtonPress)
                    },
                    navigationMotionButtonTapped: {
                        store.send(.navigationMotionButtonTapped, animation: .appNavigation)
                    }
                )
            }
            .tabItem {
                Label("Motion", systemImage: "sparkles")
            }
            .tag(StorybookShowcase.Tab.motion)
        }
        .paperPlaygroundTabBarStyle()
    }
}

private struct ShowcaseTabPage<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content

    var body: some View {
        NavigationStack {
            List {
                content
            }
            .scrollContentBackground(.hidden)
            .background(Color.background)
            .navigationTitle(title)
            .paperPlaygroundNavigationLargeTitleStyle(.appPrimary)
        }
    }
}

#Preview {
    StorybookShowcaseRootView(
        store: Store(initialState: StorybookShowcase.State()) {
            StorybookShowcase()
        }
    )
}
