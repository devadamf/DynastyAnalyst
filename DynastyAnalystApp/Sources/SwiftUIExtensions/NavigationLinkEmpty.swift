import SwiftUI

// Extension to create an empty NavigationLink
extension NavigationLink where Destination == EmptyView {
  public static func empty(label: () -> Label) -> NavigationLink {
    .init(destination: EmptyView(), label: label)
  }
}
