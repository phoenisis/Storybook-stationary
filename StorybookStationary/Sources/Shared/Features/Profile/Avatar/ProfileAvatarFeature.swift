import ComposableArchitecture
import Foundation

@Reducer
struct ProfileAvatarFeature {
    @Dependency(\.avatarImagePlaygroundClient) var avatarImagePlaygroundClient
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.uuid) var uuid

    @ObservableState
    struct State: Equatable {
        let id = UUID()
        var activeProfileName = ""
        var selectedAge = 5
        var selectedGender: AvatarGender = .neutral
        var generatedAvatarImageData: Data?
        var generationAttempt = 0
        var isGenerating = false
        var isLoadingGeneratedImage = false
        var isSaving = false
        var message: String?
        var originalAvatar: UserAvatarStyle = .fallback
        var originalAvatarImageData: Data = .init()
        var playgroundSeed: AvatarPlaygroundSeed?
    }

    enum AvatarPlaygroundResponse: Equatable {
        case failure(String)
        case success(Data)
    }

    enum Action: Equatable {
        case ageChanged(Int)
        case closeButtonTapped
        case delegate(Delegate)
        case genderChanged(AvatarGender)
        case generateButtonTapped
        case playgroundCancelled
        case playgroundCompleted(URL)
        case playgroundDataResponse(AvatarPlaygroundResponse)
        case playgroundFailed(String)
        case saveButtonTapped
    }

    enum Delegate: Equatable {
        case save(UserAvatarStyle, Data)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .ageChanged(age):
                state.selectedAge = min(max(age, 3), 7)
                state.message = nil
                return .none

            case .closeButtonTapped:
                return .run { _ in
                    await dismiss()
                }

            case let .genderChanged(gender):
                state.selectedGender = gender
                state.message = nil
                return .none

            case .generateButtonTapped:
                state.generationAttempt += 1
                state.isGenerating = true
                state.message = nil
                state.playgroundSeed = AvatarPlaygroundSeed(
                    name: state.activeProfileName,
                    gender: state.selectedGender,
                    age: state.selectedAge,
                    variationNonce: uuid().uuidString
                )
                return .none

            case .playgroundCancelled:
                state.playgroundSeed = nil
                state.isGenerating = false
                state.isLoadingGeneratedImage = false
                state.message = "Generation annulee."
                return .none

            case let .playgroundCompleted(url):
                state.playgroundSeed = nil
                state.isGenerating = false
                state.isLoadingGeneratedImage = true
                state.message = nil
                return .run { send in
                    do {
                        let data = try await avatarImagePlaygroundClient.loadImageData(url)
                        await send(.playgroundDataResponse(.success(data)))
                    } catch {
                        await send(.playgroundDataResponse(.failure(error.localizedDescription)))
                    }
                }

            case let .playgroundDataResponse(response):
                state.isGenerating = false
                state.isLoadingGeneratedImage = false

                switch response {
                case let .failure(message):
                    state.message = message
                case let .success(data):
                    state.generatedAvatarImageData = data
                    if data == state.originalAvatarImageData, !data.isEmpty {
                        state.message = "Resultat identique. Regenerer pour obtenir une nouvelle image."
                    } else {
                        state.message = "Nouvel avatar genere."
                    }
                }
                return .none

            case let .playgroundFailed(message):
                state.playgroundSeed = nil
                state.isGenerating = false
                state.isLoadingGeneratedImage = false
                state.message = message
                return .none

            case .saveButtonTapped:
                guard canSave(state) else {
                    state.message = "Genere d'abord un nouvel avatar."
                    return .none
                }
                guard let avatarImageData = state.generatedAvatarImageData else {
                    state.message = "Genere d'abord un nouvel avatar."
                    return .none
                }
                state.isSaving = true
                state.message = nil
                return .merge(
                    .send(.delegate(.save(makeAvatarStyle(state), avatarImageData))),
                    .run { _ in
                        await dismiss()
                    }
                )

            case .delegate:
                return .none
            }
        }
    }
}

private func canSave(_ state: ProfileAvatarFeature.State) -> Bool {
    guard let generatedData = state.generatedAvatarImageData, !generatedData.isEmpty else {
        return false
    }
    return generatedData != state.originalAvatarImageData
}

private func makeAvatarStyle(_ state: ProfileAvatarFeature.State) -> UserAvatarStyle {
    UserAvatarStyle(
        age: min(max(state.selectedAge, 3), 7),
        gender: state.selectedGender,
        accessorySymbolName: state.originalAvatar.accessorySymbolName,
        symbolName: state.originalAvatar.symbolName,
        primaryHex: state.originalAvatar.primaryHex,
        secondaryHex: state.originalAvatar.secondaryHex
    )
}
