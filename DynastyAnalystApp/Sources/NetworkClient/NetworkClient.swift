import ComposableArchitecture
import Models

extension DependencyValues {
  public var networkClient: NetworkClient {
    get { self[NetworkClient.self] }
    set { self[NetworkClient.self] = newValue }
  }
}

public struct NetworkClient {
  public let getLeagues: (String, String) async throws -> [League]
  public let getUser: (String) async throws -> SleeperUser

  public init(
    getLeagues: @escaping (String, String) async throws -> [League],
    getUser: @escaping (String) async throws -> SleeperUser
  ) {
    self.getUser = getUser
    self.getLeagues = getLeagues
  }
}

extension NetworkClient: TestDependencyKey {
  public static var testValue: NetworkClient = .mock()
}

extension NetworkClient {
  public static func mock(
    getLeagues: @escaping (String, String) async throws -> [League] = unimplemented("NetworkClient._getLeagues"),
    getUser: @escaping (String) async throws -> SleeperUser = unimplemented("NetworkClient._getUser")
  ) -> NetworkClient {
    .init(
      getLeagues: getLeagues,
      getUser: getUser)
  }
}
