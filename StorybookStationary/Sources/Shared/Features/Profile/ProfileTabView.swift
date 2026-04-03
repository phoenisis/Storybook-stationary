import ComposableArchitecture
import ImagePlayground
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
                        infoMessageSection
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
                    activeAvatar: store.activeAvatar,
                    activeAvatarImageData: store.activeAvatarImageData,
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
                    activeAvatar: store.activeAvatar,
                    activeAvatarImageData: store.activeAvatarImageData,
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

struct ProfileAvatarSheet: View {
    @Dependency(\.avatarImagePlaygroundClient) var avatarImagePlaygroundClient
    @Environment(\.supportsImagePlayground) private var supportsImagePlayground

    @Binding var state: StorybookStationaryFeature.Destination.AvatarEditor
    let activeProfileName: String
    let onClose: () -> Void
    let onAgeChanged: (Int) -> Void
    let onGenderChanged: (AvatarGender) -> Void
    let onGenerate: () -> Void
    let onPlaygroundCompleted: (URL) -> Void
    let onPlaygroundCancelled: () -> Void
    let onPlaygroundFailed: (String) -> Void
    let onSave: () -> Void

    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()

                VStack(alignment: .leading, spacing: .xxl) {
                    Text("Avatar de \(activeProfileName)")
                        .font(.headingL.weight(.bold))
                        .foregroundStyle(Color.appPrimary)

                    HStack {
                        StorybookAvatarArtwork(
                            style: state.generatedAvatar ?? state.originalAvatar,
                            imageData: state.generatedAvatarImageData ?? state.originalAvatarImageData
                        )
                        .frame(maxWidth: 200)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                   

                    VStack(alignment: .leading, spacing: .m) {
                        Text("Genre")
                            .font(.labelM.weight(.black))
                            .textCase(.uppercase)
                            .foregroundStyle(Color.outline)

                        Picker("Genre", selection: genderBinding) {
                            ForEach(AvatarGender.allCases) { gender in
                                Text(gender.title).tag(gender)
                            }
                        }
                        .pickerStyle(.segmented)
                    }

                    VStack(alignment: .leading, spacing: .m) {
                        HStack {
                            Text("Age")
                                .font(.labelM.weight(.black))
                                .textCase(.uppercase)
                                .foregroundStyle(Color.outline)
                            Spacer(minLength: 0)
                            Text("\(state.selectedAge) ans")
                                .font(.bodyS.weight(.semibold))
                                .foregroundStyle(Color.onSurfaceVariant)
                        }

                        Slider(
                            value: ageBinding,
                            in: 3...7,
                            step: 1
                        )
                        .tint(Color.appPrimary)
                    }

                    if let message = state.message {
                        Text(message)
                            .font(.bodyS.weight(.semibold))
                            .foregroundStyle(Color.onSurfaceVariant)
                    }

                    HStack(spacing: .m) {
                        Button {
                            guard supportsImagePlayground else {
                                onPlaygroundFailed("Image Playground n'est pas disponible sur cet appareil.")
                                return
                            }
                            onGenerate()
                        } label: {
                            HStack(spacing: .s) {
                                if state.isGenerating || state.isLoadingGeneratedImage {
                                    ProgressView()
                                } else {
                                    Image(systemName: "wand.and.stars")
                                    Text("Generer")
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .disabled(state.isGenerating || state.isLoadingGeneratedImage || state.isSaving)
                        .buttonStyle(.glassProminent)

                        Button {
                            onSave()
                        } label: {
                            HStack(spacing: .s) {
                                if state.isSaving {
                                    ProgressView()
                                } else {
                                    Image(systemName: "checkmark")
                                    Text("Valider")
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .disabled(
                            state.isGenerating
                                || state.isLoadingGeneratedImage
                                || state.isSaving
                                || state.generatedAvatarImageData == nil
                                || state.generatedAvatarImageData == state.originalAvatarImageData
                        )
                        .buttonStyle(.glassProminent)
                    }

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
            .navigationTitle("Changer d'avatar")
            .paperInlineNavigationBarTitleDisplayMode()
        }
        .imagePlaygroundSheet(
            isPresented: isImagePlaygroundPresented,
            concepts: playgroundConcepts,
            onCompletion: { url in
                onPlaygroundCompleted(url)
            },
            onCancellation: {
                onPlaygroundCancelled()
            }
        )
    }

    private var ageBinding: Binding<Double> {
        Binding<Double>(
            get: { Double(state.selectedAge) },
            set: { onAgeChanged(Int($0.rounded())) }
        )
    }

    private var genderBinding: Binding<AvatarGender> {
        Binding<AvatarGender>(
            get: { state.selectedGender },
            set: { onGenderChanged($0) }
        )
    }

    private var isImagePlaygroundPresented: Binding<Bool> {
        Binding(
            get: { state.playgroundSeed != nil },
            set: { _ in }
        )
    }

    private var playgroundConcepts: [ImagePlaygroundConcept] {
        guard let seed = state.playgroundSeed else { return [] }
        return avatarImagePlaygroundClient.concepts(seed)
    }
}
