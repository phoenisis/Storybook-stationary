import SwiftUI

/// A semantic section header with leading SF Symbol and uppercase title styling.
public struct SectionHeader: View {
    /// SF Symbol name displayed at the leading edge.
    public let icon: String
    /// Header title text.
    public let title: String
    /// Accent color used for the leading icon.
    public let color: Color

    /// Creates a section header.
    ///
    /// - Parameters:
    ///   - icon: SF Symbol identifier.
    ///   - title: Header title string.
    ///   - color: Leading icon color.
    public init(icon: String, title: String, color: Color) {
        self.icon = icon
        self.title = title
        self.color = color
    }

    /// The view content and layout definition.
    public var body: some View {
        HStack(spacing: .m) {
            Image(systemName: icon)
                .font(.title3.weight(.bold))
                .foregroundStyle(color)
            Text(title)
                .font(.sectionTitle.weight(.black))
                .tracking(.trackTight)
                .foregroundStyle(Color.appPrimary)
            Spacer(minLength: 0)
        }
        .textCase(.uppercase)
    }
}
