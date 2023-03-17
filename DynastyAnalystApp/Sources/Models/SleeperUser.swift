import Foundation
import RealmSwift

public final class SleeperUser: Object, Decodable {
  @Persisted(primaryKey: true) public var userID: String = ""
  @Persisted public var username: String

  init(
    userID: String,
    username: String
  ) {
    self.userID = userID
    self.username = username
  }

  enum CodingKeys: String, CodingKey {
    case username
    case user_id
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.username = try values.decode(String.self, forKey: .username)
    self.userID = try values.decode(String.self, forKey: .user_id)
  }
}
