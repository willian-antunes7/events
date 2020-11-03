import Combine
import ComposableArchitecture
import SwiftUI

struct EventListState: Equatable {
    var events: [Event] = []
    var isRefreshing = false
}

enum EventListAction {
    case fetchEvents
    case fetchEventsResult(Result<[Event], RequestError>)
    case refreshingChanged(Bool)
}

struct EventListEnvironment {
    var facade: EventFacadeProtocol
//    let getEvents: () -> AnyPublisher<[Event], RequestError>
}

let eventListReducer = Reducer<EventListState, EventListAction, EventListEnvironment> { state, action, environment in
    switch action {
    case .fetchEvents:
        return environment.facade.getEvents().catchToEffect().map(EventListAction.fetchEventsResult)
    case let .fetchEventsResult(result):
        state.isRefreshing = false
        switch result {
        case let .success(events):
            state.events = events
        case let .failure(error):
            print(error)
        }
        return .none
    case let .refreshingChanged(isRefreshing):
        state.isRefreshing = isRefreshing
        return .none
    }
}

struct ContentView: View {
    let store: Store<EventListState, EventListAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                ForEach(viewStore.events, id: \.id) { event in
                    EventRow(event: event)
                }
            }.onAppear(perform: {
                viewStore.send(.fetchEvents)
            })
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
