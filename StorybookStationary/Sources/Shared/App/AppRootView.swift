import ComposableArchitecture
import SwiftUI

struct AppRootView: View {
    @Bindable var store: StoreOf<AppFeature>

    var body: some View {
        Group {
            switch store.route {
            case .loading:
                LoadingView()

            case .onboarding:
                if let onboardingStore = store.scope(state: \.route.onboarding, action: \.onboarding) {
                    OnboardingView(store: onboardingStore)
                }

            case .main:
                if let mainStore = store.scope(state: \.route.main, action: \.main) {
                    ContentView(store: mainStore)
                }
            }
        }
        .task {
            store.send(.task)
        }
    }
}

private struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.surface.opacity(0.5).ignoresSafeArea()

            VStack(spacing: .l) {
                ProgressView()
                    .controlSize(.large)
                Text("Chargement...")
                    .font(.bodyM.weight(.semibold))
                    .foregroundStyle(Color.onSurfaceVariant)
            }
            .padding(.xxxl)
            .background(Color.background)
            .clipShape(RoundedRectangle(tokenRadius: .cornerDrawer))
            .overlay {
                RoundedRectangle(tokenRadius: .cornerDrawer)
                    .stroke(.white, lineWidth: .lineM)
            }
            .notebookShadow()
            .padding(.xxxl)
        }
    }
}

private struct OnboardingView: View {
    @Bindable var store: StoreOf<OnboardingFeature>

    var body: some View {
        ZStack {
            Color.surface.opacity(0.5).ignoresSafeArea()

            VStack(spacing: .xxl) {
                VStack(spacing: .m) {
                    Text("Storybook Stationary")
                        .font(.displayHero.weight(.black))
                        .foregroundStyle(Color.appPrimary)
                    RoundedRectangle(tokenRadius: .cornerPill)
                        .fill(.tertiary)
                        .frame(width: 92, height: 7)
                }
                .padding(.top, .xxl)
                .multilineTextAlignment(.leading)

                VStack(alignment: .leading, spacing: .m) {
                    Text("Quel est ton nom ?")
                        .font(.headingL.weight(.bold))
                        .foregroundStyle(Color.onSurface)

                    nameField

                    if let validationMessage = store.validationMessage {
                        Text(validationMessage)
                            .font(.bodyS.weight(.semibold))
                            .foregroundStyle(.red)
                    }
                }

                Button {
                    store.send(.startButtonTapped)
                } label: {
                    HStack(spacing: .m) {
                        if store.isSaving {
                            ProgressView()
                                .tint(Color.onTertiaryContainer)
                        } else {
                            Text("START")
                                .font(.labelM.weight(.black))
                                .textCase(.uppercase)
                            Image(systemName: "arrow.right")
                                .font(.bodyM.weight(.black))
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .disabled(store.isSaving || store.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .font(.labelM.weight(.black))
                .textCase(.uppercase)
                .buttonStyle(StickerDepthButtonStyle(color: .tertiary))
                .padding(.top, .s)

                HStack(spacing: .xs) {
                    Image(systemName: "checkmark.shield.fill")
                        .foregroundStyle(Color.onSurfaceVariant)
                    Text("Tes parents sont d'accord !")
                        .font(.bodyS.weight(.semibold))
                        .foregroundStyle(Color.onSurfaceVariant)
                }
                .padding(.bottom, .xxl)
            }
            .frame(maxWidth: 350)
            .padding(.xxxl)
            .background(Color.background)
            .clipShape(RoundedRectangle(tokenRadius: .cornerDrawer))
            .overlay {
                RoundedRectangle(tokenRadius: .cornerDrawer)
                    .stroke(.white, lineWidth: .lineM)
            }
            .notebookShadow()
            .padding(.l)
        }
    }

    @ViewBuilder
    private var nameField: some View {
        #if os(iOS)
        TextField("Ton prenom ici...", text: $store.name)
            .textInputAutocapitalization(.words)
            .disableAutocorrection(true)
            .font(.headingL.weight(.bold))
            .padding(.m)
            .background(Color.surfaceLow)
            .clipShape(RoundedRectangle(tokenRadius: .cornerXL))
            .overlay {
                RoundedRectangle(tokenRadius: .cornerXL)
                    .stroke(Color.outlineVariant, lineWidth: .lineS)
            }
        #else
        TextField("Ton prenom ici...", text: $store.name)
            .font(.headingL.weight(.bold))
            .padding(.m)
            .background(Color.surfaceLow)
            .clipShape(RoundedRectangle(tokenRadius: .cornerXL))
            .overlay {
                RoundedRectangle(tokenRadius: .cornerXL)
                    .stroke(Color.outlineVariant, lineWidth: .lineS)
            }
        #endif
    }
}

#Preview {
    AppRootView(
        store: Store(initialState: AppFeature.State()) {
            AppFeature()
        }
    )
}
