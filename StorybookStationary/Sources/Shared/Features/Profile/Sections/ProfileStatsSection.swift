import SwiftUI

struct StorybookProfileStatsSection: View {
    let stats: [StorybookStationaryFeature.ProfileStat]
    let onStatTapped: (String) -> Void

    var body: some View {
        StorybookProfileGlassGroup(spacing: .l) {
            VStack(alignment: .leading, spacing: .l) {
                sectionTitle("MES STATISTIQUES")

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: .l) {
                    ForEach(stats) { stat in
                        StatCard(
                            stat: stat,
                            accentColor: accentColor(stat.accent),
                            onTap: { onStatTapped(stat.title) }
                        )
                    }
                }
            }
            .padding(.xxl)
            .profileGlassSurface(tint: Color.white.opacity(0.2))
        }
    }

    private func sectionTitle(_ title: String) -> some View {
        VStack(alignment: .leading, spacing: .xs) {
            Text(title)
                .font(.sectionTitle.weight(.black))
                .foregroundStyle(Color.appPrimary)
            RoundedRectangle(tokenRadius: .cornerPill)
                .fill(Color.appPrimary)
                .frame(width: 84, height: .lineM)
        }
    }

    private func accentColor(_ accent: StorybookStationaryFeature.ProfileStat.Accent) -> Color {
        switch accent {
        case .blue:
            return Color.appPrimary
        case .green:
            return Color.appSecondary
        case .gold:
            return Color.appSecondaryDim
        case .purple:
            return Color.tertiary
        }
    }
}

private struct StatCard: View {
    let stat: StorybookStationaryFeature.ProfileStat
    let accentColor: Color
    let onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            VStack(alignment: .leading, spacing: .m) {
                Image(systemName: stat.icon)
                    .font(.bodyM.weight(.black))
                    .foregroundStyle(accentColor)

                Text(stat.subtitle)
                    .font(.labelS.weight(.black))
                    .foregroundStyle(accentColor)

                Text(stat.value)
                    .font(.metricValue.weight(.black))
                    .foregroundStyle(accentColor)
            }
            .padding(.l)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(accentColor.opacity(0.1))
            .overlay(alignment: .leading) {
                Rectangle()
                    .fill(accentColor)
                    .frame(width: 7)
                    .padding(.vertical, .m)
                    .clipShape(Capsule())
            }
            .clipShape(RoundedRectangle(tokenRadius: .cornerXL))
            .profileGlassSurface(
                cornerRadius: .cornerXL,
                tint: accentColor.opacity(0.12),
                interactive: true
            )
        }
        .buttonStyle(.plain)
    }
}
