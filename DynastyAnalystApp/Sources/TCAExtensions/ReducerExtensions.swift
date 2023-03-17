import ComposableArchitecture

extension Reducer where Environment == Void {
  public func pullback<GlobalState, GlobalAction, GlobalEnvironment>(
    state toLocalState: WritableKeyPath<GlobalState, State>,
    action toLocalAction: CasePath<GlobalAction, Action>
  ) -> Reducer<GlobalState, GlobalAction, GlobalEnvironment> {
    pullback(
      state: toLocalState,
      action: toLocalAction,
      environment: { _ in () })
  }

  public func forEach<GlobalState, GlobalAction, GlobalEnvironment, ID>(
    state toLocalState: WritableKeyPath<GlobalState, IdentifiedArray<ID, State>>,
    action toLocalAction: CasePath<GlobalAction, (ID, Action)>,
    _ file: StaticString = #file,
    _ line: UInt = #line
  ) -> Reducer<GlobalState, GlobalAction, GlobalEnvironment> {
    forEach(
      state: toLocalState,
      action: toLocalAction,
      environment: { _ in () },
      file: file,
      line: line)
  }

  public func pullback<GlobalState, GlobalAction, GlobalEnvironment>(
    state toLocalState: CasePath<GlobalState, State>,
    action toLocalAction: CasePath<GlobalAction, Action>,
    file: StaticString = #fileID,
    line: UInt = #line
  ) -> Reducer<GlobalState, GlobalAction, GlobalEnvironment> {
    pullback(
      state: toLocalState,
      action: toLocalAction,
      environment: { _ in () },
      file: file,
      line: line)
  }
}

extension Reducer where Action: Equatable {
  public func replace(
    _ replaceAction: Action,
    with effect: @escaping (inout State, Environment) -> Effect<Action, Never>
  ) -> Self {
    .init { state, action, environment in
      if replaceAction == action {
        return effect(&state, environment)
      } else {
        return self(&state, action, environment)
      }
    }
  }
  
  public func replace<Value>(
    casePath replaceAction: CasePath<Action, Value>,
    with effect: @escaping (inout State, Value, Environment) -> Effect<Action, Never>
  ) -> Self {
    .init { state, action, environment in
      if let value = replaceAction.extract(from: action) {
        return effect(&state, value, environment)
      } else {
        return self(&state, action, environment)
      }
    }
  }
}
