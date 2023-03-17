import ComposableArchitecture
import RealmExtensions

public extension Effect where Failure == Never {
  static func save(_ transaction: RealmTransaction) -> Self {
    .fireAndForget {
      transaction.refresh().write()
    }
  }
}
