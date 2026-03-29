import SwiftUI

struct ShowcaseColorSemanticsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: .l) {
            SectionHeader(icon: "paintbrush.pointed.fill", title: "Color Semantics", color: .tertiary)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: .m) {
                ForEach(StorybookShowcaseData.colors) { token in
                    PaletteSwatch(name: token.name, color: token.color, textColor: token.text)
                }
            }
            .paperCard()
        }
    }
}

struct ShowcaseGradientSemanticsSection: View {
    @Binding var selectedIndex: Int

    var body: some View {
        VStack(alignment: .leading, spacing: .l) {
            SectionHeader(icon: "square.3.layers.3d.down.forward", title: "Gradient Semantics", color: .appSecondary)

            VStack(alignment: .leading, spacing: .l) {
                Picker("Gradient", selection: $selectedIndex) {
                    ForEach(StorybookShowcaseData.gradients.indices, id: \.self) { idx in
                        Text(StorybookShowcaseData.gradients[idx].name).tag(idx)
                    }
                }
                .pickerStyle(.segmented)

                RoundedRectangle(tokenRadius: .cornerXXL)
                    .fill(StorybookShowcaseData.gradients[selectedIndex].gradient)
                    .frame(height: 160)
                    .overlay(alignment: .bottomLeading) {
                        Text(StorybookShowcaseData.gradients[selectedIndex].name)
                            .font(.labelM.weight(.black))
                            .textCase(.uppercase)
                            .padding(.m)
                            .foregroundStyle(Color.onSurface)
                    }
                    .notebookShadow()
            }
            .padding(.xxl)
            .paperCard()
        }
    }
}
