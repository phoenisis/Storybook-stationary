import SwiftUI

/// A card component that mimics a spiral notebook visual style.
public struct SpiralNotebookCard: View {
    /// Main card title text.
    public let title: String
    /// Supporting description text.
    public let description: String

    /// Creates a spiral notebook card.
    ///
    /// - Parameters:
    ///   - title: Primary headline.
    ///   - description: Supporting body copy.
    public init(title: String, description: String) {
        self.title = title
        self.description = description
    }

    /// The view content and layout definition.
    public var body: some View {
        HStack(spacing: 0) {
            VStack(spacing: .spiralGap) {
                ForEach(0..<9, id: \.self) { _ in
                    Circle()
                        .fill(Color.outlineVariant)
                        .frame(width: .dot, height: .dot)
                }
            }
            .frame(width: .spiralSpineWidth)
            .padding(.vertical, .xl)
            .background(Color.surfaceLow)

            VStack(alignment: .leading, spacing: .l) {
                Text(title)
                    .font(.sectionTitle.weight(.black))
                    .foregroundStyle(Color.appPrimary)
                Text(description)
                    .font(.bodyM)
                    .foregroundStyle(Color.onSurfaceVariant)
                    .lineSpacing(.appLineSpacing)
            }
            .padding(.xxxl)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.paperSurfaceFade.opacity(.opacityWash))
        }
        .clipShape(RoundedRectangle(tokenRadius: .cornerXXL))
        .overlay {
            RoundedRectangle(tokenRadius: .cornerXXL)
                .stroke(.white, lineWidth: .lineS)
        }
        .notebookShadow()
    }
}
