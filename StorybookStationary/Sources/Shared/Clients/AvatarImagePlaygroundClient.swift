import Dependencies
import Foundation
import ImagePlayground

struct AvatarPlaygroundSeed: Equatable, Sendable {
    var name: String
    var gender: AvatarGender
    var age: Int
    var variationNonce: String
}

struct AvatarImagePlaygroundClient: Sendable {
    var concepts: @Sendable (_ seed: AvatarPlaygroundSeed) -> [ImagePlaygroundConcept]
    var loadImageData: @Sendable (_ url: URL) async throws -> Data
}

extension AvatarImagePlaygroundClient: DependencyKey {
    static var liveValue: AvatarImagePlaygroundClient {
        AvatarImagePlaygroundClient(
            concepts: { seed in
                let trimmedName = seed.name.trimmingCharacters(in: .whitespacesAndNewlines)
                let normalizedAge = min(max(seed.age, 3), 7)

                return [
                    .text("cartoon portrait of a child"),
                    .text("friendly warm expression"),
                    .text("child named \(trimmedName.isEmpty ? "Ami" : trimmedName)"),
                    .text("gender preference: \(seed.gender.rawValue)"),
                    .text("age: \(normalizedAge) years old"),
                    .text("storybook style colorful illustration"),
                    .text("variation-\(seed.variationNonce)"),
                ]
            },
            loadImageData: { url in
                try Data(contentsOf: url)
            }
        )
    }

    static var testValue: AvatarImagePlaygroundClient {
        AvatarImagePlaygroundClient(
            concepts: { seed in
                [.text("test-\(seed.variationNonce)")]
            },
            loadImageData: { _ in
                Data("test-image".utf8)
            }
        )
    }
}

extension DependencyValues {
    var avatarImagePlaygroundClient: AvatarImagePlaygroundClient {
        get { self[AvatarImagePlaygroundClient.self] }
        set { self[AvatarImagePlaygroundClient.self] = newValue }
    }
}
