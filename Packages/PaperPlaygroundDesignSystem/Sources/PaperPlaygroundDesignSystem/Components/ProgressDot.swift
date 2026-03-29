import SwiftUI

/// A progress indicator dot with semantic visual states.
public struct ProgressDot: View {
    /// Visual states supported by ``ProgressDot``.
    public enum State: Hashable {
        case filled
        case current
        case empty
    }

    /// Current visual state.
    public let state: State

    /// Creates a progress dot.
    ///
    /// - Parameter state: The visual state to render.
    public init(state: State) {
        self.state = state
    }

    /// The view content and layout definition.
    public var body: some View {
        switch state {
        case .filled:
            Circle()
                .fill(Color.tertiary)
                .overlay {
                    Image(systemName: "checkmark")
                        .font(.labelS.weight(.black))
                        .foregroundStyle(.white)
                }
                .shadow(color: .black.opacity(.opacityProgressFilledShadow), radius: .lineS, x: 0, y: .lineS)
        case .current:
            Circle()
                .fill(.white)
                .overlay {
                    Circle()
                        .stroke(Color.tertiaryContainer, lineWidth: .lineM)
                }
                .shadow(color: .black.opacity(.opacityProgressCurrentShadow), radius: .lineS, x: 0, y: .lineHairline)
        case .empty:
            Circle()
                .fill(Color.surfaceHigh)
                .overlay {
                    Circle()
                        .stroke(
                            Color.outlineVariant.opacity(.opacityMedium),
                            style: StrokeStyle(tokenLineWidth: .lineS, dash: [.xxs, .lineS])
                        )
                }
        }
    }
}
