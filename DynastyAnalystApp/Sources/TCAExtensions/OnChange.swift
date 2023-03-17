import ComposableArchitecture

extension ReducerProtocol {

  public func onChange<ChildState: Equatable>(
    of toLocalState: @escaping (State) -> ChildState,
    perform additionalEffects: @escaping (ChildState, inout State, Action) -> EffectTask<Action>
  ) -> some ReducerProtocol<State, Action> {
    onChange(of: toLocalState) { additionalEffects($1, &$2, $3) }
  }

  public func onChange<ChildState: Equatable>(
    of toLocalState: @escaping (State) -> ChildState,
    perform additionalEffects: @escaping (ChildState, ChildState, inout State, Action) -> EffectTask<Action>
  ) -> some ReducerProtocol<State, Action> {
    ChangeReducer(
      base: self,
      toLocalState: toLocalState,
      perform: additionalEffects)
  }

  public func onChange<ChildState: Equatable>(
    of toLocalState: @escaping (State) -> ChildState,
    send action: @escaping (ChildState) -> Action
  ) -> some ReducerProtocol<State, Action> {
    onChange(of: toLocalState, perform: { child, _, _ in
      .init(value: action(child))
    })
  }
}

struct ChangeReducer<Base: ReducerProtocol, ChildState: Equatable>: ReducerProtocol {
  let base: Base
  let toLocalState: (Base.State) -> ChildState
  let perform: (ChildState, ChildState, inout Base.State, Base.Action) -> EffectTask<Action>

  init(
    base: Base,
    toLocalState: @escaping (Base.State) -> ChildState,
    perform: @escaping (ChildState, ChildState, inout Base.State, Base.Action) -> EffectTask<Action>
  ) {
    self.base = base
    self.toLocalState = toLocalState
    self.perform = perform
  }

  public func reduce(
    into state: inout Base.State,
    action: Base.Action
  ) -> Effect<Base.Action, Never> {
    let previousLocalState = toLocalState(state)
    let effects = base.reduce(into: &state, action: action)
    let localState = toLocalState(state)

    return previousLocalState != localState
    ? .merge(effects, perform(previousLocalState, localState, &state, action))
    : effects
  }
}

