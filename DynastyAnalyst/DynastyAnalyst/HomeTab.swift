import ComposableArchitecture
import SwiftUI

struct HomeTab: ReducerProtocol {

  struct State: Equatable {

  }

  enum Action: Equatable {

  }

  public var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      }
    }
  }
}

struct HomeTabView: View {
  let store: StoreOf<HomeTab>

  var body: some View {
    EmptyView()
  }
}
