import ComposableArchitecture
import NetworkClient
import Models
import RealmConfiguration
import RealmSwift
import SwiftUI
import TCAExtensions

public struct Home: ReducerProtocol {

  public struct State: Equatable {
    var yearSelection: YearSelection.State?
    var username: String = ""

    public init(username: String) {
      self.username = username
    }
  }

  public enum Action: Equatable {
    case downloadUser(TaskResult<SleeperUser>)
    case yearSelection(YearSelection.Action)
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
        state.yearSelection = .init(
          currentYear: Calendar.current.component(.year, from: .now),
          selectedYear: Calendar.current.component(.year, from: .now),
          userID: user.userID)
        return .save(.create(SleeperUser.self, value: user))
//          .cancel(id: CancelEffect())
//        )

      case .downloadUser(.failure):
        return .none
//        return .cancel(id: CancelEffect())

      case .yearSelection:
        return .none

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
        }
//        .cancellable(id: CancelEffect())
      }
    }
    .ifLet(\.yearSelection, action: /Action.yearSelection) {
      YearSelection()
    }
  }
}

public struct HomeView: View {
  struct ViewState: Equatable {
    let displayYearSelection: Bool
    let username: String

    init(state: Home.State) {
      self.displayYearSelection = state.yearSelection != nil
      self.username = state.username
    }
  }

  let store: StoreOf<Home>

  public init(store: StoreOf<Home>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store.scope(state: ViewState.init)) { viewStore in
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
          .fullScreenCover(isPresented: .constant(viewStore.displayYearSelection), content: {
            NavigationView {
              IfLetStore(
                store.scope(
                  state: \.yearSelection,
                  action: Home.Action.yearSelection),
                then: YearSelectionView.init)
            }
          })
      }
      .onAppear { viewStore.send(.onAppear) }
    }
  }
}
