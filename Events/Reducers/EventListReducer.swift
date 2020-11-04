import Combine
import ComposableArchitecture

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
