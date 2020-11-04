import Combine
import Foundation
@testable import Events

class EventFacadeMock: EventFacadeProtocol {
    var shouldFail = false
    let errorMessage = "Expected error on EventFacade!"
    var events: [Event] = []
    var eventDetails: EventDetails = EventDetails.makeStub()
    var checkinResponse: [String:String] = [:]
    
    func getEvents() -> AnyPublisher<[Event], RequestError> {
        return Future { completion in
            if self.shouldFail {
                completion(.failure(.responseError(self.errorMessage)))
            } else {
                completion(.success(self.events))
            }
        }.eraseToAnyPublisher()
    }
    
    func getEventDetails(id: String) -> AnyPublisher<EventDetails, RequestError> {
        return Future { completion in
            if self.shouldFail {
                completion(.failure(.responseError(self.errorMessage)))
            } else {
                completion(.success(self.eventDetails))
            }
        }.eraseToAnyPublisher()
    }
    
    func getImageData(url: String) -> AnyPublisher<Data, RequestError> {
        return Future { completion in
            if self.shouldFail {
                completion(.failure(.responseError(self.errorMessage)))
            } else {
                completion(.success(Data()))
            }
        }.eraseToAnyPublisher()
    }
    
    func postCheckin(eventId: String, name: String, email: String) -> AnyPublisher<[String : String], RequestError> {
        return Future { completion in
            if self.shouldFail {
                completion(.failure(.responseError(self.errorMessage)))
            } else {
                completion(.success(self.checkinResponse))
            }
        }.eraseToAnyPublisher()
    }
    
    
}
