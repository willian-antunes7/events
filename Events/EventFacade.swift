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
}
