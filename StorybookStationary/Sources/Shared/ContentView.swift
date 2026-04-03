import ComposableArchitecture
import SwiftUI
import SwiftUINavigation

struct ContentView: View {
    @Bindable var store: StoreOf<StorybookStationaryFeature>

    var body: some View {
        TabView(selection: $store.selectedTab) {
            mainLibraryPage
                .tabItem {
                    Label("Library", systemImage: "books.vertical.fill")
                }
                .tag(StorybookStationaryFeature.Tab.library)

            placeholderPage(title: "Writing", icon: "checkmark.seal.fill")
                .tabItem {
                    Label("Writing", systemImage: "checkmark.seal.fill")
                }
                .tag(StorybookStationaryFeature.Tab.writing)

            placeholderPage(title: "Awards", icon: "trophy.fill")
                .tabItem {
                    Label("Awards", systemImage: "trophy.fill")
                }
                .tag(StorybookStationaryFeature.Tab.awards)

            placeholderPage(title: "Profile", icon: "person.fill")
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(StorybookStationaryFeature.Tab.profile)
        }
        .sheet(
            item: Binding(projectedValue: $store.destination).profileSettings,
            id: \.id
        ) { $profileSettings in
            ProfileSettingsSheet(
                keepAudioEnabled: $profileSettings.keepAudioEnabled,
                onClose: { store.send(.destinationDismissed) }
            )
        }
        .paperPlaygroundTabBarStyle()
    }

    private var mainLibraryPage: some View {
        NavigationStack(path: $store.path) {
            ZStack {
                Color.background.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: .jumbo) {
                        topBar
                        typographyAndColors
                        buttonsAndStates
                        cardsAndContainers
                        interactiveElements
                    }
                    .padding(.horizontal, .xxxl)
                    .padding(.top, .xxxl)
                    .padding(.bottom, .xxxl)
                }

                PaperGrainOverlay()
            }
            .navigationTitle("Library")
            .paperInlineNavigationBarTitleDisplayMode()
            .navigationDestination(for: StorybookStationaryFeature.Route.self) { route in
                switch route {
                case let .lessonDetail(detail):
                    LessonDetailView(detail: detail)
                }
            }
        }
    }

    private func placeholderPage(title: String, icon: String) -> some View {
        ZStack {
            Color.background.ignoresSafeArea()
            VStack(spacing: .l) {
                Image(systemName: icon)
                    .font(.displayHero.weight(.black))
                    .foregroundStyle(Color.appPrimary)
                Text(title)
                    .font(.headingL.weight(.bold))
                    .foregroundStyle(Color.onSurface)
            }
            .padding(.xxxl)
            .paperCard()
            .padding(.xxxl)
        }
    }

    private var topBar: some View {
        HStack(spacing: .xl) {
            Image(systemName: "line.3.horizontal")
                .font(.title3.weight(.black))
                .foregroundStyle(Color.appPrimary)

            Text("Bibliotheque")
                .font(.appTitle.weight(.black))
                .tracking(.trackCompact)
                .textCase(.uppercase)
                .foregroundStyle(Color.appPrimary)

            Spacer(minLength: 0)

            Button("Lecon") {
                store.send(.libraryDetailTapped)
            }
            .font(.labelS.weight(.black))
            .textCase(.uppercase)
            .buttonStyle(StickerDepthButtonStyle(color: .appPrimary))

            Button {
                store.send(.profileTapped)
            } label: {
                Circle()
                    .fill(Color.appPrimaryContainer)
                    .frame(width: .avatar, height: .avatar)
                    .overlay {
                        Image(systemName: "face.smiling.fill")
                            .foregroundStyle(Color.appOnPrimaryContainer)
                    }
                    .overlay {
                        Circle().stroke(Color.appPrimary, lineWidth: .lineS)
                    }
            }
        }
        .padding(.horizontal, .xl)
        .padding(.vertical, .l)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(tokenRadius: .cornerPill))
        .overlay(alignment: .bottom) {
            RoundedRectangle(tokenRadius: .cornerPill)
                .stroke(
                    Color.appPrimary.opacity(.opacitySoft),
                    style: StrokeStyle(tokenLineWidth: .lineS, dash: [.xs, .xxs])
                )
        }
        .notebookShadow()
    }

    private var typographyAndColors: some View {
        VStack(alignment: .leading, spacing: .xl) {
            SectionHeader(icon: "paintpalette.fill", title: "Typography & Colors", color: Color.appSecondary)

            VStack(alignment: .leading, spacing: .xxxl) {
                Text("Aa")
                    .font(.displayHero.weight(.black))
                    .tracking(.trackDisplay)
                    .foregroundStyle(Color.appPrimary)
                    .minimumScaleFactor(.minimumScale)
                    .lineLimit(1)

                Text("Exploration Creative")
                    .font(.headingL.weight(.bold))
                    .tracking(.trackHeading)
                    .foregroundStyle(Color.onSurface)

                Text("L'apprentissage par le jeu est au coeur de notre methode pedagogique.")
                    .font(.bodyM)
                    .foregroundStyle(Color.onSurfaceVariant)
                    .lineSpacing(.appLineSpacing)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: .m) {
                    PaletteSwatch(name: "Primary", color: Color.appPrimary, textColor: .white)
                    PaletteSwatch(name: "Secondary", color: Color.appSecondary, textColor: .white)
                    PaletteSwatch(name: "Tertiary", color: .tertiary, textColor: .white)
                    PaletteSwatch(name: "Surface", color: Color.surfaceLow, textColor: Color.onSurface)
                }
            }
            .padding(.xxl)
            .paperCard()
        }
    }

    private var buttonsAndStates: some View {
        VStack(alignment: .leading, spacing: .xl) {
            SectionHeader(icon: "cursorarrow.click.badge.clock", title: "Buttons & States", color: Color.tertiary)

            VStack(alignment: .leading, spacing: .xxxl) {
                Text("Primary sticker states")
                    .font(.labelM.weight(.black))
                    .textCase(.uppercase)
                    .foregroundStyle(Color.outline)

                HStack(spacing: .m) {
                    buttonStateItem("Normal", color: Color.appPrimary)
                    buttonStateItem("Pressed", color: Color.appPrimaryDim)
                }

                HStack(spacing: .m) {
                    buttonStateItem("Disabled", color: Color.appPrimary.opacity(.opacityMedium), disabled: true)
                    buttonStateItem("Hover", color: Color.appPrimary)
                }

                Divider().overlay(Color.outlineVariant.opacity(.opacitySoft))

                HStack(spacing: .l) {
                    Button("Commencer") {}
                        .font(.labelM.weight(.black))
                        .textCase(.uppercase)
                        .buttonStyle(StickerDepthButtonStyle(color: Color.appPrimary))

                    Button("Recompenses") {}
                        .font(.labelM.weight(.black))
                        .textCase(.uppercase)
                        .buttonStyle(StickerDepthButtonStyle(color: Color.appSecondary))
                }

                HStack(spacing: .l) {
                    Button {
                        store.send(.binding(.set(\.audioLevel, min(1.0, store.audioLevel + .audioStep))))
                    } label: {
                        Image(systemName: "play.fill")
                            .font(.bodyM.weight(.black))
                            .frame(width: .iconButton, height: .iconButton)
                            .background(Color.tertiaryContainer)
                            .foregroundStyle(Color.onTertiaryContainer)
                            .clipShape(Circle())
                    }
                    .buttonStyle(StickerDepthButtonStyle(color: Color.tertiaryDim, cornerRadius: .cornerXXL))

                    GeometryReader { proxy in
                        let width = proxy.size.width
                        ZStack(alignment: .leading) {
                            Capsule().fill(Color.surfaceHigh)
                            Capsule().fill(Color.appPrimary)
                                .frame(width: width * store.audioLevel)
                        }
                    }
                    .frame(height: .sliderTrackHeight)
                }
            }
            .padding(.xxl)
            .background(Color.surfaceLow)
            .clipShape(RoundedRectangle(tokenRadius: .cornerXXXL))
            .overlay {
                RoundedRectangle(tokenRadius: .cornerXXXL)
                    .stroke(.white, lineWidth: .lineM)
            }
            .notebookShadow()
        }
    }

    private var cardsAndContainers: some View {
        VStack(alignment: .leading, spacing: .xl) {
            SectionHeader(icon: "book.pages.fill", title: "Cards & Containers", color: Color.appPrimary)

            VStack(spacing: .l) {
                SpiralNotebookCard(
                    title: "Lecon du jour",
                    description: "Cette carte utilise une reliure visible et des lignes douces pour ancrer l'experience dans un univers papier tactile."
                )

                HStack(spacing: .l) {
                    VStack(alignment: .leading, spacing: .xs) {
                        Text("Progres")
                            .font(.labelM.weight(.black))
                            .textCase(.uppercase)
                            .foregroundStyle(Color.appOnSecondaryContainer)
                        Text("85%")
                            .font(.metricValue.weight(.black))
                            .tracking(.trackMetric)
                            .foregroundStyle(Color.appOnSecondaryContainer)
                        Text("Niveau Maitre des Lettres")
                            .font(.bodyS)
                            .foregroundStyle(Color.appOnSecondaryContainer)
                    }
                    Spacer(minLength: 0)
                }
                .padding(.xxl)
                .background(Color.appSecondaryContainer)
                .clipShape(RoundedRectangle(tokenRadius: .cornerXL))
                .overlay(alignment: .topTrailing) {
                    Circle()
                        .fill(.tertiary)
                        .frame(width: .badge, height: .badge)
                        .overlay {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.white)
                        }
                        .offset(x: .s, y: -.s)
                        .rotationEffect(.degrees(.stickerRotation))
                        .shadow(color: Color.tertiary.opacity(.opacityAccent), radius: 0, x: 0, y: .lineM)
                }
                .notebookShadow()
            }
        }
    }

    private var interactiveElements: some View {
        VStack(alignment: .leading, spacing: .xl) {
            SectionHeader(icon: "puzzlepiece.extension.fill", title: "Interactive Elements", color: Color.appSecondary)

            HStack(spacing: .m) {
                ProgressDot(state: .filled)
                ProgressDot(state: .filled)
                ProgressDot(state: .current)
                ProgressDot(state: .empty)
                ProgressDot(state: .empty)
            }
            .frame(height: .progressRowHeight)
            .padding(.horizontal, .l)
            .padding(.vertical, .m)
            .background(Color.surfaceLow)
            .clipShape(RoundedRectangle(tokenRadius: .cornerL))
            .overlay {
                RoundedRectangle(tokenRadius: .cornerL)
                    .stroke(.white, lineWidth: .lineS)
            }
            .notebookShadow()
        }
    }

    @ViewBuilder
    private func buttonStateItem(_ title: String, color: Color, disabled: Bool = false) -> some View {
        VStack(spacing: .xs) {
            Text(title)
                .font(.labelS.weight(.black))
                .textCase(.uppercase)
                .frame(maxWidth: .infinity)
                .padding(.vertical, .m)
                .background(color)
                .foregroundStyle(.white.opacity(disabled ? .opacityDisabled : 1.0))
                .clipShape(RoundedRectangle(tokenRadius: .cornerS))
                .shadow(color: disabled ? .clear : color.opacity(.opacityStrong), radius: 0, x: 0, y: .lineM)
            StickerStatePill(
                name: disabled ? "Disabled" : "Enabled",
                fill: Color.surfaceLow,
                text: Color.outline
            )
        }
    }
}

private struct LessonDetailView: View {
    let detail: StorybookStationaryFeature.Route.LessonDetail

    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            VStack(alignment: .leading, spacing: .l) {
                Text(detail.title)
                    .font(.headingL.weight(.bold))
                    .foregroundStyle(Color.appPrimary)

                Text(detail.description)
                    .font(.bodyM)
                    .foregroundStyle(Color.onSurfaceVariant)
                    .lineSpacing(.appLineSpacing)
            }
            .padding(.xxxl)
            .paperCard()
            .padding(.xxxl)
        }
        .navigationTitle("Lesson")
        .paperInlineNavigationBarTitleDisplayMode()
    }
}

private struct ProfileSettingsSheet: View {
    @Binding var keepAudioEnabled: Bool
    let onClose: () -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Preferences") {
                    Toggle("Keep audio preview enabled", isOn: $keepAudioEnabled)
                }
            }
            .navigationTitle("Profile Settings")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done", action: onClose)
                }
            }
        }
    }
}

private extension View {
    @ViewBuilder
    func paperInlineNavigationBarTitleDisplayMode() -> some View {
        #if os(iOS)
        self.navigationBarTitleDisplayMode(.inline)
        #else
        self
        #endif
    }
}

#Preview {
    ContentView(
        store: Store(initialState: StorybookStationaryFeature.State()) {
            StorybookStationaryFeature()
        }
    )
}
