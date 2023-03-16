import ComposableArchitecture
import SwiftUI

public struct Home: ReducerProtocol {

  public struct State: Equatable {
    var username: String = ""

    public init(username: String) {
      self.username = username
    }
  }

  public enum Action: Equatable {
    case setUsername(String)
    case signInButtonPressed
  }

  public init() {}

  public var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .setUsername(let username):
        state.username = username
        return .none

      case .signInButtonPressed:
        return .none
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
            .foregroundColor(.black)
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
    }
  }
}
