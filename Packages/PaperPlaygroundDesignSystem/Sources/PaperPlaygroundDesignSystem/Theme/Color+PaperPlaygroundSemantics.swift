import SwiftUI

/// Semantic color aliases for feature-facing usage.
public extension Color {
    // Full palette aliases (safe from collisions with SwiftUI semantic names).
    static let appPrimary = PaperPlayground.primary
    static let appPrimaryDim = PaperPlayground.primaryDim
    static let appPrimaryContainer = PaperPlayground.primaryContainer
    static let appOnPrimaryContainer = PaperPlayground.onPrimaryContainer

    static let appSecondary = PaperPlayground.secondary
    static let appSecondaryDim = PaperPlayground.secondaryDim
    static let appSecondaryContainer = PaperPlayground.secondaryContainer
    static let appOnSecondaryContainer = PaperPlayground.onSecondaryContainer

    // Direct semantic aliases for common non-colliding tokens.
    static let tertiary = PaperPlayground.tertiary
    static let tertiaryDim = PaperPlayground.tertiaryDim
    static let tertiaryContainer = PaperPlayground.tertiaryContainer
    static let onTertiaryContainer = PaperPlayground.onTertiaryContainer

    static let background = PaperPlayground.background
    static let surface = PaperPlayground.surface
    static let surfaceLow = PaperPlayground.surfaceLow
    static let surfaceHigh = PaperPlayground.surfaceHigh

    static let onSurface = PaperPlayground.onSurface
    static let onSurfaceVariant = PaperPlayground.onSurfaceVariant
    static let outline = PaperPlayground.outline
    static let outlineVariant = PaperPlayground.outlineVariant
}
