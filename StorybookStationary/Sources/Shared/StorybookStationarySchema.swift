import Dependencies
import Foundation
import SQLiteData

@Table
struct UserProfile: Equatable, Identifiable, Sendable {
    let id: UUID
    var name = ""
    var createdAt: Date = .init()
    var lastUsedAt: Date = .init()
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

        try migrator.migrate(database)
        defaultDatabase = database
    }
}
