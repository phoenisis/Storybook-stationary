import CasePaths
import ComposableArchitecture
import Foundation
import IdentifiedCollections
import SwiftUI

@Reducer
struct StorybookStationaryFeature {
    @CasePathable
    enum Tab: Hashable {
        case library
        case readNow
        case badges
        case profile
    }

    @CasePathable
    enum Route: Hashable {
        case lessonDetail(LessonDetail)

        struct LessonDetail: Hashable {
            var description: String
            var title: String
        }
    }

    @CasePathable
    @dynamicMemberLookup
    enum Destination: Equatable {
        case profileSettings(ProfileSettings)

        struct ProfileSettings: Equatable {
            let id = UUID()
            var keepAudioEnabled = true
        }
    }

    @ObservableState
    struct State: Equatable {
        var activeProfileID: UserProfile.ID?
        var activeProfileName = ""
        var audioLevel: CGFloat = .audioInitial
        var destination: Destination?
        var isPersistingProfile = false
        var newProfileName = ""
        var path: [Route] = []
        var profileMessage: String?
        var profiles: IdentifiedArrayOf<UserProfile> = []
        var selectedTab: Tab = .library
    }

    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case createProfileTapped
        case destinationDismissed
        case libraryDetailTapped
        case profileTapped
        case selectProfileTapped(UserProfile.ID)
        case sessionUpdated(activeProfileID: UserProfile.ID, activeProfileName: String, profiles: IdentifiedArrayOf<UserProfile>)
        case delegate(Delegate)
    }

    enum Delegate: Equatable {
        case createProfile(String)
        case switchProfile(UserProfile.ID)
    }

    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            case .createProfileTapped:
                let trimmedName = state.newProfileName.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmedName.isEmpty else {
                    state.profileMessage = "Entre un prenom pour creer un profil."
                    return .none
                }

                state.isPersistingProfile = true
                state.profileMessage = nil
                return .send(.delegate(.createProfile(trimmedName)))

            case .destinationDismissed:
                state.destination = nil
                return .none

            case .libraryDetailTapped:
                state.path.append(
                    .lessonDetail(
                        .init(
                            description: "Une exploration guidee de l'univers papier avec des interactions tactiles et du feedback visuel.",
                            title: "Lecon du jour"
                        )
                    )
                )
                return .none

            case .profileTapped:
                state.destination = .profileSettings(.init())
                return .none

            case let .selectProfileTapped(id):
                guard id != state.activeProfileID else { return .none }
                state.isPersistingProfile = true
                state.profileMessage = nil
                return .send(.delegate(.switchProfile(id)))

            case let .sessionUpdated(activeProfileID, activeProfileName, profiles):
                state.activeProfileID = activeProfileID
                state.activeProfileName = activeProfileName
                state.profiles = profiles
                state.isPersistingProfile = false
                state.newProfileName = ""
                return .none

            case .delegate:
                return .none
            }
        }
    }
}
