import Foundation
import SwiftUI

public struct FormattedTextField<Formatter: TextFieldFormatter>: View {

  public init(
    _ title: String,
    value: Binding<Formatter.Value>,
    formatter: Formatter
  ) {
    self.title = title
    self.value = value
    self.formatter = formatter
  }

  private let title: String
  private let value: Binding<Formatter.Value>
  private let formatter: Formatter

  @State private var isEditing: Bool = false
  @State private var editingValue: String = ""

  public var body: some View {
    TextField(
      title,
      text: Binding(
        get: {
          self.isEditing
            ? self.editingValue
            : self.formatter.displayString(for: self.value.wrappedValue)
        },
        set: { string in
          self.editingValue = string
          self.value.wrappedValue = self.formatter.value(from: string)
        }
      ),
      onEditingChanged: { isEditing in
        self.isEditing = isEditing
        self.editingValue = self.formatter.editingString(for: self.value.wrappedValue)
      }
    )
  }

}

public protocol TextFieldFormatter {
  associatedtype Value
  func displayString(for value: Value) -> String
  func editingString(for value: Value) -> String
  func value(from string: String) -> Value
}

extension NumberFormatter {
  static let currency: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    return formatter
  }()

  static let currencyEditing: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.groupingSeparator = ""
    formatter.minimumFractionDigits = NumberFormatter.currency.minimumFractionDigits
    formatter.maximumFractionDigits = NumberFormatter.currency.maximumFractionDigits
    return formatter
  }()
}

public struct CurrencyTextFieldFormatter: TextFieldFormatter {
  public typealias Value = Double?

  public init() {}

  public func displayString(for value: Double?) -> String {
    guard let value = value else { return "" }
    return NumberFormatter.currency.string(for: value) ?? ""
  }

  public func editingString(for value: Double?) -> String {
    guard let value = value else { return "" }
    return NumberFormatter.currencyEditing.string(for: value) ?? ""
  }

  public func value(from string: String) -> Double? {
    let formatter = NumberFormatter.currencyEditing

    return (formatter.number(from: string.replacingOccurrences(of: Locale.current.currencySymbol ?? "$", with: ""))?.doubleValue)
      .flatMap(formatter.string(for:))
      .flatMap(formatter.number(from:))?
      .doubleValue
  }
}

public struct IntTextFieldFormatter: TextFieldFormatter {
  public typealias Value = Int?

  public init() {}

  public func displayString(for value: Int?) -> String {
    guard let value = value else { return "" }
    return String(value)
  }

  public func editingString(for value: Int?) -> String {

    guard let value = value else { return "" }
    return String(value)
  }

  public func value(from string: String) -> Int? {
    Int(string)
  }
}

public struct DoubleTextFieldFormatter: TextFieldFormatter {
  public typealias Value = Double?

  public init() {}

  public func displayString(for value: Double?) -> String {
    guard let value = value else { return "" }
    return String(value)
  }

  public func editingString(for value: Double?) -> String {

    guard let value = value else { return "" }
    return String(value)
  }

  public func value(from string: String) -> Double? {
    Double(string)
  }
}
