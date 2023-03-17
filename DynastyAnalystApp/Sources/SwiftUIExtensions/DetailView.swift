import SwiftUI

extension Text {
  public func detail(_ detail: String) -> some View {
    modifier(DetailView(detail: detail))
  }
}

struct DetailView: ViewModifier {
  let detail: String

  func body(content: Content) -> some View {
    HStack {
      content
      Spacer()
      Text(detail)
        .foregroundColor(.init(.secondaryLabel))
    }
  }
}
