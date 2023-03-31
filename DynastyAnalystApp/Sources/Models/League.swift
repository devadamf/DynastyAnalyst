import Foundation
import RealmSwift

public final class League: Object, Decodable {
  @Persisted(primaryKey: true) public var leagueID: String = ""
  @Persisted public var name: String = ""

  convenience init(
    leagueID: String,
    name: String
  ) {
    self.init()
    self.leagueID = leagueID
    self.name = name
  }

  enum CodingKeys: String, CodingKey {
    case league_id
    case name
  }

  public convenience init(from decoder: Decoder) throws {
    self.init()
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.leagueID = try values.decode(String.self, forKey: .league_id)
    self.name = try values.decode(String.self, forKey: .name)
  }
}
