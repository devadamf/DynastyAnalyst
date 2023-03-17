import ComposableArchitecture
import Models

extension DependencyValues {
  public var networkClient: NetworkClient {
    get { self[NetworkClient.self] }
    set { self[NetworkClient.self] = newValue }
  }
}

public struct NetworkClient {
  public let getUser: (String) async throws -> SleeperUser

  public init(getUser: @escaping (String) async throws -> SleeperUser) {
    self.getUser = getUser
  }
}

extension NetworkClient: TestDependencyKey {
  public static var testValue: NetworkClient = .mock()
}

extension NetworkClient {
  public static func mock(
    getUser: @escaping (String) async throws -> SleeperUser = unimplemented("NetworkClient._getUser")
  ) -> NetworkClient {
    .init(
      getUser: getUser)
  }
}
