import SwiftUI

/// A compact capsule label used to represent UI state labels.
public struct StickerStatePill: View {
    /// Pill label text.
    public let name: String
    /// Pill background color.
    public let fill: Color
    /// Pill foreground text color.
    public let text: Color

    /// Creates a state pill.
    ///
    /// - Parameters:
    ///   - name: Pill label.
    ///   - fill: Background color.
    ///   - text: Foreground text color.
    public init(name: String, fill: Color, text: Color) {
        self.name = name
        self.fill = fill
        self.text = text
    }

    /// The view content and layout definition.
    public var body: some View {
        Text(name)
            .font(.labelS.weight(.bold))
            .textCase(.uppercase)
            .padding(.horizontal, .m)
            .padding(.vertical, .xs)
            .background(fill)
            .foregroundStyle(text)
            .clipShape(Capsule())
    }
}
