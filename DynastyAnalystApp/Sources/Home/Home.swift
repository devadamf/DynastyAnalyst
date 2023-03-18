import ComposableArchitecture
import NetworkClient
import Models
import RealmConfiguration
import RealmSwift
import SwiftUI
import TCAExtensions

public struct Home: ReducerProtocol {

  public struct State: Equatable {
    var username: String = ""

    public init(username: String) {
      self.username = username
    }
  }

  public enum Action: Equatable {
    case downloadUser(TaskResult<SleeperUser>)
    case onAppear
    case setUsername(String)
    case signInButtonPressed
  }

  @Dependency(\.networkClient) var networkClient

  public init() {}

  public var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      struct CancelEffect: Hashable {}

      switch action {

      case .downloadUser(.success(let user)):
        return .merge(
          .save(.create(SleeperUser.self, value: user)),
          .cancel(id: CancelEffect())
        )

      case .downloadUser(.failure):
        return .cancel(id: CancelEffect())

      case .onAppear:
        Realm.Configuration.defaultConfiguration = Realm.Configuration.dynastyAnalystConfiguration()
          return .fireAndForget {
            print("📂", try! Realm().configuration.fileURL!)
          }

      case .setUsername(let username):
        state.username = username
        return .none

      case .signInButtonPressed:
        return .task { [state] in
          await .downloadUser(TaskResult {
            try await networkClient.getUser(state.username)
          })
        }.cancellable(id: CancelEffect())
      }
    }
  }
}

public struct HomeView: View {
  let store: StoreOf<Home>

  public init(store: StoreOf<Home>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store) { viewStore in
      NavigationView {
          VStack {
            Text("Dynasty Analyst").font(.largeTitle)
            Spacer()
            Text("Please enter Sleeper username").font(.title3)
            TextField("", text: viewStore.binding(
              get: \.username,
              send: Home.Action.setUsername))
            .foregroundColor(.primary)
            .frame(width: 200, height: 48)
            .textFieldStyle(.roundedBorder)

            Button("Sign In") {
              viewStore.send(.signInButtonPressed)
            }
            .font(.title3)
            Spacer()
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .background(.teal)
      }
      .onAppear { viewStore.send(.onAppear) }
    }
  }
}
