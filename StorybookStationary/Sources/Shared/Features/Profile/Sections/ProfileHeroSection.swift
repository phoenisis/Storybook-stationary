import SwiftUI

struct StorybookProfileHeroSection: View {
    let activeProfileName: String
    let onAvatarTapped: () -> Void

    var body: some View {
        StorybookProfileGlassGroup(spacing: .l) {
            VStack(alignment: .leading, spacing: .l) {
                ZStack(alignment: .topTrailing) {
                    Circle()
                        .fill(Color.surfaceLow)
                        .frame(width: 144, height: 144)
                        .overlay {
                            Circle()
                                .stroke(.white, lineWidth: .lineM)
                        }
                        .overlay {
                            Image(systemName: "person.fill")
                                .font(.system(size: 56, weight: .black))
                                .foregroundStyle(Color.appPrimary)
                        }

                    VStack(spacing: .xxs) {
                        Text("NV. 12")
                            .font(.labelM.weight(.black))
                            .foregroundStyle(.white)
                        Text("EXPLORATEUR")
                            .font(.labelS.weight(.black))
                            .foregroundStyle(.white.opacity(0.9))
                    }
                    .padding(.vertical, .xs)
                    .padding(.horizontal, .m)
                    .background(Color.appSecondary)
                    .clipShape(Capsule())
                    .rotationEffect(.degrees(8))
                    .offset(x: 8, y: -8)
                }

                Text(activeProfileName.isEmpty ? "Mon profil" : activeProfileName)
                    .font(.headingL.weight(.black))
                    .foregroundStyle(Color.appPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(.minimumScale)

                Button {
                    onAvatarTapped()
                } label: {
                    HStack(spacing: .m) {
                        Image(systemName: "wand.and.stars.inverse")
                        Text("Changer d'avatar")
                    }
                    .font(.labelM.weight(.black))
                    .textCase(.uppercase)
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.glassProminent)
            }
            .padding(.xxl)
            .frame(maxWidth: .infinity, alignment: .leading)
            .profileGlassSurface(tint: Color.appPrimary.opacity(0.18))
        }
    }
}
