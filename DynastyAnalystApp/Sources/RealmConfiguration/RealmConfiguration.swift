import Foundation
import Helpers
import RealmSwift

public extension Realm.Configuration {

  // swiftlint:disable cyclomatic_complexity
  static func dynastyAnalystConfiguration() -> Realm.Configuration {
    // swiftlint:disable force_cast
    Realm.Configuration(
      fileURL: FileManager.default
        .containerURL(forSecurityApplicationGroupIdentifier: Bundle.app.infoDictionary!["APP_GROUP_ID"] as! String)!
        .appendingPathComponent("default.realm"),
      schemaVersion: 1,
      migrationBlock: { migration, oldSchemaVersion in

        if oldSchemaVersion < 1 {}
      },
      shouldCompactOnLaunch: { totalBytes, usedBytes in
        // totalBytes refers to the size of the file on disk in bytes (data + free space)
        // usedBytes refers to the number of bytes used by data in the file
        // Compact if the file is over 100MB in size and less than 50% 'used'
        let hundredMB = 100 * 1_024 * 1_024
        let shouldCompact = (totalBytes > hundredMB) && (Double(usedBytes) / Double(totalBytes)) < 0.5
        return shouldCompact
      })
  }
}
