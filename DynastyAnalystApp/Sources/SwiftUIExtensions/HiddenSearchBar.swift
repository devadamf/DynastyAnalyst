import SwiftUI

extension View {

  @ViewBuilder
  public func searchable(hideIf hide: Bool, text: Binding<String>, placement: SearchFieldPlacement = .automatic) -> some View {
    if hide {
      self
    } else {
      self.modifier(HiddenSearchBar(text: text, placement: placement))
    }
  }
}

struct HiddenSearchBar: ViewModifier {
  let text: Binding<String>
  let placement: SearchFieldPlacement

  func body(content: Content) -> some View {
    return content.searchable(text: text, placement: placement)
  }
}
