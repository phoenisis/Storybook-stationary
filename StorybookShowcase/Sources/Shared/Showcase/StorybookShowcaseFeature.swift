import ComposableArchitecture

@Reducer
struct StorybookShowcase {
    enum Tab: Int, Hashable {
        case components
        case motion
        case theme
        case tokens
    }

    @ObservableState
    struct State {
        var gradientIndex = 0
        var metricIndex = 0
        var navSelected: Tab = .theme
        var progressPreviewState: ProgressDot.State = .current
        var radiusIndex = 2
        var showcaseAnimationState = false
        var sizeIndex = 5
        var spacingIndex = 4
        var strokeIndex = 1
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case buttonMotionButtonTapped
        case navigationMotionButtonTapped
    }

    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .buttonMotionButtonTapped, .navigationMotionButtonTapped:
                state.showcaseAnimationState.toggle()
                return .none
            }
        }
    }
}
