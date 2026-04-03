import ComposableArchitecture
import SwiftUI

struct StorybookStationaryProfileTabView: View {
    @Bindable var store: StoreOf<StorybookStationaryFeature>
    @State private var availableWidth: CGFloat = 0

    private var isWideLayout: Bool {
        availableWidth >= 900
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: .xxl) {
                        topProfileSection
//                        infoMessageSection
                        StorybookProfileThemesSection(
                            themes: store.profileThemes,
                            isWideLayout: isWideLayout,
                            onThemeTapped: { store.send(.profileThemeTapped($0)) }
                        )
                        StorybookProfileManagementSection(store: store)

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
            .navigationTitle("Mon profil")
            .paperInlineNavigationBarTitleDisplayMode()
            .onGeometryChange(for: CGFloat.self) { proxy in
                proxy.size.width
            } action: { width in
                availableWidth = width
            }
        }
    }

    @ViewBuilder
    private var topProfileSection: some View {
        if isWideLayout {
            HStack(alignment: .top, spacing: .xxl) {
                StorybookProfileHeroSection(
                    activeProfileName: store.activeProfileName,
                    onAvatarTapped: { store.send(.avatarTapped) }
                )
                .frame(maxWidth: 270)

                StorybookProfileStatsSection(
                    stats: store.profileStats,
                    onStatTapped: { store.send(.profileStatTapped($0)) }
                )
                .frame(maxWidth: .infinity)
            }
        } else {
            VStack(alignment: .leading, spacing: .l) {
                StorybookProfileHeroSection(
                    activeProfileName: store.activeProfileName,
                    onAvatarTapped: { store.send(.avatarTapped) }
                )
                StorybookProfileStatsSection(
                    stats: store.profileStats,
                    onStatTapped: { store.send(.profileStatTapped($0)) }
                )
            }
        }
    }

    @ViewBuilder
    private var infoMessageSection: some View {
        if let message = store.profileInfoMessage {
            HStack(spacing: .m) {
                Image(systemName: "lightbulb.fill")
                    .foregroundStyle(Color.appSecondary)
                Text(message)
                    .font(.bodyS.weight(.semibold))
                    .foregroundStyle(Color.onSurface)
                Spacer(minLength: 0)
                Button {
                    store.send(.infoMessageDismissed)
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color.outline)
                }
                .buttonStyle(.plain)
            }
            .padding(.l)
            .profileGlassSurface(cornerRadius: .cornerXL, tint: Color.appSecondary.opacity(0.12))
        }
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
