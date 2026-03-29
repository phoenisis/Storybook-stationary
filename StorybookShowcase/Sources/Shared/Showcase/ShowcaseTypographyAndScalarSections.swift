import SwiftUI

struct ShowcaseTypographySection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: .l) {
            SectionHeader(icon: "textformat", title: "Typography Tokens", color: .appPrimary)

            VStack(alignment: .leading, spacing: .l) {
                ForEach(StorybookShowcaseData.fonts) { sample in
                    VStack(alignment: .leading, spacing: .xs) {
                        Text(sample.name)
                            .font(.labelS.weight(.bold))
                            .foregroundStyle(Color.outline)
                            .textCase(.uppercase)
                        Text("The quick brown fox jumps over paper playground.")
                            .font(sample.font)
                            .foregroundStyle(Color.onSurface)
                            .lineLimit(1)
                    }
                }
            }
            .padding(.xxl)
            .paperCard()
        }
    }
}

struct ShowcaseScalarTokensSection: View {
    @Binding var spacingIndex: Int
    @Binding var sizeIndex: Int
    @Binding var radiusIndex: Int
    @Binding var strokeIndex: Int
    @Binding var metricIndex: Int

    var body: some View {
        let spacings = StorybookShowcaseData.spacingTokens
        let sizes = StorybookShowcaseData.sizeTokens
        let radii = StorybookShowcaseData.radiusTokens
        let strokes = StorybookShowcaseData.strokeTokens
        let metrics = StorybookShowcaseData.metricTokens

        VStack(alignment: .leading, spacing: .l) {
            SectionHeader(icon: "slider.horizontal.3", title: "Scalar Tokens", color: .tertiary)

            VStack(alignment: .leading, spacing: .xxl) {
                ShowcaseTokenPickerRow(title: "Spacing", index: $spacingIndex, tokens: spacings)
                HStack(spacing: spacings[spacingIndex].value) {
                    ForEach(0..<4, id: \.self) { _ in
                        Circle().fill(Color.tertiary).frame(width: 14, height: 14)
                    }
                }

                ShowcaseTokenPickerRow(title: "Size", index: $sizeIndex, tokens: sizes)
                RoundedRectangle(tokenRadius: .cornerL)
                    .fill(Color.appPrimaryContainer)
                    .frame(width: sizes[sizeIndex].value, height: sizes[sizeIndex].value)
                    .overlay {
                        Text(sizes[sizeIndex].name)
                            .font(.labelS)
                            .foregroundStyle(Color.appOnPrimaryContainer)
                    }

                ShowcaseTokenPickerRow(title: "Radius", index: $radiusIndex, tokens: radii)
                ShowcaseTokenPickerRow(title: "Stroke", index: $strokeIndex, tokens: strokes)
                RoundedRectangle(tokenRadius: radii[radiusIndex].value)
                    .stroke(Color.appPrimary, lineWidth: strokes[strokeIndex].value)
                    .frame(height: 72)

                ShowcaseTokenPickerRow(title: "Metric", index: $metricIndex, tokens: metrics)
                Text("Metric preview")
                    .font(.headingL)
                    .tracking(metrics[metricIndex].value)
                    .foregroundStyle(Color.onSurface)

                VStack(alignment: .leading, spacing: .s) {
                    Text("Opacity & Effect Tokens")
                        .font(.labelM.weight(.black))
                        .textCase(.uppercase)
                        .foregroundStyle(Color.outline)
                    Text("opacitySoft: \(Double.opacitySoft.showcaseDecimal)  opacityStrong: \(Double.opacityStrong.showcaseDecimal)  shadowHeavy: \(Double.opacityShadowHeavy.showcaseDecimal)")
                        .font(.bodyS)
                        .foregroundStyle(Color.onSurfaceVariant)
                    Text("springResponse: \(Double(PaperPlaygroundTokens.Effect.springResponse).showcaseDecimal)  springDamping: \(Double(PaperPlaygroundTokens.Effect.springDamping).showcaseDecimal)")
                        .font(.bodyS)
                        .foregroundStyle(Color.onSurfaceVariant)
                }
            }
            .padding(.xxl)
            .paperCard()
        }
    }
}

private struct ShowcaseTokenPickerRow: View {
    let title: String
    @Binding var index: Int
    let tokens: [ShowcaseScalarToken]

    var body: some View {
        VStack(alignment: .leading, spacing: .xs) {
            Text("\(title): \(tokens[index].name) = \(tokens[index].value.showcaseDecimal)")
                .font(.labelM.weight(.black))
                .textCase(.uppercase)
                .foregroundStyle(Color.outline)

            Picker(title, selection: $index) {
                ForEach(tokens.indices, id: \.self) { tokenIndex in
                    Text(tokens[tokenIndex].name).tag(tokenIndex)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}
