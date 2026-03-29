import SwiftUI

struct ShowcaseComponentsSection: View {
    @Binding var progressPreviewState: ProgressDot.State

    var body: some View {
        VStack(alignment: .leading, spacing: .l) {
            SectionHeader(icon: "square.grid.2x2", title: "Components", color: .appSecondary)

            VStack(alignment: .leading, spacing: .xxl) {
                SpiralNotebookCard(
                    title: "Component Card",
                    description: "This demonstrates the notebook card with tokenized spacing, typography, and semantic colors."
                )

                HStack(spacing: .m) {
                    StickerStatePill(name: "Enabled", fill: .surfaceLow, text: .outline)
                    StickerStatePill(name: "Hover", fill: .tertiaryContainer, text: .onTertiaryContainer)
                    StickerStatePill(name: "Pressed", fill: .appPrimaryContainer, text: .appOnPrimaryContainer)
                }

                Picker("Progress state", selection: $progressPreviewState) {
                    Text("Filled").tag(ProgressDot.State.filled)
                    Text("Current").tag(ProgressDot.State.current)
                    Text("Empty").tag(ProgressDot.State.empty)
                }
                .pickerStyle(.segmented)

                HStack(spacing: .m) {
                    ProgressDot(state: .filled)
                    ProgressDot(state: progressPreviewState)
                    ProgressDot(state: .empty)
                    ProgressDot(state: .filled)
                    ProgressDot(state: .empty)
                }
                .frame(height: .progressRowHeight)

                HStack(spacing: .l) {
                    Button("Primary") {}
                        .font(.labelM.weight(.black))
                        .textCase(.uppercase)
                        .buttonStyle(StickerDepthButtonStyle(color: .appPrimary))

                    Button("Secondary") {}
                        .font(.labelM.weight(.black))
                        .textCase(.uppercase)
                        .buttonStyle(StickerDepthButtonStyle(color: .appSecondary))
                }
            }
            .padding(.xxl)
            .paperCard()
        }
    }
}

struct ShowcaseMotionSection: View {
    let showcaseAnimationState: Bool
    let buttonMotionButtonTapped: () -> Void
    let navigationMotionButtonTapped: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: .l) {
            SectionHeader(icon: "sparkles", title: "Motion Presets", color: .appPrimary)

            VStack(alignment: .leading, spacing: .l) {
                Text("Tap to preview standardized motion tokens")
                    .font(.bodyS)
                    .foregroundStyle(Color.onSurfaceVariant)

                HStack(spacing: .l) {
                    Button("Navigation Motion") { navigationMotionButtonTapped() }
                        .font(.labelM.weight(.black))
                        .textCase(.uppercase)
                        .buttonStyle(StickerDepthButtonStyle(color: .appPrimary))

                    Button("Button Motion") { buttonMotionButtonTapped() }
                        .font(.labelM.weight(.black))
                        .textCase(.uppercase)
                        .buttonStyle(StickerDepthButtonStyle(color: .tertiary))
                }

                RoundedRectangle(tokenRadius: .cornerXXL)
                    .fill(.tertiarySticker)
                    .frame(height: 88)
                    .overlay {
                        Text(showcaseAnimationState ? "Animated In" : "Animated Out")
                            .font(.headingL.weight(.bold))
                            .foregroundStyle(.white)
                    }
                    .scaleEffect(showcaseAnimationState ? 1.0 : 0.92)
                    .offset(x: showcaseAnimationState ? 0 : -12)
            }
            .padding(.xxl)
            .paperCard()
        }
    }
}
