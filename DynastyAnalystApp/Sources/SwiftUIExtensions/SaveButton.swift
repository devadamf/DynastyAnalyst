import SwiftUI

public struct SaveButton: View {

  let action: () -> Void

  public init(action: @escaping () -> Void) {
    self.action = action
  }

  public var body: some View {
    Button(
      action: action,
      label: { Text("Save") })
  }
}
