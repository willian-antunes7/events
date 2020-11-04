import Combine
import ComposableArchitecture

struct EventListState: Equatable {
    var events: [Event] = []
}

enum EventListAction {
    case fetchEvents
    case fetchEventsResult(Result<[Event], RequestError>)
}

struct EventListEnvironment {
    var facade: EventFacadeProtocol
}

let eventListReducer = Reducer<EventListState, EventListAction, EventListEnvironment> { state, action, environment in
    switch action {
    case .fetchEvents:
        return environment.facade.getEvents().catchToEffect().map(EventListAction.fetchEventsResult)
    case let .fetchEventsResult(result):
        switch result {
        case let .success(events):
            state.events = events
        case let .failure(error):
            print(error)
        }
        return .none
    }
}
