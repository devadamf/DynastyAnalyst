import SwiftUI

public struct SubtitleDetailView: View {

  let subtitle: String?
  let subtitleColor: Color
  let title: String
  let titleColor: Color

  public init(
    subtitle: String?,
    subtitleColor: Color,
    title: String,
    titleColor: Color
  ) {
    self.subtitle = subtitle
    self.subtitleColor = subtitleColor
    self.title = title
    self.titleColor = titleColor
  }

  public var body: some View {
    VStack (alignment: .leading, spacing: 5) {
      Text(title)
        .foregroundColor(titleColor)
        .font(.subheadline)
      if let subtitleValue = subtitle {
        if subtitleValue != "" {
          Text(subtitleValue)
            .foregroundColor(subtitleColor)
        }
      }
    }
  }
}

struct SubtitleDetailView_Previews: PreviewProvider {
  static var previews: some View {
    SubtitleDetailView(
      subtitle: "Subtitle",
      subtitleColor: .init(.label),
      title: "Title",
      titleColor: .init(.secondaryLabel)
    )
  }
}
