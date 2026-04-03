import Dependencies
import Foundation
import SQLiteData

struct UserProfileSession: Equatable, Sendable {
    var active: UserProfile
    var profiles: [UserProfile]
}

struct UserProfileClient: Sendable {
    var loadSession: @Sendable () async throws -> UserProfileSession?
    var resolveProfile: @Sendable (_ rawName: String) async throws -> UserProfileSession
    var switchProfile: @Sendable (_ id: UserProfile.ID) async throws -> UserProfileSession
    var updateAvatar: @Sendable (_ id: UserProfile.ID, _ avatar: UserAvatarStyle, _ avatarImageData: Data) async throws -> UserProfileSession
}

extension UserProfileClient: DependencyKey {
    static var liveValue: UserProfileClient {
        @Dependency(\.date.now) var now
        @Dependency(\.defaultDatabase) var database
        @Dependency(\.uuid) var uuid

        return UserProfileClient(
            loadSession: {
                try await database.read { db in
                    let activeProfile = try UserProfile
                        .order { $0.lastUsedAt.desc() }
                        .fetchOne(db)
                    guard let activeProfile else { return nil }
                    let profiles = try UserProfile
                        .order { $0.name.asc() }
                        .fetchAll(db)
                    return UserProfileSession(active: activeProfile, profiles: profiles)
                }
            },
            resolveProfile: { rawName in
                let trimmedName = rawName.trimmingCharacters(in: .whitespacesAndNewlines)
                let normalizedName = trimmedName.lowercased()
                return try await database.write { db in
                    var profiles = try UserProfile.fetchAll(db)
                    let activeProfile: UserProfile
                    if let existing = profiles.first(where: { $0.name.lowercased() == normalizedName }) {
                        var updatedProfile = existing
                        updatedProfile.lastUsedAt = now
                        try UserProfile
                            .upsert { updatedProfile }
                            .execute(db)
                        activeProfile = updatedProfile
                    } else {
                        let profile = UserProfile(
                            id: uuid(),
                            name: trimmedName,
                            createdAt: now,
                            lastUsedAt: now,
                            avatarSymbolName: UserAvatarStyle.fallback.symbolName,
                            avatarAccessorySymbolName: UserAvatarStyle.fallback.accessorySymbolName,
                            avatarPrimaryHex: UserAvatarStyle.fallback.primaryHex,
                            avatarSecondaryHex: UserAvatarStyle.fallback.secondaryHex,
                            avatarGender: UserAvatarStyle.fallback.gender.rawValue,
                            avatarAge: UserAvatarStyle.fallback.age,
                            avatarImageData: .init()
                        )
                        try UserProfile
                            .upsert { profile }
                            .execute(db)
                        activeProfile = profile
                    }

                    profiles = try UserProfile
                        .order { $0.name.asc() }
                        .fetchAll(db)
                    return UserProfileSession(active: activeProfile, profiles: profiles)
                }
            },
            switchProfile: { id in
                try await database.write { db in
                    let persistedProfile = try UserProfile
                        .where { $0.id.eq(id) }
                        .fetchOne(db)
                    guard var profile = persistedProfile else {
                        throw UserProfileClientError.profileNotFound
                    }
                    profile.lastUsedAt = now
                    try UserProfile
                        .upsert { profile }
                        .execute(db)

                    let profiles = try UserProfile
                        .order { $0.name.asc() }
                        .fetchAll(db)
                    return UserProfileSession(active: profile, profiles: profiles)
                }
            },
            updateAvatar: { id, avatar, avatarImageData in
                return try await database.write { db in
                    let persistedProfile = try UserProfile
                        .where { $0.id.eq(id) }
                        .fetchOne(db)
                    guard var profile = persistedProfile else {
                        throw UserProfileClientError.profileNotFound
                    }
                    profile.avatarStyle = avatar
                    profile.avatarImageData = avatarImageData
                    profile.lastUsedAt = now

                    try UserProfile
                        .upsert { profile }
                        .execute(db)

                    let profiles = try UserProfile
                        .order { $0.name.asc() }
                        .fetchAll(db)
                    return UserProfileSession(active: profile, profiles: profiles)
                }
            }
        )
    }

    static var testValue: UserProfileClient {
        UserProfileClient(
            loadSession: { nil },
            resolveProfile: { _ in
                throw UserProfileClientError.unimplemented
            },
            switchProfile: { _ in
                throw UserProfileClientError.unimplemented
            },
            updateAvatar: { _, _, _ in
                throw UserProfileClientError.unimplemented
            }
        )
    }
}

extension DependencyValues {
    var userProfileClient: UserProfileClient {
        get { self[UserProfileClient.self] }
        set { self[UserProfileClient.self] = newValue }
    }
}

enum UserProfileClientError: LocalizedError {
    case profileNotFound
    case unexpectedMissingProfile
    case unimplemented

    var errorDescription: String? {
        switch self {
        case .profileNotFound:
            return "Ce profil est introuvable."
        case .unexpectedMissingProfile:
            return "Aucun profil actif n'a pu etre charge."
        case .unimplemented:
            return "Le client profil n'est pas implemente dans ce contexte."
        }
    }
}
