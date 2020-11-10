import Combine
import ComposableArchitecture
@testable import Events
import Nimble
import Quick

class EventListReducerSpec: QuickSpec {
    override func spec() {
        var store: TestStore<EventListState, EventListState, EventListAction, EventListAction, EventListEnvironment>!
        
        describe("store") {
            context("when fetch events is called") {
                context("when the request fails") {
                    it("should not change the list of events and alert the user") {
                        let state = EventListState()
                        let facade = EventFacadeMock()
                        store = TestStore(initialState: state, reducer: eventListReducer, environment: EventListEnvironment(facade: facade))
                        facade.shouldFail = true
                        store.assert(
                            .send(.fetchEvents) { _ in },
                            .receive(.fetchEventsResult(.failure(.responseError("Expected error on EventFacade!")))) {
                                $0.alert = true
                                $0.alertText = "Expected error on EventFacade!"
                            }
                        )
                    }
                }
                context("when the request succeeds") {
                    it("should change the list of events") {
                        let state = EventListState()
                        let facade = EventFacadeMock()
                        let events = [Event.makeStub(), Event.makeStub()]
                        store = TestStore(initialState: state, reducer: eventListReducer, environment: EventListEnvironment(facade: facade))
                        facade.events = events
                        store.assert(
                            .send(.fetchEvents) { _ in },
                            .receive(.fetchEventsResult(.success(events))) {
                                $0.events = events
                            }
                        )
                    }
                }
            }
            context("when it's refreshing") {
                context("when the request fails") {
                    it("should not change the list of events, but change isRefreshing to false and alert the user") {
                        var state = EventListState()
                        let facade = EventFacadeMock()
                        store = TestStore(initialState: state, reducer: eventListReducer, environment: EventListEnvironment(facade: facade))
                        state.isRefreshing = true
                        facade.shouldFail = true
                        store.assert(
                            .send(.fetchEvents) { _ in },
                            .receive(.fetchEventsResult(.failure(.responseError("Expected error on EventFacade!")))) {
                                $0.isRefreshing = false
                                $0.alert = true
                                $0.alertText = "Expected error on EventFacade!"
                            }
                        )
                    }
                }
                context("when the request succeeds") {
                    it("should change the list of events") {
                        var state = EventListState()
                        let facade = EventFacadeMock()
                        let events = [Event.makeStub(), Event.makeStub()]
                        store = TestStore(initialState: state, reducer: eventListReducer, environment: EventListEnvironment(facade: facade))
                        facade.events = events
                        state.isRefreshing = true
                        store.assert(
                            .send(.fetchEvents) { _ in },
                            .receive(.fetchEventsResult(.success(events))) {
                                $0.events = events
                                $0.isRefreshing = false
                            }
                        )
                    }
                }
            }
        }
    }
}

extension EventListAction: Equatable {
    public static func == (lhs: EventListAction, rhs: EventListAction) -> Bool {
        switch (lhs, rhs) {
        case (.fetchEvents, .fetchEvents):
            return true
        case let (.fetchEventsResult(lhsResult), .fetchEventsResult(rhsResult)):
            switch (lhsResult, rhsResult) {
            case let (.success(lhsValue), .success(rhsValue)):
                return lhsValue == rhsValue
            case (.failure, .failure):
                return true
            default:
                return false
            }
        case let (.refreshingChanged(lhsValue), .refreshingChanged(rhsValue)):
            return lhsValue == rhsValue
        default:
            return false
        }
    }
}
