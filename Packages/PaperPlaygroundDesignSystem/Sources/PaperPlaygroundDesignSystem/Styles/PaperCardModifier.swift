import SwiftUI

/// A card modifier that applies Paper Playground surface, border, and shadow styling.
public struct PaperCardModifier: ViewModifier {
    /// Creates a paper card modifier.
    public init() {}

    /// Builds the styled card body.
    public func body(content: Content) -> some View {
        content
            .padding(.l)
            .background(Color.surface)
            .clipShape(RoundedRectangle(tokenRadius: .cornerXXXL))
            .overlay {
                RoundedRectangle(tokenRadius: .cornerXXXL)
                    .strokeBorder(
                        Color.outlineVariant.opacity(.opacityMedium),
                        style: StrokeStyle(tokenLineWidth: .lineS, dash: [.xl, .s])
                    )
            }
            .notebookShadow()
    }
}

/// View helpers for applying card styling.
public extension View {
    /// Applies the Paper Playground card container style.
    ///
    /// - Returns: A view rendered with paper card styling.
    func paperCard() -> some View {
        modifier(PaperCardModifier())
    }
}
