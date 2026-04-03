import SwiftUI

/// Shared tab bar styling for Paper Playground surfaces.
public extension View {
    /// Applies the Paper Playground tab bar visual treatment to the current view hierarchy.
    ///
    /// Use this on the root ``SwiftUI/TabView`` of a feature or app.
    ///
    /// - Returns: A view with Paper Playground tab bar styling applied.
    func paperPlaygroundTabBarStyle() -> some View {
        #if os(iOS)
        self
            .tint(.appPrimary)
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(.ultraThinMaterial, for: .tabBar)
        #else
        self
            .tint(.appPrimary)
        #endif
    }
}
