import SwiftUI

public struct DoneButton: View {

  let action: () -> Void

  public init(action: @escaping () -> Void) {
    self.action = action
  }

  public var body: some View {
    Button(
      action: action,
      label: { Text("Done") })
  }
}
