import SwiftUI

/// A decorative paper-grain overlay that adds subtle tactile texture.
public struct PaperGrainOverlay: View {
    /// Creates a paper grain overlay.
    public init() {}

    /// The view content and layout definition.
    public var body: some View {
        Canvas { context, size in
            var seed: UInt64 = 0xC0FFEE

            func random() -> CGFloat {
                seed ^= seed << 13
                seed ^= seed >> 7
                seed ^= seed << 17
                return CGFloat(seed % 10_000) / 10_000
            }

            for _ in 0..<PaperPlaygroundTokens.Effect.grainCount {
                let point = CGPoint(x: random() * size.width, y: random() * size.height)
                let grain = CGRect(x: point.x, y: point.y, width: .grainDot, height: .grainDot)
                context.fill(Path(ellipseIn: grain), with: .color(.black.opacity(Double(PaperPlaygroundTokens.Effect.grainOpacity))))
            }
        }
        .blendMode(.multiply)
        .opacity(.opacitySoft)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}
