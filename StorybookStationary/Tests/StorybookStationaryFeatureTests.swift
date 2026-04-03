import ComposableArchitecture
import Foundation
import IdentifiedCollections
import Testing

@testable import StorybookStationary_iOS

@Suite
struct StorybookStationaryFeatureTests {
    @Test
    func avatarTapOpensSettingsAndShowsInfoMessage() async {
        let store = TestStore(initialState: StorybookStationaryFeature.State()) {
            StorybookStationaryFeature()
        }

        await store.send(.avatarTapped) {
            $0.destination = .profileSettings(.init())
            $0.profileInfoMessage = "Personnalisation d'avatar a venir."
        }
    }

    @Test
    func statAndThemeTapSetInfoMessage() async {
        let store = TestStore(initialState: StorybookStationaryFeature.State()) {
            StorybookStationaryFeature()
        }

        await store.send(.profileStatTapped("Livres lus")) {
            $0.profileInfoMessage = "Livres lus sera detaille bientot."
        }

        await store.send(.profileThemeTapped("Nature")) {
            $0.profileInfoMessage = "Le theme Nature arrive bientot."
        }
    }

    @Test
    func emptyProfileNameSetsValidationWithoutTouchingInfoMessage() async {
        var state = StorybookStationaryFeature.State()
        state.profileInfoMessage = "Info"

        let store = TestStore(initialState: state) {
            StorybookStationaryFeature()
        }

        await store.send(.createProfileTapped) {
            $0.profileMessage = "Entre un prenom pour creer un profil."
            $0.profileInfoMessage = "Info"
        }
    }

    @Test
    func selectingActiveProfileShowsInfoMessage() async {
        var state = StorybookStationaryFeature.State()
        state.activeProfileID = UUID(0)

        let store = TestStore(initialState: state) {
            StorybookStationaryFeature()
        }

        await store.send(.selectProfileTapped(UUID(0))) {
            $0.profileInfoMessage = "Ce profil est deja actif."
        }
    }

    @Test
    func selectingDifferentProfilePropagatesDelegateAndUpdatesImmediately() async {
        let activeID = UUID(0)
        let otherID = UUID(1)
        var state = StorybookStationaryFeature.State()
        state.activeProfileID = activeID
        state.activeProfileName = "Lina"
        state.profiles = [
            UserProfile(id: activeID, name: "Lina", createdAt: .init(timeIntervalSince1970: 1), lastUsedAt: .init(timeIntervalSince1970: 2)),
            UserProfile(id: otherID, name: "Milo", createdAt: .init(timeIntervalSince1970: 3), lastUsedAt: .init(timeIntervalSince1970: 4)),
        ]

        let store = TestStore(initialState: state) {
            StorybookStationaryFeature()
        }

        await store.send(.selectProfileTapped(otherID)) {
            $0.activeProfileID = otherID
            $0.activeProfileName = "Milo"
            $0.isPersistingProfile = true
            $0.profileMessage = nil
            $0.profileInfoMessage = "Activation de Milo..."
            $0.profileStats = StorybookStationaryFeature.State.profileStats(for: otherID)
            $0.profileThemes = StorybookStationaryFeature.State.profileThemes(for: otherID)
        }
        await store.receive(.delegate(.switchProfile(otherID)))
    }

    @Test
    func sessionUpdatedRefreshesProfileShowcaseData() async {
        let profileID = UUID(1)
        let profiles: IdentifiedArrayOf<UserProfile> = [
            UserProfile(
                id: profileID,
                name: "Mila",
                createdAt: Date(timeIntervalSince1970: 1),
                lastUsedAt: Date(timeIntervalSince1970: 2)
            )
        ]

        let store = TestStore(initialState: StorybookStationaryFeature.State()) {
            StorybookStationaryFeature()
        }

        await store.send(
            .sessionUpdated(
                activeProfileID: profileID,
                activeProfileName: "Mila",
                profiles: profiles
            )
        ) {
            $0.activeProfileID = profileID
            $0.activeProfileName = "Mila"
            $0.profiles = profiles
            $0.isPersistingProfile = false
            $0.newProfileName = ""
            $0.profileInfoMessage = "Profil Mila actif."
        }

        #expect(store.state.profileStats != StorybookStationaryFeature.State.defaultProfileStats)
        #expect(store.state.profileThemes != StorybookStationaryFeature.State.defaultProfileThemes)
    }
}
