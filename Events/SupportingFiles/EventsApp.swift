import ComposableArchitecture
import SwiftUI

@main
struct EventsApp: App {
    var body: some Scene {
        WindowGroup {
            EventListView(store: Store(initialState: EventListState(events: []), reducer: eventListReducer, environment: EventListEnvironment(facade: EventFacade())))
        }
    }
}
