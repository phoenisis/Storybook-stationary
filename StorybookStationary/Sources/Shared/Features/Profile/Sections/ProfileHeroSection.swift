import SwiftUI

struct StorybookProfileHeroSection: View {
    let activeAvatar: UserAvatarStyle
    let activeAvatarImageData: Data
    let activeProfileName: String
    let onAvatarTapped: () -> Void

    var body: some View {
        StorybookProfileGlassGroup(spacing: .l) {
            VStack(alignment: .leading, spacing: .l) {
                ZStack(alignment: .topTrailing) {
                    StorybookAvatarArtwork(imageData: activeAvatarImageData)
                        .frame(width: 144, height: 144)
                        .id(activeAvatar)
                        .transition(.scale.combined(with: .opacity))
                        .animation(.spring(duration: 0.35, bounce: 0.32), value: activeAvatar)

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

struct StorybookAvatarArtwork: View {
    var imageData: Data? = nil

    var body: some View {
        Group {
            if let platformImage = PlatformAvatarImage(data: imageData ?? .init()) {
                Image(platformAvatarImage: platformImage)
                    .resizable()
                    .scaledToFill()
                    .clipShape(.rect(cornerRadius: 80))
            } else {
                Circle()
                    .fill(Color.appPrimary.opacity(0.14))
                    .overlay {
                        Image(systemName: "person.fill")
                            .font(.system(size: 46, weight: .bold))
                            .foregroundStyle(Color.appPrimary.opacity(0.7))
                    }
            }
        }
        .profileGlassSurface(cornerRadius: 80, tint: .white.opacity(0.24))
    }
}

#if os(iOS)
import UIKit
private typealias PlatformAvatarImage = UIImage
private extension Image {
    init(platformAvatarImage: PlatformAvatarImage) {
        self.init(uiImage: platformAvatarImage)
    }
}
#else
import AppKit
private typealias PlatformAvatarImage = NSImage
private extension Image {
    init(platformAvatarImage: PlatformAvatarImage) {
        self.init(nsImage: platformAvatarImage)
    }
}
#endif
