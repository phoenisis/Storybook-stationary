import SwiftUI

struct StorybookProfileThemesSection: View {
    let themes: [StorybookStationaryFeature.ProfileTheme]
    let isWideLayout: Bool
    let onThemeTapped: (String) -> Void

    private var columns: [GridItem] {
        if isWideLayout {
            return [GridItem(.flexible()), GridItem(.flexible())]
        }
        return [GridItem(.adaptive(minimum: 220))]
    }

    var body: some View {
        StorybookProfileGlassGroup(spacing: .l) {
            VStack(alignment: .leading, spacing: .l) {
                HStack(spacing: .m) {
                    Text("MES THEMES PREFERES")
                        .font(.sectionTitle.weight(.black))
                        .foregroundStyle(Color.appPrimary)
                    Rectangle()
                        .fill(Color.appPrimary.opacity(0.25))
                        .frame(height: .lineS)
                }

                LazyVGrid(columns: columns, spacing: .l) {
                    ForEach(themes) { theme in
                        Button {
                            onThemeTapped(theme.name)
                        } label: {
                            HStack(spacing: .m) {
                                Circle()
                                    .fill(accentColor(theme.accent).opacity(0.2))
                                    .frame(width: 46, height: 46)
                                    .overlay {
                                        Image(systemName: theme.icon)
                                            .font(.bodyM.weight(.black))
                                            .foregroundStyle(accentColor(theme.accent))
                                    }

                                VStack(alignment: .leading, spacing: .xxs) {
                                    Text(theme.name)
                                        .font(.headingL.weight(.bold))
                                        .foregroundStyle(Color.onSurface)
                                        .lineLimit(1)
                                    Text("\(theme.exploredBooks) livres explores")
                                        .font(.bodyS.weight(.semibold))
                                        .foregroundStyle(Color.onSurfaceVariant)
                                }

                                Spacer(minLength: 0)
                            }
                            .padding(.l)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .profileGlassSurface(
                                cornerRadius: .cornerXXXL,
                                tint: accentColor(theme.accent).opacity(0.1),
                                interactive: true
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private func accentColor(_ accent: StorybookStationaryFeature.ProfileTheme.Accent) -> Color {
        switch accent {
        case .mint:
            return Color.appSecondary
        case .cyan:
            return Color.appPrimary
        case .amber:
            return Color.appSecondaryDim
        case .pink:
            return Color.tertiary
        }
    }
}
