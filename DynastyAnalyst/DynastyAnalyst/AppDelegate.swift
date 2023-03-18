import Home
import SwiftUI

@main
struct DynastyAnalystApp: App {

    var body: some Scene {
        WindowGroup {
          HomeView(
            store: .init(
              initialState: .init(username: ""),
              reducer: Home()))
        }
    }
}
