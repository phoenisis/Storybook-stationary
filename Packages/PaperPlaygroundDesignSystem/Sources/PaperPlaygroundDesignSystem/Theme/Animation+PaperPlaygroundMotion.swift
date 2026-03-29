import SwiftUI

/// Shared motion presets for Paper Playground interactions.
public enum PaperPlaygroundMotion {
    public static let navigation = Animation.spring(
        response: PaperPlaygroundTokens.Effect.springResponse,
        dampingFraction: PaperPlaygroundTokens.Effect.springDamping
    )

    public static let buttonPress = Animation.spring(
        response: PaperPlaygroundTokens.Effect.pressSpringResponse,
        dampingFraction: PaperPlaygroundTokens.Effect.pressSpringDamping
    )
}

/// Animation aliases for ergonomic usage from feature code.
public extension Animation {
    static let appNavigation = PaperPlaygroundMotion.navigation
    static let appButtonPress = PaperPlaygroundMotion.buttonPress
}
