import ComposableArchitecture
import SwiftUI

struct StorybookStationaryProfileTabView: View {
    @Bindable var store: StoreOf<StorybookStationaryFeature>

    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: .xxl) {
                        profileHeader
                        profileList
                        createProfileSection

                        if let message = store.profileMessage {
                            Text(message)
                                .font(.bodyS.weight(.semibold))
                                .foregroundStyle(.red)
                        }
                    }
                    .padding(.xxxl)
                }

                PaperGrainOverlay()
            }
            .navigationTitle("Profile")
            .paperInlineNavigationBarTitleDisplayMode()
        }
    }

    private var profileHeader: some View {
        VStack(alignment: .leading, spacing: .xs) {
            Text("Profil actif")
                .font(.labelM.weight(.black))
                .textCase(.uppercase)
                .foregroundStyle(Color.outline)

            Text(store.activeProfileName.isEmpty ? "Aucun profil" : store.activeProfileName)
                .font(.headingL.weight(.bold))
                .foregroundStyle(Color.appPrimary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.xxl)
        .paperCard()
    }

    private var profileList: some View {
        VStack(alignment: .leading, spacing: .m) {
            Text("Tous les profils")
                .font(.labelM.weight(.black))
                .textCase(.uppercase)
                .foregroundStyle(Color.outline)

            VStack(spacing: .m) {
                ForEach(store.profiles) { profile in
                    Button {
                        store.send(.selectProfileTapped(profile.id))
                    } label: {
                        HStack(spacing: .m) {
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

                            Spacer(minLength: 0)

                            Image(systemName: profile.id == store.activeProfileID ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(profile.id == store.activeProfileID ? Color.appPrimary : Color.outlineVariant)
                        }
                        .padding(.l)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.surfaceLow)
                        .clipShape(RoundedRectangle(tokenRadius: .cornerXL))
                    }
                    .buttonStyle(.plain)
                    .disabled(store.isPersistingProfile)
                }
            }
        }
    }

    private var createProfileSection: some View {
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
            .background(Color.surfaceLow)
            .clipShape(RoundedRectangle(tokenRadius: .cornerXL))
            .overlay {
                RoundedRectangle(tokenRadius: .cornerXL)
                    .stroke(Color.outlineVariant, lineWidth: .lineS)
            }

            Button {
                store.send(.createProfileTapped)
            } label: {
                HStack(spacing: .m) {
                    if store.isPersistingProfile {
                        ProgressView()
                            .tint(Color.onTertiaryContainer)
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
            .buttonStyle(StickerDepthButtonStyle(color: .tertiary))
        }
        .padding(.xxl)
        .background(Color.background)
        .clipShape(RoundedRectangle(tokenRadius: .cornerXXXL))
        .overlay {
            RoundedRectangle(tokenRadius: .cornerXXXL)
                .stroke(.white, lineWidth: .lineM)
        }
        .notebookShadow()
    }
}

struct ProfileSettingsSheet: View {
    @Binding var keepAudioEnabled: Bool
    let onClose: () -> Void

    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()

                VStack(alignment: .leading, spacing: .xxl) {
                    Text("Reglages")
                        .font(.headingL.weight(.bold))
                        .foregroundStyle(Color.appPrimary)

                    Toggle("Garder l'audio actif", isOn: $keepAudioEnabled)
                        .toggleStyle(.switch)

                    Spacer(minLength: 0)

                    Button("Fermer") {
                        onClose()
                    }
                    .font(.labelM.weight(.black))
                    .textCase(.uppercase)
                    .buttonStyle(StickerDepthButtonStyle(color: Color.appPrimary))
                }
                .padding(.xxxl)
            }
            .navigationTitle("Profile")
            .paperInlineNavigationBarTitleDisplayMode()
        }
    }
}
