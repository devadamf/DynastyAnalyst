import SwiftUI

extension Binding {

  public var optional: Binding<Value?> {
    .init(
      get: { .some(self.wrappedValue) },
      set: {
        if let value = $0 {
          self.wrappedValue = value
        }
      }
    )
  }

}

public func ?? <T>(lhs: Binding<T?>, rhs: T) -> Binding<T> {
  Binding(
    get: { lhs.wrappedValue ?? rhs },
    set: { lhs.wrappedValue = $0 }
  )
}
