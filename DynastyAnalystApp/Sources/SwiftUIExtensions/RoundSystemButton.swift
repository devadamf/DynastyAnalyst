import Foundation
import SwiftUI

public struct RoundSystemButton: View {
    
  let systemName: String
  let color: Color
  let action: () -> Void
    
  var textColor: UIColor {
    UIColor { collection in
      collection.userInterfaceStyle == .dark
        ? .black
        : .white
    }
  }
    
  public init(
    systemName: String,
    color: Color,
    action: @escaping () -> Void
  ) {
    self.systemName = systemName
    self.color = color
    self.action = action
  }
    
  public var body: some View {
    Button(
      action: action,
      label: {
        Image(systemName: systemName)
          .padding()
      }
    )
    .background(color)
    .background(in: Circle())
    .foregroundStyle(Color(textColor).shadow(.drop(radius: 1, y: 1.5)))
    .padding()
  }
}

#if DEBUG
enum RoundSystemButon_Previews: PreviewProvider {
  static var previews: some View {
    RoundSystemButton(systemName: "calendar", color: .green, action: {})
  }
}
#endif
