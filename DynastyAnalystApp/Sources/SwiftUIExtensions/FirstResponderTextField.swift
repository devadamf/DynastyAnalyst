import SwiftUI
import UIKit

public struct FirstResponderTextField: UIViewRepresentable {

  public class Coordinator: NSObject, UITextFieldDelegate {

    var didBecomeFirstResponder = false
    @Binding var text: String?

    init(text: Binding<String?>) {
      self._text = text
    }

    public func textFieldDidChangeSelection(_ textField: UITextField) {
      text = textField.text
    }

  }

  var isFirstResponder: Bool
  @Binding var text: String?

  public init(
    isFirstResponder: Bool = true,
    text: Binding<String?>
  ) {
    self.isFirstResponder = isFirstResponder
    self._text = text
  }

  public func makeUIView(context: UIViewRepresentableContext<FirstResponderTextField>) -> UITextField {
    let textField = UITextField(frame: .zero)
    textField.delegate = context.coordinator
    return textField
  }

  public func makeCoordinator() -> FirstResponderTextField.Coordinator {
    Coordinator(text: $text)
  }

  public func updateUIView(
    _ uiView: UITextField,
    context: UIViewRepresentableContext<FirstResponderTextField>
  ) {
    uiView.text = text
    if isFirstResponder && !context.coordinator.didBecomeFirstResponder {
      uiView.becomeFirstResponder()
      context.coordinator.didBecomeFirstResponder = true
    }
  }

}
