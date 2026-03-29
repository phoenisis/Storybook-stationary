import SwiftUI

/// A labeled color preview block used to present semantic palette tokens.
public struct PaletteSwatch: View {
    /// Display label for the swatch.
    public let name: String
    /// Fill color previewed by this swatch.
    public let color: Color
    /// Text color for the label overlay.
    public let textColor: Color

    /// Creates a palette swatch.
    ///
    /// - Parameters:
    ///   - name: Swatch label.
    ///   - color: Swatch fill color.
    ///   - textColor: Swatch label foreground color.
    public init(name: String, color: Color, textColor: Color) {
        self.name = name
        self.color = color
        self.textColor = textColor
    }

    /// The view content and layout definition.
    public var body: some View {
        RoundedRectangle(tokenRadius: .cornerL)
            .fill(color)
            .frame(height: .swatchHeight)
            .overlay(alignment: .bottomLeading) {
                Text(name)
                    .font(.labelS.weight(.black))
                    .textCase(.uppercase)
                    .foregroundStyle(textColor)
                    .padding(.m)
            }
    }
}
