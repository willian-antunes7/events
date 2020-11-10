import Combine
import ComposableArchitecture
import SwiftUI
import SwiftUIRefresh

struct EventListView: View {
    let store: Store<EventListState, EventListAction>
    
    init(store: Store<EventListState, EventListAction>) {
        self.store = store
        UINavigationBar.appearance().tintColor = .systemPink
    }
    
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
                    }
                }
                .navigationBarTitle("Events")
                .alert(isPresented: viewStore.binding(get: \.alert, send: .dismissAlert)) {
                    return Alert(title: Text("Network failure"), message: Text(viewStore.alertText))
                }
                .pullToRefresh(isShowing: viewStore.binding(get: \.isRefreshing,
                                                            send: EventListAction.refreshingChanged)) {
                    viewStore.send(.fetchEvents)
                }
                .onAppear(perform: {
                    viewStore.send(.fetchEvents)
                })
            }
        }
    }
}
