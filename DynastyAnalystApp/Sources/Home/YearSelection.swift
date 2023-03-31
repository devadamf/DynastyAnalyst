import ComposableArchitecture
import Models
import RealmExtensions
import SwiftUI

public struct YearSelection: ReducerProtocol {

  public struct State: Equatable {
    let currentYear: Int
    var isFetchingData: Bool = false
    var leagues: [League] = []
    var selectedYear: Int
    let userID: String
  }

  public enum Action: Equatable {
    case downloadLeagues(TaskResult<[League]>)
    case loadLeagueButtonPressed
    case setYear(Int)
  }

  @Dependency(\.networkClient) var networkClient

  public init() {}

  public var body: some ReducerProtocolOf<Self> {
    Reduce { state, action in
      switch action {

      case .downloadLeagues(.failure):
        state.isFetchingData = false
        return .none

      case .downloadLeagues(.success(let leagues)):
        state.isFetchingData = false
        state.leagues = leagues
        let leaguesTransaction = leagues
          .map(RealmTransaction.create(League.self))
          .reduce()
        return .save(leaguesTransaction)

      case .loadLeagueButtonPressed:
        state.isFetchingData = true
        return .task { [state] in
          await .downloadLeagues(TaskResult {
            try await networkClient.getLeagues(state.userID, "\(state.selectedYear)")
          })
        }

      case .setYear(let year):
        state.selectedYear = year
        return .none
      }
    }
  }
}

public struct YearSelectionView: View {
  let store: StoreOf<YearSelection>

  public var body: some View {
    WithViewStore(store) { viewStore in
      VStack {
//        Form {
          Picker(
            selection: viewStore.binding(
              get: { $0.selectedYear },
              send: YearSelection.Action.setYear),
            label: Text("Select League Year"),
            content: {
              ForEach(2000...viewStore.currentYear, id: \.self) {
                Text(String($0))
              }
            }
          )
//        }
        if viewStore.isFetchingData {
          ProgressView()
        }
        Button(
          action: { viewStore.send(.loadLeagueButtonPressed) },
          label: { Text("Load My Leagues") })
        if !viewStore.leagues.isEmpty {
          List(viewStore.leagues, id: \.leagueID) { league in
            Text(league.name)
          }
        }
      }
    }
  }
}
