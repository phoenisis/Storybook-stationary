import SwiftUI

/// Gradient presets used by the Paper Playground visual system.
public enum PaperPlaygroundGradient {
    public static let paperSurfaceFade = LinearGradient(
        colors: [.clear, .surfaceLow],
        startPoint: .top,
        endPoint: .bottom
    )

    public static let tertiarySticker = LinearGradient(
        colors: [.tertiaryContainer, .tertiary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    public static let primarySticker = LinearGradient(
        colors: [.appPrimaryContainer, .appPrimary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

/// Convenience gradient aliases for direct use from `LinearGradient`.
@MainActor
public extension LinearGradient {
    static let paperSurfaceFade = PaperPlaygroundGradient.paperSurfaceFade
    static let tertiarySticker = PaperPlaygroundGradient.tertiarySticker
    static let primarySticker = PaperPlaygroundGradient.primarySticker
}

/// `ShapeStyle` aliases for ergonomic `.fill(...)` usage.
@MainActor
public extension ShapeStyle where Self == LinearGradient {
    static var paperSurfaceFade: LinearGradient { .paperSurfaceFade }
    static var tertiarySticker: LinearGradient { .tertiarySticker }
    static var primarySticker: LinearGradient { .primarySticker }
}
