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
                    StorybookAvatarArtwork(style: activeAvatar, imageData: activeAvatarImageData)
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
    let style: UserAvatarStyle
    var imageData: Data? = nil

    var body: some View {
        ZStack {
            if let platformImage = PlatformAvatarImage(data: imageData ?? .init()) {
                Image(platformAvatarImage: platformImage)
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .overlay {
                        Circle().stroke(.white, lineWidth: .lineM)
                    }
            } else {
                StorybookCartoonAvatarFace(style: style)
                    .overlay {
                        Circle().stroke(.white, lineWidth: .lineM)
                    }
            }
        }
        .padding(.xxs)
        .profileGlassSurface(cornerRadius: 80, tint: .white.opacity(0.24))
    }
}

struct StorybookCartoonAvatarFace: View {
    let style: UserAvatarStyle

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color(hex: style.primaryHex), Color(hex: style.secondaryHex)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(skinColor)
                        .frame(width: 128, height: 128)
                        .overlay {
                            Circle().stroke(.white.opacity(0.28), lineWidth: 2)
                        }

                    hairView
                        .offset(y: -34)

                    VStack(spacing: 22) {
                        HStack(spacing: 24) {
                            eye
                            eye
                        }
                        mouthView
                    }
                    .offset(y: 8)
                }
                .padding(.top, 20)

                RoundedRectangle(cornerRadius: 18)
                    .fill(shirtColor)
                    .frame(width: 118, height: 58)
                    .overlay {
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(.white.opacity(0.25), lineWidth: 2)
                    }
                    .offset(y: -10)
            }
            .padding(.bottom, 18)
        }
        .clipShape(Circle())
    }

    private var eye: some View {
        ZStack {
            Circle().fill(.white).frame(width: 22, height: 22)
            Circle().fill(eyeColor).frame(width: 12, height: 12)
            Circle().fill(.black.opacity(0.85)).frame(width: 6, height: 6)
        }
    }

    @ViewBuilder
    private var mouthView: some View {
        switch style.accessorySymbolName {
        case "heart.fill":
            SmileArc(depth: 0.62)
                .stroke(.black.opacity(0.75), style: .init(lineWidth: 4, lineCap: .round))
                .frame(width: 34, height: 16)
        case "book.fill":
            RoundedRectangle(cornerRadius: 4)
                .fill(.black.opacity(0.7))
                .frame(width: 18, height: 6)
        case "wand.and.stars":
            SmileArc(depth: 0.35)
                .stroke(.black.opacity(0.75), style: .init(lineWidth: 4, lineCap: .round))
                .frame(width: 28, height: 12)
        case "sparkles":
            Circle()
                .fill(.black.opacity(0.72))
                .frame(width: 10, height: 10)
        case "globe.europe.africa.fill":
            SmileArc(depth: 0.76)
                .stroke(.black.opacity(0.8), style: .init(lineWidth: 4, lineCap: .round))
                .frame(width: 38, height: 18)
        default:
            SmileArc(depth: 0.5)
                .stroke(.black.opacity(0.75), style: .init(lineWidth: 4, lineCap: .round))
                .frame(width: 30, height: 14)
        }
    }

    @ViewBuilder
    private var hairView: some View {
        switch style.symbolName {
        case "teddybear.fill":
            HStack(spacing: 70) {
                Circle().fill(hairColor).frame(width: 26, height: 26)
                Circle().fill(hairColor).frame(width: 26, height: 26)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 34)
                    .fill(hairColor)
                    .frame(width: 112, height: 58)
            }
        case "figure.run":
            RoundedRectangle(cornerRadius: 34)
                .fill(hairColor)
                .frame(width: 116, height: 64)
                .overlay(alignment: .leading) {
                    Circle().fill(hairColor).frame(width: 38, height: 38).offset(x: -14, y: 6)
                }
        case "figure.play":
            RoundedRectangle(cornerRadius: 36)
                .fill(hairColor)
                .frame(width: 108, height: 56)
                .overlay(alignment: .trailing) {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(hairColor)
                        .frame(width: 32, height: 22)
                        .offset(x: 8, y: 10)
                }
        case "book.fill":
            RoundedRectangle(cornerRadius: 28)
                .fill(hairColor)
                .frame(width: 112, height: 54)
        case "sparkles":
            RoundedRectangle(cornerRadius: 32)
                .fill(hairColor)
                .frame(width: 104, height: 52)
                .overlay {
                    HStack(spacing: 10) {
                        Circle().fill(.white.opacity(0.25)).frame(width: 8, height: 8)
                        Circle().fill(.white.opacity(0.18)).frame(width: 6, height: 6)
                        Circle().fill(.white.opacity(0.25)).frame(width: 8, height: 8)
                    }
                }
        case "leaf.fill":
            Capsule()
                .fill(hairColor)
                .frame(width: 110, height: 52)
                .overlay(alignment: .top) {
                    Capsule().fill(hairColor.opacity(0.9)).frame(width: 44, height: 16).offset(y: -8)
                }
        case "moon.stars.fill":
            Capsule()
                .fill(hairColor)
                .frame(width: 104, height: 50)
                .overlay(alignment: .trailing) {
                    Circle().fill(hairColor).frame(width: 28, height: 28).offset(x: 6, y: 8)
                }
        case "paperplane.fill":
            RoundedRectangle(cornerRadius: 32)
                .fill(hairColor)
                .frame(width: 112, height: 52)
                .rotationEffect(.degrees(-4))
        default:
            Capsule()
                .fill(hairColor)
                .frame(width: 108, height: 50)
        }
    }

    private var hairColor: Color {
        Color(hex: style.primaryHex)
    }

    private var shirtColor: Color {
        Color(hex: style.secondaryHex)
    }

    private var eyeColor: Color {
        Color(hex: style.primaryHex)
    }

    private var skinColor: Color {
        switch style.gender {
        case .girl:
            return Color(hex: "FFD6BD")
        case .boy:
            return Color(hex: "F7CDA7")
        case .neutral:
            return Color(hex: "F6D1B3")
        }
    }
}

private struct SmileArc: Shape {
    var depth: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let start = CGPoint(x: rect.minX + 2, y: rect.minY + rect.height * (1 - depth))
        let end = CGPoint(x: rect.maxX - 2, y: rect.minY + rect.height * (1 - depth))
        let control = CGPoint(x: rect.midX, y: rect.maxY)
        path.move(to: start)
        path.addQuadCurve(to: end, control: control)
        return path
    }
}

private extension Color {
    init(hex: String) {
        let sanitized = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var value: UInt64 = 0
        Scanner(string: sanitized).scanHexInt64(&value)
        self.init(
            .sRGB,
            red: Double((value >> 16) & 0xFF) / 255,
            green: Double((value >> 8) & 0xFF) / 255,
            blue: Double(value & 0xFF) / 255,
            opacity: 1
        )
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
