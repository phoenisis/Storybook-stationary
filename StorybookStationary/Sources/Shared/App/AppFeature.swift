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

    private let onboardingReducer = OnboardingFeature()
    private let mainReducer = StorybookStationaryFeature()

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .onboarding(childAction):
                guard case var .onboarding(onboardingState) = state.route else {
                    return .none
                }

                let childEffect = onboardingReducer
                    .reduce(into: &onboardingState, action: childAction)
                    .map(Action.onboarding)
                state.route = .onboarding(onboardingState)

                switch childAction {
                case let .delegate(.submitName(name)):
                    return .merge(
                        childEffect,
                        .run { send in
                            do {
                                let session = try await userProfileClient.resolveProfile(name)
                                await send(.profileResolved(session))
                            } catch {
                                await send(.profileResolveFailed(error.localizedDescription))
                            }
                        }
                    )

                default:
                    return childEffect
                }

            case let .main(childAction):
                guard case var .main(mainState) = state.route else {
                    return .none
                }

                let childEffect = mainReducer
                    .reduce(into: &mainState, action: childAction)
                    .map(Action.main)
                state.route = .main(mainState)

                switch childAction {
                case let .delegate(.createProfile(name)):
                    return .merge(
                        childEffect,
                        .run { send in
                            do {
                                let session = try await userProfileClient.resolveProfile(name)
                                await send(.profileResolved(session))
                            } catch {
                                await send(.profileResolveFailed(error.localizedDescription))
                            }
                        }
                    )

                case let .delegate(.switchProfile(id)):
                    return .merge(
                        childEffect,
                        .run { send in
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
                    )

                case let .delegate(.updateAvatar(avatar, avatarImageData)):
                    guard let activeProfileID = mainState.activeProfileID else {
                        return .merge(
                            childEffect,
                            .send(.profileResolveFailed(UserProfileClientError.unexpectedMissingProfile.localizedDescription))
                        )
                    }

                    return .merge(
                        childEffect,
                        .run { send in
                            do {
                                let session = try await userProfileClient.updateAvatar(activeProfileID, avatar, avatarImageData)
                                await send(.profileResolved(session))
                            } catch {
                                await send(.profileResolveFailed(error.localizedDescription))
                            }
                        }
                    )

                default:
                    return childEffect
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
                    if case var .avatarEditor(editor) = mainState.destination {
                        editor.isGenerating = false
                        editor.isSaving = false
                        editor.isLoadingGeneratedImage = false
                        editor.message = errorMessage
                        mainState.destination = .avatarEditor(editor)
                    }
                    state.route = .main(mainState)
                }
                return .none
            }
        }
    }
}
