import Combine
import Foundation

final class EventFacade: EventFacadeProtocol {
    private let apiClient: ApiClientProtocol
    
    init(apiClient: ApiClientProtocol = ApiClient.shared) {
        self.apiClient = apiClient
    }
    
    func getEvents() -> AnyPublisher<[Event], RequestError> {
        Future { completion in
            self.performGetEvents(callback: completion)
        }.eraseToAnyPublisher()
    }
    
    private func performGetEvents(callback: @escaping ((Result<[Event], RequestError>) -> Void)) {
        apiClient.request(.getEvents) { (response: Result<[Event], RequestError>) in
            switch response {
            case let .success(events):
                callback(.success(events))
            case let .failure(error):
                callback(.failure(error))
            }
        }
    }
    
    func getEventDetails(id: String) -> AnyPublisher<EventDetails, RequestError> {
        Future { completion in
            self.performGetEventDetails(id: id, callback: completion)
        }.eraseToAnyPublisher()
    }
    
    private func performGetEventDetails(id: String, callback: @escaping ((Result<EventDetails, RequestError>) -> Void)) {
        apiClient.request(.getEventDetails(id)) { (response: Result<EventDetails, RequestError>) in
            switch response {
            case let .success(events):
                callback(.success(events))
            case let .failure(error):
                callback(.failure(error))
            }
        }
    }
    
    func getImageData(url: String) -> AnyPublisher<Data, RequestError> {
        Future { completion in
            self.performGetImageData(url: url, callback: completion)
        }.eraseToAnyPublisher()
    }
    
    private func performGetImageData(url: String, callback: @escaping ((Result<Data, RequestError>) -> Void)) {
        apiClient.request(.getImageData(url)) { (response: Result<Data, RequestError>) in
            switch response {
            case let .success(data):
                callback(.success(data))
            case let .failure(error):
                callback(.failure(error))
            }
        }
    }
    
    func postCheckin(eventId: String, name: String, email: String) -> AnyPublisher<[String : String], RequestError> {
        Future { completion in
            self.performPostCheckin(eventId: eventId, name: name, email: email, callback: completion)
        }.eraseToAnyPublisher()
    }
    
    private func performPostCheckin(eventId: String, name: String, email: String, callback: @escaping ((Result<[String:String], RequestError>) -> Void)) {
        apiClient.request(.postCheckin(eventId, name, email)) { (response: Result<[String:String], RequestError>) in
            switch response {
            case let .success(result):
                callback(.success(result))
            case let .failure(error):
                callback(.failure(error))
            }
        }
    }
}
