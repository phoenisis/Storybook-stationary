import SwiftUI

/// Token-friendly convenience initializers for `EdgeInsets`.
public extension EdgeInsets {
    /// Creates edge insets using horizontal and vertical token values.
    ///
    /// - Parameters:
    ///   - horizontal: Leading and trailing inset.
    ///   - vertical: Top and bottom inset.
    init(horizontal: CGFloat, vertical: CGFloat) {
        self.init(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }
}

/// Token-friendly convenience initializers for `RoundedRectangle`.
public extension RoundedRectangle {
    /// Creates a rounded rectangle using a Paper Playground corner radius token.
    ///
    /// - Parameters:
    ///   - tokenRadius: Corner radius token value.
    ///   - style: Corner rendering style.
    init(tokenRadius: CGFloat, style: RoundedCornerStyle = .continuous) {
        self.init(cornerRadius: tokenRadius, style: style)
    }
}

/// Token-friendly convenience initializers for `StrokeStyle`.
public extension StrokeStyle {
    /// Creates a stroke style using a Paper Playground line-width token.
    ///
    /// - Parameters:
    ///   - tokenLineWidth: Stroke line-width token value.
    ///   - dash: Optional dash pattern.
    init(tokenLineWidth: CGFloat, dash: [CGFloat] = []) {
        self.init(lineWidth: tokenLineWidth, lineCap: .round, lineJoin: .round, dash: dash)
    }
}
