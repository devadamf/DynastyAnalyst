import UIKit

public extension Bundle {

  /// Return the main bundle when in the app or an app extension.
  static var app: Bundle {
    var components = main.bundleURL.path.split(separator: "/")

    guard let index = components.lastIndex(where: { $0.hasSuffix(".app") })
    else { return main }
    components.removeLast(components.count - 1 - index)
    return Bundle(path: components.joined(separator: "/")) ?? main
  }
}
