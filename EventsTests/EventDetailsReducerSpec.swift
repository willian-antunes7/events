import Combine
import ComposableArchitecture
@testable import Events
import Nimble
import Quick
import SwiftUI

class EventDetailsReducerSpec: QuickSpec {
    override func spec() {
        var store: TestStore<EventDetailsState, EventDetailsState, EventDetailsAction, EventDetailsAction, EventDetailsEnvironment>!
        
        describe("store") {
            context("when fetch event details is called") {
                context("when the request fails") {
                    it("should not change the event details, but alert the user") {
                        let state = EventDetailsState(id: "12")
                        let facade = EventFacadeMock()
                        store = TestStore(initialState: state, reducer: eventDetailsReducer, environment: EventDetailsEnvironment(facade: facade))
                        facade.shouldFail = true
                        store.assert(
                            .send(.fetchEventDetails) { _ in },
                            .receive(.fetchEventDetailsResult(.failure(.responseError("Expected error on EventFacade!")))) {
                                $0.alert = true
                                $0.alertText = "Expected error on EventFacade!"
                            }
                        )
                    }
                }
                context("when the request succeeds") {
                    it("should change the event details and fetch image for the event") {
                        let state = EventDetailsState(id: "12")
                        let facade = EventFacadeMock()
                        let event = EventDetails.makeStub()
                        let imageData = Data()
                        store = TestStore(initialState: state, reducer: eventDetailsReducer, environment: EventDetailsEnvironment(facade: facade))
                        store.assert(
                            .send(.fetchEventDetails) { _ in },
                            .receive(.fetchEventDetailsResult(.success(event))) {
                                $0.event = event
                            },
                            .receive(.fetchImageData(.success(imageData))) {
                                $0.imageData = imageData
                            }
                        )
                    }
                }
            }
            context("when post checkin is called") {
                context("if the request fails") {
                    it("should alert the user") {
                        let state = EventDetailsState(id: "12", event: EventDetails.makeStub())
                        let facade = EventFacadeMock()
                        store = TestStore(initialState: state, reducer: eventDetailsReducer, environment: EventDetailsEnvironment(facade: facade))
                        facade.shouldFail = true
                        store.assert(
                            .send(.postCheckin) { _ in },
                            .receive(.postCheckinResult(.failure(.responseError("Expected error on EventFacade!")))) {
                                $0.alert = true
                                $0.alertText = "Expected error on EventFacade!"
                            }
                        )
                    }
                }
                context("if the request succeeds") {
                    context("response code different than 200") {
                        it("should alert the user") {
                            let state = EventDetailsState(id: "12", event: EventDetails.makeStub())
                            let facade = EventFacadeMock()
                            let checkinResponse = ["code":"400"]
                            store = TestStore(initialState: state, reducer: eventDetailsReducer, environment: EventDetailsEnvironment(facade: facade))
                            facade.checkinResponse = checkinResponse
                            store.assert(
                                .send(.postCheckin) { _ in },
                                .receive(.postCheckinResult(.success(checkinResponse))) {
                                    $0.alert = true
                                    $0.alertText = "Something went wrong!"
                                }
                            )
                        }
                    }
                    context("response code 200") {
                        it("should alert the user accordingly") {
                            let state = EventDetailsState(id: "12", event: EventDetails.makeStub())
                            let facade = EventFacadeMock()
                            let checkinResponse = ["code":"200"]
                            store = TestStore(initialState: state, reducer: eventDetailsReducer, environment: EventDetailsEnvironment(facade: facade))
                            facade.checkinResponse = checkinResponse
                            store.assert(
                                .send(.postCheckin) { _ in },
                                .receive(.postCheckinResult(.success(checkinResponse))) {
                                    $0.alert = true
                                    $0.alertText = "Check-in Successful!"
                                }
                            )
                        }
                    }
                }
            }
        }
        describe("state") {
            context("formatted date") {
                it("should return the date as a string in the correct format") {
                    let state = EventDetailsState(id: "12", event: EventDetails.makeStub())
                    expect(state.formattedDate).to(equal("12/31/69, 9:00 PM"))
                }
            }
            context("image data") {
                context("when image data is nil") {
                    it("should return a placeholder image") {
                        let state = EventDetailsState(id: "12", event: EventDetails.makeStub(), imageData: nil)
                        expect(state.image).to(equal(Image(systemName: "camera.circle.fill")))
                    }
                }
            }
        }
    }
}

extension EventDetailsAction: Equatable {
    public static func == (lhs: EventDetailsAction, rhs: EventDetailsAction) -> Bool {
        switch (lhs, rhs) {
        case (.fetchEventDetails, .fetchEventDetails):
            return true
        case let (.fetchEventDetailsResult(lhsResult), .fetchEventDetailsResult(rhsResult)):
            switch (lhsResult, rhsResult) {
            case let (.success(lhsValue), .success(rhsValue)):
                return lhsValue == rhsValue
            case (.failure, .failure):
                return true
            default:
                return false
            }
        case let (.fetchImageData(lhsResult), .fetchImageData(rhsResult)):
            switch (lhsResult, rhsResult) {
            case let (.success(lhsValue), .success(rhsValue)):
                return lhsValue == rhsValue
            case (.failure, .failure):
                return true
            default:
                return false
            }
        case (.postCheckin, .postCheckin):
            return true
        case let (.postCheckinResult(lhsResult), .postCheckinResult(rhsResult)):
            switch (lhsResult, rhsResult) {
            case let (.success(lhsValue), .success(rhsValue)):
                return lhsValue == rhsValue
            case (.failure, .failure):
                return true
            default:
                return false
            }
        case (.dismissAlert, .dismissAlert):
            return true
        case (.presentShareSheet, .presentShareSheet):
            return true
        case (.dismissShareSheet, .dismissShareSheet):
            return true
        default:
            return false
        }
    }
}
