import ComposableArchitecture
import SwiftUI

struct StorybookProfileManagementSection: View {
    @Bindable var store: StoreOf<StorybookStationaryFeature>

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
                ForEach(store.profiles) { profile in
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
                        .frame(maxWidth: .infinity, alignment: .leading)

                        Image(systemName: profile.id == store.activeProfileID ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(profile.id == store.activeProfileID ? Color.appPrimary : Color.outlineVariant)
                    }
                    .padding(.l)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .profileGlassSurface(
                        cornerRadius: .cornerXL,
                        tint: Color.white.opacity(0.12),
                        interactive: true
                    )
                    .contentShape(RoundedRectangle(tokenRadius: .cornerXL))
                    .onTapGesture {
                        store.send(.selectProfileTapped(profile.id))
                    }
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
