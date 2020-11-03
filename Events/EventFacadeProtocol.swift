import Combine

protocol EventFacadeProtocol {
    func getEvents() -> AnyPublisher<[Event], RequestError>
}
