import ComposableArchitecture
import SwiftUI

struct StorybookProfileManagementSection: View {
    @Bindable var store: StoreOf<StorybookStationaryFeature>
    
    private var sortedProfiles: [UserProfile] {
        store.profiles.sorted {
            $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: .l) {
            Text("GESTION DES PROFILS")
                .font(.sectionTitle.weight(.black))
                .foregroundStyle(Color.appPrimary)

            profileList
            createProfileForm
        }
        .padding(.xxl)
        .profileGlassSurface(tint: Color.appPrimary.opacity(0.1))
    }

    private var profileList: some View {
        VStack(alignment: .leading, spacing: .m) {
            Text("Tous les profils")
                .font(.labelM.weight(.black))
                .textCase(.uppercase)
                .foregroundStyle(Color.outline)

            VStack(spacing: .m) {
                ForEach(sortedProfiles, id: \.id) { profile in
                    Button {
                        store.send(.selectProfileTapped(profile.id))
                    } label: {
                        HStack(spacing: .m) {
                            ProfileMiniAvatar(style: profile.avatarStyle, imageData: profile.avatarImageData)
                                .frame(width: 42, height: 42)
                                .id(profile.avatarStyle)
                                .transition(.opacity.combined(with: .scale))
                                .animation(.spring(duration: 0.35, bounce: 0.28), value: profile.avatarStyle)

                            VStack(alignment: .leading, spacing: .xxs) {
                                Text(profile.name)
                                    .font(.bodyM.weight(.semibold))
                                    .foregroundStyle(Color.onSurface)
                                if profile.id == store.activeProfileID {
                                    Text("Actif")
                                        .font(.labelS.weight(.black))
                                        .textCase(.uppercase)
                                        .foregroundStyle(Color.appPrimary)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)

                            ProfileSelectionIndicator(isActive: profile.id == store.activeProfileID)
                        }
                        .padding(.l)
                        .profileGlassSurface(
                            cornerRadius: .cornerXL,
                            tint: Color.white.opacity(0.12)
                        )
                        .contentShape(RoundedRectangle(tokenRadius: .cornerXL))
                    }
                    .buttonStyle(.plain)
                    .accessibilityElement(children: .combine)
                    .accessibilityAddTraits(.isButton)
                }
            }
        }
    }

    private var createProfileForm: some View {
        VStack(alignment: .leading, spacing: .m) {
            Text("Creer un profil")
                .font(.labelM.weight(.black))
                .textCase(.uppercase)
                .foregroundStyle(Color.outline)

            Group {
                #if os(iOS)
                TextField("Nouveau prenom", text: $store.newProfileName)
                    .textInputAutocapitalization(.words)
                    .disableAutocorrection(true)
                #else
                TextField("Nouveau prenom", text: $store.newProfileName)
                #endif
            }
            .font(.bodyM.weight(.semibold))
            .padding(.m)
            .profileGlassSurface(
                cornerRadius: .cornerXL,
                tint: Color.white.opacity(0.14),
                interactive: true
            )

            Button {
                store.send(.createProfileTapped)
            } label: {
                HStack(spacing: .m) {
                    if store.isPersistingProfile {
                        ProgressView()
                    } else {
                        Text("Ajouter")
                            .font(.labelM.weight(.black))
                            .textCase(.uppercase)
                        Image(systemName: "plus")
                            .font(.bodyM.weight(.black))
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .disabled(
                store.isPersistingProfile
                || store.newProfileName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            )
            .buttonStyle(.glassProminent)
        }
    }
}

private struct ProfileSelectionIndicator: View {
    let isActive: Bool

    var body: some View {
        Image(systemName: isActive ? "checkmark.circle.fill" : "circle")
            .foregroundStyle(isActive ? Color.appPrimary : Color.outlineVariant)
            .font(.bodyM.weight(.bold))
            .scaleEffect(isActive ? 1.08 : 1.0)
            .contentTransition(.symbolEffect(.replace))
            .animation(.snappy(duration: 0.22), value: isActive)
    }
}

private struct ProfileMiniAvatar: View {
    let style: UserAvatarStyle
    let imageData: Data

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if let platformImage = PlatformAvatarImage(data: imageData) {
                Image(platformAvatarImage: platformImage)
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .overlay {
                        Circle().stroke(.white.opacity(0.95), lineWidth: .lineS)
                    }
            } else {
                StorybookCartoonAvatarFace(style: style)
                    .overlay {
                        Circle().stroke(.white.opacity(0.95), lineWidth: .lineS)
                    }
            }

            Circle()
                .fill(Color.background.opacity(0.95))
                .frame(width: 16, height: 16)
                .overlay {
                    Image(systemName: style.accessorySymbolName)
                        .font(.system(size: 8, weight: .bold))
                        .foregroundStyle(Color.appPrimary)
                }
                .overlay {
                    Circle().stroke(.white, lineWidth: 1)
                }
        }
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
