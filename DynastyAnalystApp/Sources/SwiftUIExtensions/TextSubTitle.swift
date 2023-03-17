import SwiftUI

extension Text {
  public func subtitle(_ subtitle: String?) -> some View {
    modifier(SubtitleView(subtitle: subtitle))
  }
}

struct SubtitleView: ViewModifier {
  let subtitle: String?
  
  func body(content: Content) -> some View {
    VStack(alignment: .leading) {
      content
        .lineLimit(nil)
        .foregroundColor(.init(uiColor: .label))
      if let subtitle = subtitle, !subtitle.isEmpty {
        Text(subtitle)
          .foregroundColor(.init(.secondaryLabel))
          .font(.caption)
          .lineLimit(nil)
      }
    }
  }
}
