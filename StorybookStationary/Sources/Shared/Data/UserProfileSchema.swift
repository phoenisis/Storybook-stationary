import Dependencies
import Foundation
import SQLiteData

enum AvatarGender: String, CaseIterable, Codable, Equatable, Sendable, Identifiable {
    case girl
    case boy
    case neutral

    var id: String { rawValue }

    var title: String {
        switch self {
        case .girl:
            return "Fille"
        case .boy:
            return "Garcon"
        case .neutral:
            return "Neutre"
        }
    }
}

struct UserAvatarStyle: Codable, Equatable, Hashable, Sendable {
    var age: Int
    var gender: AvatarGender
    var accessorySymbolName: String
    var symbolName: String
    var primaryHex: String
    var secondaryHex: String

    static let fallback = UserAvatarStyle(
        age: 5,
        gender: .neutral,
        accessorySymbolName: "star.fill",
        symbolName: "person.fill",
        primaryHex: "2C8FCE",
        secondaryHex: "F8C84A"
    )

    var styleSignature: String {
        "\(symbolName)|\(accessorySymbolName)|\(primaryHex)|\(secondaryHex)|\(gender.rawValue)|\(age)"
    }
}

@Table
struct UserProfile: Equatable, Identifiable, Sendable {
    let id: UUID
    var name: String = ""
    var createdAt: Date = .init()
    var lastUsedAt: Date = .init()
    var avatarSymbolName: String = UserAvatarStyle.fallback.symbolName
    var avatarAccessorySymbolName: String = UserAvatarStyle.fallback.accessorySymbolName
    var avatarPrimaryHex: String = UserAvatarStyle.fallback.primaryHex
    var avatarSecondaryHex: String = UserAvatarStyle.fallback.secondaryHex
    var avatarGender: String = UserAvatarStyle.fallback.gender.rawValue
    var avatarAge: Int = UserAvatarStyle.fallback.age
    var avatarImageData: Data = .init()

    var avatarStyle: UserAvatarStyle {
        get {
            UserAvatarStyle(
                age: Swift.min(Swift.max(avatarAge, 3), 7),
                gender: AvatarGender(rawValue: avatarGender) ?? .neutral,
                accessorySymbolName: avatarAccessorySymbolName,
                symbolName: avatarSymbolName,
                primaryHex: avatarPrimaryHex,
                secondaryHex: avatarSecondaryHex
            )
        }
        set {
            avatarSymbolName = newValue.symbolName
            avatarAccessorySymbolName = newValue.accessorySymbolName
            avatarPrimaryHex = newValue.primaryHex
            avatarSecondaryHex = newValue.secondaryHex
            avatarGender = newValue.gender.rawValue
            avatarAge = Swift.min(Swift.max(newValue.age, 3), 7)
        }
    }
}

extension DependencyValues {
    mutating func bootstrapDatabase() throws {
        let database = try SQLiteData.defaultDatabase()
        var migrator = DatabaseMigrator()
        #if DEBUG
        migrator.eraseDatabaseOnSchemaChange = true
        #endif

        migrator.registerMigration("Create 'userProfiles' table") { db in
            try #sql(
                """
                CREATE TABLE "userProfiles" (
                  "id" TEXT PRIMARY KEY NOT NULL ON CONFLICT REPLACE,
                  "name" TEXT NOT NULL ON CONFLICT REPLACE DEFAULT '',
                  "createdAt" TEXT NOT NULL ON CONFLICT REPLACE DEFAULT CURRENT_TIMESTAMP,
                  "lastUsedAt" TEXT NOT NULL ON CONFLICT REPLACE DEFAULT CURRENT_TIMESTAMP
                ) STRICT
                """
            )
            .execute(db)

            try #sql(
                """
                CREATE INDEX "index_userProfiles_on_lastUsedAt"
                ON "userProfiles"("lastUsedAt")
                """
            )
            .execute(db)
        }

        migrator.registerMigration("Add avatar columns to 'userProfiles'") { db in
            try #sql(
                """
                ALTER TABLE "userProfiles"
                ADD COLUMN "avatarSymbolName" TEXT NOT NULL DEFAULT 'person.fill'
                """
            )
            .execute(db)

            try #sql(
                """
                ALTER TABLE "userProfiles"
                ADD COLUMN "avatarAccessorySymbolName" TEXT NOT NULL DEFAULT 'star.fill'
                """
            )
            .execute(db)

            try #sql(
                """
                ALTER TABLE "userProfiles"
                ADD COLUMN "avatarPrimaryHex" TEXT NOT NULL DEFAULT '2C8FCE'
                """
            )
            .execute(db)

            try #sql(
                """
                ALTER TABLE "userProfiles"
                ADD COLUMN "avatarSecondaryHex" TEXT NOT NULL DEFAULT 'F8C84A'
                """
            )
            .execute(db)

            try #sql(
                """
                ALTER TABLE "userProfiles"
                ADD COLUMN "avatarGender" TEXT NOT NULL DEFAULT 'neutral'
                """
            )
            .execute(db)

            try #sql(
                """
                ALTER TABLE "userProfiles"
                ADD COLUMN "avatarAge" INTEGER NOT NULL DEFAULT 5
                """
            )
            .execute(db)

            try #sql(
                """
                ALTER TABLE "userProfiles"
                ADD COLUMN "avatarImageData" BLOB NOT NULL DEFAULT X''
                """
            )
            .execute(db)
        }

        try migrator.migrate(database)
        defaultDatabase = database
    }
}
