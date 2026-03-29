import SwiftUI

/// Shared motion presets for Paper Playground interactions.
public enum PaperPlaygroundMotion {
    public static let navigation = Animation.spring(
        response: Double(PaperPlaygroundTokens.Effect.springResponse),
        dampingFraction: Double(PaperPlaygroundTokens.Effect.springDamping)
    )

    public static let buttonPress = Animation.spring(
        response: Double(PaperPlaygroundTokens.Effect.pressSpringResponse),
        dampingFraction: Double(PaperPlaygroundTokens.Effect.pressSpringDamping)
    )
}

/// Animation aliases for ergonomic usage from feature code.
public extension Animation {
    static let appNavigation = PaperPlaygroundMotion.navigation
    static let appButtonPress = PaperPlaygroundMotion.buttonPress
}
