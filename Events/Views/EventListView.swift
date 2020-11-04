import Combine
import ComposableArchitecture
import SwiftUI

struct EventListView: View {
    let store: Store<EventListState, EventListAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                List {
                    ForEach(viewStore.events, id: \.id) { event in
                        NavigationLink(destination: EventDetailsView(
                                        store: Store(
                                            initialState: EventDetailsState(id: event.id),
                                            reducer: eventDetailsReducer,
                                            environment: EventDetailsEnvironment(facade: EventFacade()))))
                        {
                            EventRow(event: event)
                        }
                    }.navigationBarTitle("Events")
                }.onAppear(perform: {
                    viewStore.send(.fetchEvents)
                })
            }
        }
    }
}
