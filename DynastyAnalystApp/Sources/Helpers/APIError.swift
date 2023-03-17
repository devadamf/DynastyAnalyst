import Foundation

public enum APIError: Error, CustomStringConvertible, Equatable {
  case invalidBody
  case statusCode(Int)
  case unknown(Error)
  case urlError(URLError)

  public var description: String {
    switch self {

    case .invalidBody:
      return "Invalid JSON body"
    case .statusCode(let code):
      return "Status Code: \(code)"
    case .unknown(let error):
      return "Unknown Error: \(error.localizedDescription)"
    case .urlError(let error):
      return error.localizedDescription
    }
  }

  public static func == (lhs: APIError, rhs: APIError) -> Bool {
    switch (lhs, rhs) {
    case (.statusCode(let lhsStatusCode), .statusCode(let rhsStatusCode)):
      return lhsStatusCode == rhsStatusCode

    case (.urlError(let lhsError), .urlError(let rhsError)):
      return lhsError == rhsError

    default:
      return false
    }
  }
}
