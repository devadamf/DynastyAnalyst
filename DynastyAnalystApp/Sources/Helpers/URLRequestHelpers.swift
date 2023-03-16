import Foundation
import FoundationExtensions

public let guaranteeHeaders = mutateOver(\URLRequest.allHTTPHeaderFields, { $0 = $0 ?? [:] })

public let setHeader = { name, value in
  guaranteeHeaders
    <> { $0.allHTTPHeaderFields?[name] = value }
}

public let getRequest =
  guaranteeHeaders
  <> mutate(\.httpMethod, "GET")
  <> mutate(\.timeoutInterval, 600)
  <> setHeader("Accept-Encoding", "gzip, deflate")
  <> setHeader("Content_Type", "application/json")

public extension URLRequest {
  static func get(_ string: String) -> Self {
    Self(url: URL(string: string.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!)
    |> getRequest
  }
}
