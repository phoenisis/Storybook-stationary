import CasePaths
import ComposableArchitecture
import Foundation
import IdentifiedCollections
import SQLiteData

@Reducer
struct AppFeature {
    @Dependency(\.date.now) var now
    @Dependency(\.defaultDatabase) var database
    @Dependency(\.uuid) var uuid

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
        case profileResolved(AppSession)
        case sessionLoadFailed(String)
        case sessionLoaded(AppSession?)
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
                                let session = try await resolveProfile(named: name)
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
                                let session = try await resolveProfile(named: name)
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
                                let session = try await switchProfile(id: id)
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
                        let session = try await loadSession()
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
                state.route = .main(
                    .init(
                        activeProfileID: session.active.id,
                        activeProfileName: session.active.name,
                        profiles: .init(uniqueElements: session.profiles)
                    )
                )
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
                state.route = .main(
                    .init(
                        activeProfileID: session.active.id,
                        activeProfileName: session.active.name,
                        profiles: .init(uniqueElements: session.profiles)
                    )
                )
                return .none

            case let .profileResolveFailed(errorMessage):
                switch state.route {
                case var .onboarding(onboardingState):
                    onboardingState.isSaving = false
                    onboardingState.validationMessage = errorMessage
                    state.route = .onboarding(onboardingState)

                case var .main(mainState):
                    mainState.isPersistingProfile = false
                    mainState.profileMessage = errorMessage
                    state.route = .main(mainState)
                }
                return .none
            }
        }
    }

    private func loadSession() async throws -> AppSession? {
        try await database.read { db in
            let profiles = try UserProfile
                .order { $0.lastUsedAt.desc() }
                .fetchAll(db)
            guard let activeProfile = profiles.first else { return nil }
            return .init(active: activeProfile, profiles: profiles)
        }
    }

    private func resolveProfile(named rawName: String) async throws -> AppSession {
        let trimmedName = rawName.trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedName = trimmedName.lowercased()
        return try await database.write { db in
            var profiles = try UserProfile.fetchAll(db)
            if let existing = profiles.first(where: { $0.name.lowercased() == normalizedName }) {
                var updatedProfile = existing
                updatedProfile.lastUsedAt = now
                try UserProfile
                    .upsert { updatedProfile }
                    .execute(db)
            } else {
                let profile = UserProfile(
                    id: uuid(),
                    name: trimmedName,
                    createdAt: now,
                    lastUsedAt: now
                )
                try UserProfile
                    .upsert { profile }
                    .execute(db)
            }

            profiles = try UserProfile
                .order { $0.lastUsedAt.desc() }
                .fetchAll(db)
            guard let activeProfile = profiles.first else {
                throw AppError.unexpectedMissingProfile
            }
            return .init(active: activeProfile, profiles: profiles)
        }
    }

    private func switchProfile(id: UserProfile.ID) async throws -> AppSession {
        try await database.write { db in
            var activeProfile = try UserProfile
                .where { $0.id.eq(id) }
                .fetchOne(db)
            guard var profile = activeProfile else {
                throw AppError.profileNotFound
            }
            profile.lastUsedAt = now
            try UserProfile
                .upsert { profile }
                .execute(db)

            let profiles = try UserProfile
                .order { $0.lastUsedAt.desc() }
                .fetchAll(db)
            activeProfile = profiles.first
            guard let activeProfile else {
                throw AppError.unexpectedMissingProfile
            }
            return .init(active: activeProfile, profiles: profiles)
        }
    }
}

extension AppFeature {
    struct AppSession: Equatable, Sendable {
        var active: UserProfile
        var profiles: [UserProfile]
    }

    enum AppError: LocalizedError {
        case profileNotFound
        case unexpectedMissingProfile

        var errorDescription: String? {
            switch self {
            case .profileNotFound:
                return "Ce profil est introuvable."
            case .unexpectedMissingProfile:
                return "Aucun profil actif n'a pu etre charge."
            }
        }
    }
}
