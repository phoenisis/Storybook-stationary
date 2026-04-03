import CasePaths
import ComposableArchitecture
import Foundation
import IdentifiedCollections

@Reducer
struct AppFeature {
    @Dependency(\.userProfileClient) var userProfileClient

    @ObservableState
    struct State: Equatable {
        var route: Route = .loading

        var onboarding: OnboardingFeature.State? {
            get {
                guard case let .onboarding(state) = route else { return nil }
                return state
            }
            set {
                guard let newValue, case .onboarding = route else { return }
                route = .onboarding(newValue)
            }
        }

        var main: StorybookStationaryFeature.State? {
            get {
                guard case let .main(state) = route else { return nil }
                return state
            }
            set {
                guard let newValue, case .main = route else { return }
                route = .main(newValue)
            }
        }
    }

    @CasePathable
    @dynamicMemberLookup
    enum Route: Equatable {
        case loading
        case onboarding(OnboardingFeature.State)
        case main(StorybookStationaryFeature.State)
    }

    enum Action: Equatable {
        case onboarding(OnboardingFeature.Action)
        case main(StorybookStationaryFeature.Action)
        case profileResolveFailed(String)
        case profileResolved(UserProfileSession)
        case sessionLoadFailed(String)
        case sessionLoaded(UserProfileSession?)
        case task
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .onboarding(childAction):
                switch childAction {
                case let .delegate(.submitName(name)):
                    return .run { send in
                        do {
                            let session = try await userProfileClient.resolveProfile(name)
                            await send(.profileResolved(session))
                        } catch {
                            await send(.profileResolveFailed(error.localizedDescription))
                        }
                    }

                default:
                    return .none
                }

            case let .main(childAction):
                switch childAction {
                case let .delegate(.createProfile(name)):
                    return .run { send in
                        do {
                            let session = try await userProfileClient.resolveProfile(name)
                            await send(.profileResolved(session))
                        } catch {
                            await send(.profileResolveFailed(error.localizedDescription))
                        }
                    }

                case let .delegate(.switchProfile(id)):
                    return .run { send in
                        do {
                            var session = try await userProfileClient.switchProfile(id)
                            if let selected = session.profiles.first(where: { $0.id == id }) {
                                session.active = selected
                            }
                            await send(.profileResolved(session))
                        } catch {
                            await send(.profileResolveFailed(error.localizedDescription))
                        }
                    }

                case let .delegate(.updateAvatar(avatar, avatarImageData)):
                    guard case let .main(mainState) = state.route,
                          let activeProfileID = mainState.activeProfileID else {
                        return .send(.profileResolveFailed(UserProfileClientError.unexpectedMissingProfile.localizedDescription))
                    }

                    return .run { send in
                        do {
                            let session = try await userProfileClient.updateAvatar(activeProfileID, avatar, avatarImageData)
                            await send(.profileResolved(session))
                        } catch {
                            await send(.profileResolveFailed(error.localizedDescription))
                        }
                    }

                default:
                    return .none
                }

            case .task:
                return .run { send in
                    do {
                        let session = try await userProfileClient.loadSession()
                        await send(.sessionLoaded(session))
                    } catch {
                        await send(.sessionLoadFailed(error.localizedDescription))
                    }
                }

            case let .sessionLoaded(session):
                guard let session else {
                    state.route = .onboarding(.init())
                    return .none
                }
                var mainState = StorybookStationaryFeature.State()
                mainState.applySession(
                    activeProfileID: session.active.id,
                    activeProfileName: session.active.name,
                    profiles: .init(uniqueElements: session.profiles)
                )
                state.route = .main(mainState)
                return .none

            case let .sessionLoadFailed(errorMessage):
                state.route = .onboarding(
                    .init(
                        isSaving: false,
                        name: "",
                        validationMessage: errorMessage
                    )
                )
                return .none

            case let .profileResolved(session):
                switch state.route {
                case .loading, .onboarding:
                    var mainState = StorybookStationaryFeature.State()
                    mainState.applySession(
                        activeProfileID: session.active.id,
                        activeProfileName: session.active.name,
                        profiles: .init(uniqueElements: session.profiles)
                    )
                    state.route = .main(mainState)

                case var .main(mainState):
                    mainState.applySession(
                        activeProfileID: session.active.id,
                        activeProfileName: session.active.name,
                        profiles: .init(uniqueElements: session.profiles)
                    )
                    state.route = .main(mainState)
                }
                return .none

            case let .profileResolveFailed(errorMessage):
                switch state.route {
                case .loading:
                    state.route = .onboarding(
                        .init(
                            isSaving: false,
                            name: "",
                            validationMessage: errorMessage
                        )
                    )

                case var .onboarding(onboardingState):
                    onboardingState.isSaving = false
                    onboardingState.validationMessage = errorMessage
                    state.route = .onboarding(onboardingState)

                case var .main(mainState):
                    mainState.isPersistingProfile = false
                    mainState.profileMessage = errorMessage
                    if var editor = mainState.destination {
                        editor.isGenerating = false
                        editor.isSaving = false
                        editor.isLoadingGeneratedImage = false
                        editor.message = errorMessage
                        mainState.destination = editor
                    }
                    state.route = .main(mainState)
                }
                return .none
            }
        }
        .ifLet(\.onboarding, action: \.onboarding) {
            OnboardingFeature()
        }
        .ifLet(\.main, action: \.main) {
            StorybookStationaryFeature()
        }
    }
}
