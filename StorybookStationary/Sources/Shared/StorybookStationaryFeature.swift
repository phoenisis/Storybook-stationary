import CasePaths
import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
struct StorybookStationaryFeature {
    @CasePathable
    enum Tab: Hashable {
        case library
        case writing
        case awards
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
        var audioLevel: CGFloat = .audioInitial
        var destination: Destination?
        var path: [Route] = []
        var selectedTab: Tab = .library
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case destinationDismissed
        case libraryDetailTapped
        case profileTapped
    }

    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none

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
            }
        }
    }
}
