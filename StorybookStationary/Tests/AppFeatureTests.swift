import ComposableArchitecture
import Dependencies
import DependenciesTestSupport
import Foundation
import SQLiteData
import Testing

@testable import StorybookStationary_iOS

@Suite(
    .dependencies {
        $0.date.now = Date(timeIntervalSince1970: 1_700_000_000)
        $0.uuid = .incrementing
        try $0.bootstrapDatabase()
    }
)
struct AppFeatureTests {
    @Test
    func launchWithoutProfilesShowsOnboarding() async throws {
        try clearProfiles()

        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }
        store.exhaustivity = .off

        await store.send(.task)
        await store.finish()

        guard case .onboarding = store.state.route else {
            Issue.record("Expected onboarding route when no profiles exist.")
            return
        }
    }

    @Test
    func onboardingCreatesProfileAndEntersMain() async throws {
        try clearProfiles()

        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }
        store.exhaustivity = .off

        await store.send(.onboarding(.binding(.set(\.name, "Lina"))))
        await store.send(.onboarding(.startButtonTapped))
        await store.finish()

        guard case let .main(mainState) = store.state.route else {
            Issue.record("Expected main route after creating profile.")
            return
        }
        #expect(mainState.activeProfileName == "Lina")
        #expect(mainState.profiles.count == 1)
    }

    @Test
    func duplicateNameReusesExistingProfile() async throws {
        try clearProfiles()

        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }
        store.exhaustivity = .off

        await store.send(.onboarding(.binding(.set(\.name, "Milo"))))
        await store.send(.onboarding(.startButtonTapped))
        await store.finish()

        await store.send(.main(.binding(.set(\.newProfileName, "milo"))))
        await store.send(.main(.createProfileTapped))
        await store.finish()

        guard case let .main(mainState) = store.state.route else {
            Issue.record("Expected main route after duplicate profile create flow.")
            return
        }
        #expect(mainState.profiles.count == 1)
        #expect(mainState.activeProfileName == "Milo")
    }

    private func clearProfiles() throws {
        @Dependency(\.defaultDatabase) var database
        try database.write { db in
            try #sql("DELETE FROM \"userProfiles\"").execute(db)
        }
    }
}
