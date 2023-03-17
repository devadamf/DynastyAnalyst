import SwiftUI

public struct StopButton: View {
  let action: () -> Void

  public init(action: @escaping () -> Void) {
    self.action = action
  }

  public var body: some View {
    Button(
      action: action,
      label: { Image(systemName: "xmark").font(.system(size: 21)) })
  }

}
