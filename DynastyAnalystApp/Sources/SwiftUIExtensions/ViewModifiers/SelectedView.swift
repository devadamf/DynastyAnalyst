import SwiftUI

extension View {
  public func isSelected(_ isSelected: @escaping () -> Bool) -> some View {
    modifier(SelectedView(isSelected: isSelected))
  }
}

struct SelectedView: ViewModifier {
  @State var isSelected: () -> Bool
  
  init(isSelected: @escaping () -> Bool) {
    self.isSelected = isSelected
  }
  
  func body(content: Content) -> some View {
    HStack {
      content
      Spacer()
      if isSelected() {
        Image(systemName: "checkmark")
          .foregroundColor(.primary)
      }
    }
  }
}
