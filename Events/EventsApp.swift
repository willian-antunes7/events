import ComposableArchitecture
import SwiftUI

@main
struct EventsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(store: Store(initialState: EventListState(events: []), reducer: eventListReducer, environment: EventListEnvironment(facade: EventFacade())))
        }
    }
}
