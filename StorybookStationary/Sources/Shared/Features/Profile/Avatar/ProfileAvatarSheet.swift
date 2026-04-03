import ComposableArchitecture
import ImagePlayground
import SwiftUI

struct ProfileAvatarSheet: View {
    @Dependency(\.avatarImagePlaygroundClient) var avatarImagePlaygroundClient
    @Environment(\.supportsImagePlayground) private var supportsImagePlayground

    @Bindable var store: StoreOf<ProfileAvatarFeature>

    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()

                VStack(alignment: .leading, spacing: .xxl) {
                    Text("Avatar de \(store.activeProfileName)")
                        .font(.headingL.weight(.bold))
                        .foregroundStyle(Color.appPrimary)

                    HStack {
                        StorybookAvatarArtwork(
                            imageData: store.generatedAvatarImageData ?? store.originalAvatarImageData
                        )
                        .frame(maxWidth: 200)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)

                    VStack(alignment: .leading, spacing: .m) {
                        Text("Genre")
                            .font(.labelM.weight(.black))
                            .textCase(.uppercase)
                            .foregroundStyle(Color.outline)

                        Picker(
                            "Genre",
                            selection: Binding(
                                get: { store.selectedGender },
                                set: { store.send(.genderChanged($0)) }
                            )
                        ) {
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
                            Text("\(store.selectedAge) ans")
                                .font(.bodyS.weight(.semibold))
                                .foregroundStyle(Color.onSurfaceVariant)
                        }

                        Slider(
                            value: Binding(
                                get: { Double(store.selectedAge) },
                                set: { store.send(.ageChanged(Int($0.rounded()))) }
                            ),
                            in: 3...7,
                            step: 1
                        )
                        .tint(Color.appPrimary)
                    }

                    if let message = store.message {
                        Text(message)
                            .font(.bodyS.weight(.semibold))
                            .foregroundStyle(Color.onSurfaceVariant)
                    }

                    HStack(spacing: .m) {
                        Button {
                            guard supportsImagePlayground else {
                                store.send(.playgroundFailed("Image Playground n'est pas disponible sur cet appareil."))
                                return
                            }
                            store.send(.generateButtonTapped)
                        } label: {
                            HStack(spacing: .s) {
                                if store.isGenerating || store.isLoadingGeneratedImage {
                                    ProgressView()
                                } else {
                                    Image(systemName: "wand.and.stars")
                                    Text("Generer")
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .disabled(store.isGenerating || store.isLoadingGeneratedImage || store.isSaving)
                        .buttonStyle(.glassProminent)

                        Button {
                            store.send(.saveButtonTapped)
                        } label: {
                            HStack(spacing: .s) {
                                if store.isSaving {
                                    ProgressView()
                                } else {
                                    Image(systemName: "checkmark")
                                    Text("Valider")
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .disabled(
                            store.isGenerating
                                || store.isLoadingGeneratedImage
                                || store.isSaving
                                || store.generatedAvatarImageData == nil
                                || store.generatedAvatarImageData == store.originalAvatarImageData
                        )
                        .buttonStyle(.glassProminent)
                    }

                    Spacer(minLength: 0)

                    Button("Fermer") {
                        store.send(.closeButtonTapped)
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
            isPresented: Binding(
                get: { store.playgroundSeed != nil },
                set: { _ in }
            ),
            concepts: playgroundConcepts,
            onCompletion: { url in
                store.send(.playgroundCompleted(url))
            },
            onCancellation: {
                store.send(.playgroundCancelled)
            }
        )
    }

    private var playgroundConcepts: [ImagePlaygroundConcept] {
        guard let seed = store.playgroundSeed else { return [] }
        return avatarImagePlaygroundClient.concepts(seed)
    }
}
