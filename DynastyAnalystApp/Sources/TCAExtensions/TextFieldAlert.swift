import ComposableArchitecture
import SwiftUI

public struct TextFieldAlert: ReducerProtocol {

  public struct State: Equatable {

    let title: String
    let placeholder: String
    let message: String
    let button1Text: String
    let button2Text: String

    public var text: String

    public init(
      title: String,
      placeholder: String,
      message: String,
      button1Text: String,
      button2Text: String,
      text: String
    ) {
      self.title = title
      self.placeholder = placeholder
      self.message = message
      self.button1Text = button1Text
      self.button2Text = button2Text
      self.text = text
    }
  }

  public enum Action: Equatable {
    public enum Delegate: Equatable {
      case button1Pressed
      case button2Pressed
    }
    case delegate(Delegate)
    case setText(String)
  }
  
  public init() {}

  public var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .delegate:
        return .none
      case .setText(let text):
        state.text = text
        return .none
      }
    }
  }
}

public struct TextFieldAlertView: View {
  let store: StoreOf<TextFieldAlert>

  public init(store: StoreOf<TextFieldAlert>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store) { viewStore in
      VStack {
        Text(viewStore.title)
          .bold()
          .padding([.top])
        Text(viewStore.message)
          .multilineTextAlignment(.center)
          .minimumScaleFactor(0.4)
          .padding(.horizontal)
        TextField(
          viewStore.placeholder,
          text: viewStore.binding(
            get:\.text,
            send: TextFieldAlert.Action.setText))
          .frame(height: 24)
          .border(Color(UIColor.lightGray))
          .cornerRadius(3.0)
          .background(Color(UIColor.systemBackground))
          
          .padding()
        Divider()
          HStack {
            HStack(alignment: .center) {
              Spacer()
              Button(
                action: { viewStore.send(.delegate(.button1Pressed)) },
                label: {
                  Text(viewStore.button1Text)
                })
              Spacer()
            }
            Divider()
            HStack {
              Spacer()
              Button(
                action: { viewStore.send(.delegate(.button2Pressed)) },
                label: {
                  Text(viewStore.button2Text)
                    .foregroundColor(Color(UIColor.systemRed))
                })
              Spacer()
            }
          }
          .frame(maxHeight: 30)
        }
        .frame(
          idealWidth: 275,
          idealHeight: 250)
    }
  }
}

#if DEBUG
enum TextFieldAlert_Previews: PreviewProvider {
  static var previews: some View {
    TextFieldAlertView(
      store: .init(
        initialState: .init(
          title: "Title",
          placeholder: "placeholder",
          message: "message",
          button1Text: "button 1",
          button2Text: "button 2",
          text: ""),
        reducer: AnyReducer{ TextFieldAlert() },
        environment: ()))
  }
}
#endif
