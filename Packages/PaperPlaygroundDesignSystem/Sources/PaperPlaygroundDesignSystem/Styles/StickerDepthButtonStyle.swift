import SwiftUI

/// A button style that applies Paper Playground sticker depth, border, and press motion.
public struct StickerDepthButtonStyle: ButtonStyle {
    /// Base fill color used by the button.
    public let color: Color
    /// Corner radius token used for clipping and border rendering.
    public let cornerRadius: CGFloat

    /// Creates the sticker depth button style.
    ///
    /// - Parameters:
    ///   - color: Base fill color.
    ///   - cornerRadius: Corner radius token. Defaults to `.cornerL`.
    public init(color: Color, cornerRadius: CGFloat = .cornerL) {
        self.color = color
        self.cornerRadius = cornerRadius
    }

    /// Builds the styled button body for the current configuration.
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, .xxxl)
            .padding(.vertical, .l)
            .background(color)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(tokenRadius: cornerRadius))
            .overlay {
                RoundedRectangle(tokenRadius: cornerRadius)
                    .strokeBorder(.white.opacity(.opacityBorder), lineWidth: .lineHairline)
            }
            .shadow(color: color.opacity(.opacityStrong), radius: 0, x: 0, y: configuration.isPressed ? .lineHairline : .lineM)
            .offset(y: configuration.isPressed ? .lineM : 0)
            .animation(.appButtonPress, value: configuration.isPressed)
    }
}
