import CasePaths
import ComposableArchitecture
import Foundation
import IdentifiedCollections
import SwiftUI

@Reducer
struct StorybookStationaryFeature {
    struct ProfileStat: Equatable, Identifiable {
        enum Accent: Equatable {
            case blue
            case green
            case gold
            case purple
        }

        var id: String { title }
        var icon: String
        var subtitle: String
        var title: String
        var value: String
        var accent: Accent
    }

    struct ProfileTheme: Equatable, Identifiable {
        enum Accent: Equatable {
            case mint
            case cyan
            case amber
            case pink
        }

        var id: String { name }
        var icon: String
        var name: String
        var exploredBooks: Int
        var accent: Accent
    }

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

    @ObservableState
    struct State: Equatable {
        var activeProfileID: UserProfile.ID?
        var activeProfileName = ""
        var activeAvatar: UserAvatarStyle = .fallback
        var activeAvatarImageData: Data = .init()
        var audioLevel: CGFloat = .audioInitial
        var destination: ProfileAvatarFeature.State?
        var isPersistingProfile = false
        var newProfileName = ""
        var path: [Route] = []
        var profileInfoMessage: String?
        var profileMessage: String?
        var profiles: IdentifiedArrayOf<UserProfile> = []
        var profileStats: [ProfileStat] = Self.defaultProfileStats
        var profileThemes: [ProfileTheme] = Self.defaultProfileThemes
        var selectedTab: Tab = .library

        static let defaultProfileStats: [ProfileStat] = [
            .init(icon: "book.closed.fill", subtitle: "LIVRES LUS", title: "Livres lus", value: "24", accent: .blue),
            .init(icon: "star.circle.fill", subtitle: "BADGES GAGNES", title: "Badges gagnes", value: "15", accent: .green),
            .init(icon: "clock.fill", subtitle: "TEMPS TOTAL", title: "Temps total", value: "12h", accent: .gold),
            .init(icon: "rocket.fill", subtitle: "SERIE ACTUELLE", title: "Serie actuelle", value: "5j", accent: .purple),
        ]

        static let defaultProfileThemes: [ProfileTheme] = [
            .init(icon: "tree.fill", name: "Nature", exploredBooks: 12, accent: .mint),
            .init(icon: "sparkles", name: "Espace", exploredBooks: 8, accent: .cyan),
            .init(icon: "building.columns.fill", name: "Histoire", exploredBooks: 5, accent: .amber),
            .init(icon: "wand.and.stars", name: "Magie", exploredBooks: 4, accent: .pink),
        ]

        mutating func applySession(
            activeProfileID: UserProfile.ID,
            activeProfileName: String,
            profiles: IdentifiedArrayOf<UserProfile>
        ) {
            self.activeProfileID = activeProfileID
            self.activeProfileName = activeProfileName
            self.profiles = profiles
            self.isPersistingProfile = false
            self.newProfileName = ""
            self.profileInfoMessage = "Profil \(activeProfileName) actif."
            self.activeAvatar = profiles[id: activeProfileID]?.avatarStyle ?? .fallback
            self.activeAvatarImageData = profiles[id: activeProfileID]?.avatarImageData ?? .init()
            self.profileStats = Self.profileStats(for: activeProfileID)
            self.profileThemes = Self.profileThemes(for: activeProfileID)
        }

        static func profileStats(for id: UserProfile.ID) -> [ProfileStat] {
            let seed = profileSeed(id)
            let books = 12 + (seed % 30)
            let badges = 5 + (seed % 20)
            let hours = 4 + (seed % 16)
            let streak = 1 + (seed % 14)

            return [
                .init(icon: "book.closed.fill", subtitle: "LIVRES LUS", title: "Livres lus", value: "\(books)", accent: .blue),
                .init(icon: "star.circle.fill", subtitle: "BADGES GAGNES", title: "Badges gagnes", value: "\(badges)", accent: .green),
                .init(icon: "clock.fill", subtitle: "TEMPS TOTAL", title: "Temps total", value: "\(hours)h", accent: .gold),
                .init(icon: "rocket.fill", subtitle: "SERIE ACTUELLE", title: "Serie actuelle", value: "\(streak)j", accent: .purple),
            ]
        }

        static func profileThemes(for id: UserProfile.ID) -> [ProfileTheme] {
            let seed = profileSeed(id)
            return [
                .init(icon: "tree.fill", name: "Nature", exploredBooks: 4 + (seed % 11), accent: .mint),
                .init(icon: "sparkles", name: "Espace", exploredBooks: 3 + (seed % 9), accent: .cyan),
                .init(icon: "building.columns.fill", name: "Histoire", exploredBooks: 2 + (seed % 7), accent: .amber),
                .init(icon: "wand.and.stars", name: "Magie", exploredBooks: 2 + (seed % 8), accent: .pink),
            ]
        }

        private static func profileSeed(_ id: UserProfile.ID) -> Int {
            id.uuidString.unicodeScalars.reduce(0) { partialResult, scalar in
                partialResult + Int(scalar.value)
            }
        }
    }

    enum Action: BindableAction, Equatable {
        case avatarTapped
        case binding(BindingAction<State>)
        case createProfileTapped
        case destination(ProfileAvatarFeature.Action)
        case infoMessageDismissed
        case libraryDetailTapped
        case profileTapped
        case profileStatTapped(String)
        case profileThemeTapped(String)
        case selectProfileTapped(UserProfile.ID)
        case sessionUpdated(activeProfileID: UserProfile.ID, activeProfileName: String, profiles: IdentifiedArrayOf<UserProfile>)
        case delegate(Delegate)
    }

    enum Delegate: Equatable {
        case createProfile(String)
        case switchProfile(UserProfile.ID)
        case updateAvatar(UserAvatarStyle, Data)
    }

    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .avatarTapped:
                state.destination = .init(
                    activeProfileName: state.activeProfileName,
                    selectedAge: state.activeAvatar.age,
                    selectedGender: state.activeAvatar.gender,
                    originalAvatar: state.activeAvatar,
                    originalAvatarImageData: state.activeAvatarImageData
                )
                return .none

            case .binding:
                return .none

            case .createProfileTapped:
                let trimmedName = state.newProfileName.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmedName.isEmpty else {
                    state.profileMessage = "Entre un prenom pour creer un profil."
                    return .none
                }

                state.isPersistingProfile = true
                state.profileInfoMessage = nil
                state.profileMessage = nil
                return .send(.delegate(.createProfile(trimmedName)))

            case .infoMessageDismissed:
                state.profileInfoMessage = nil
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
                state.destination = .init(
                    activeProfileName: state.activeProfileName,
                    selectedAge: state.activeAvatar.age,
                    selectedGender: state.activeAvatar.gender,
                    originalAvatar: state.activeAvatar,
                    originalAvatarImageData: state.activeAvatarImageData
                )
                return .none

            case let .profileStatTapped(title):
                state.profileInfoMessage = "\(title) sera detaille bientot."
                return .none

            case let .profileThemeTapped(name):
                state.profileInfoMessage = "Le theme \(name) arrive bientot."
                return .none

            case let .selectProfileTapped(id):
                guard id != state.activeProfileID else {
                    state.profileInfoMessage = "Ce profil est deja actif."
                    return .none
                }

                if let selectedProfile = state.profiles[id: id] {
                    state.activeProfileID = id
                    state.activeProfileName = selectedProfile.name
                    state.profileInfoMessage = "Activation de \(selectedProfile.name)..."
                    state.profileStats = State.profileStats(for: id)
                    state.profileThemes = State.profileThemes(for: id)
                }
                state.isPersistingProfile = true
                state.profileMessage = nil
                return .send(.delegate(.switchProfile(id)))

            case let .sessionUpdated(activeProfileID, activeProfileName, profiles):
                let wasSavingAvatar = state.destination?.isSaving ?? false
                state.applySession(
                    activeProfileID: activeProfileID,
                    activeProfileName: activeProfileName,
                    profiles: profiles
                )
                if wasSavingAvatar {
                    state.destination = nil
                    state.profileInfoMessage = "Avatar mis a jour."
                }
                return .none

            case let .destination(.delegate(.save(avatar, avatarImageData))):
                state.profileMessage = nil
                state.destination = nil
                return .send(.delegate(.updateAvatar(avatar, avatarImageData)))

            case .destination:
                return .none

            case .delegate:
                return .none
            }
        }
        .ifLet(\.destination, action: \.destination) {
            ProfileAvatarFeature()
        }
    }
}
