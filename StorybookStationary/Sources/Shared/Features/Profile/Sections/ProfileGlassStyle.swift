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
        interactive: Bool = false
    ) -> some View {
        self
            .glassEffect(
                .regular
                    .tint(tint)
                    .interactive(interactive)
                    .interactive(),
                in: .rect(cornerRadius: cornerRadius)
            )
    }
}
