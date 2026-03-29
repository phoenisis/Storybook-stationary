import SwiftUI

/// A two-layer shadow modifier used by notebook and card-like surfaces.
public struct NotebookShadowModifier: ViewModifier {
    /// Creates a notebook shadow modifier.
    public init() {}

    /// Builds the shadowed view body.
    public func body(content: Content) -> some View {
        content
            .shadow(color: Color.black.opacity(.opacityShadowLight), radius: 0, x: 0, y: .lineM)
            .shadow(color: Color.black.opacity(.opacityShadowMedium), radius: .xl, x: 0, y: .m)
    }
}

/// View helpers for applying notebook shadow styling.
public extension View {
    /// Applies the Paper Playground notebook shadow treatment.
    ///
    /// - Returns: A view rendered with layered notebook shadows.
    func notebookShadow() -> some View {
        modifier(NotebookShadowModifier())
    }
}
