import Foundation
import RealmSwift

public final class SleeperUser: Object, Decodable {
  @Persisted(primaryKey: true) public var userID: String = ""
  @Persisted public var username: String = ""

  convenience init(userID: String, username: String) {
    self.init()
    self.userID = userID
    self.username = username
  }

  enum CodingKeys: String, CodingKey {
    case username
    case user_id
  }

  public convenience init(from decoder: Decoder) throws {
    self.init()
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.username = try values.decode(String.self, forKey: .username)
    self.userID = try values.decode(String.self, forKey: .user_id)
  }
}
