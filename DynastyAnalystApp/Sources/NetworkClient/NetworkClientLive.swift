import Combine
import ComposableArchitecture
import Foundation
import FoundationExtensions
import Helpers
import Models

extension NetworkClient {

  public static var live: NetworkClient {
    .init(getUser: _getUser)
  }

  private static var _getUser: (_ userID: String) async throws -> SleeperUser {
    { userID in
      let url = URL(string: "https://api.sleeper.app/v1/user/\(userID)")!
      let urlRequest = URLRequest(url: url)
//      let urlRequest = URLRequest(url: url) |> getRequest
      let data = try await sendRequest(urlRequest)
      return try JSONDecoder().decode(SleeperUser.self, from: data)
    }
  }

  @MainActor
  private static func sendRequest(_ urlRequest: URLRequest) async throws -> Data {
    let (data, response) = try await URLSession.shared.data(for: urlRequest)
      if let response = response as? HTTPURLResponse, response.statusCode != 200 {
        throw APIError.statusCode(response.statusCode)
      }
      return data
    }

}

extension NetworkClient: DependencyKey {
  public static var liveValue: NetworkClient = .live
}
