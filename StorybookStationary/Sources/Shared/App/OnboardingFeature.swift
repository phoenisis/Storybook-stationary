import ComposableArchitecture
import Foundation

@Reducer
struct OnboardingFeature {
    @ObservableState
    struct State: Equatable {
        var isSaving = false
        var name = ""
        var validationMessage: String?
    }

    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case delegate(Delegate)
        case startButtonTapped
    }

    enum Delegate: Equatable {
        case submitName(String)
    }

    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                state.validationMessage = nil
                return .none

            case .delegate:
                return .none

            case .startButtonTapped:
                let trimmedName = state.name.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmedName.isEmpty else {
                    state.validationMessage = "Ton prenom est necessaire."
                    return .none
                }

                state.isSaving = true
                state.validationMessage = nil
                return .send(.delegate(.submitName(trimmedName)))
            }
        }
    }
}
