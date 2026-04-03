import SwiftUI

struct StorybookProfileGlassGroup<Content: View>: View {
    let spacing: CGFloat
    @ViewBuilder var content: () -> Content

    var body: some View {
        GlassEffectContainer(spacing: spacing) {
            content()
        }
    }
}

extension View {
    @ViewBuilder
    func profileGlassSurface(
        cornerRadius: CGFloat = .cornerXXXL,
        tint: Color = .white.opacity(0.14),
        baseFill: Color = Color.surface.opacity(0.72),
        interactive: Bool = false
    ) -> some View {
        if interactive {
            self
                .background {
                    RoundedRectangle(tokenRadius: cornerRadius)
                        .fill(baseFill)
                }
                .glassEffect(
                    .regular
                        .tint(tint)
                        .interactive(),
                    in: .rect(cornerRadius: cornerRadius)
                )
        } else {
            self
                .background {
                    RoundedRectangle(tokenRadius: cornerRadius)
                        .fill(baseFill)
                }
                .glassEffect(
                    .regular
                        .tint(tint),
                    in: .rect(cornerRadius: cornerRadius)
                )
        }
    }
}
