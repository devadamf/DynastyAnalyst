import Home
import SwiftUI

@main
struct DynastyAnalystApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
          HomeView(
            store: .init(
              initialState: .init(username: ""),
              reducer: Home()))
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
