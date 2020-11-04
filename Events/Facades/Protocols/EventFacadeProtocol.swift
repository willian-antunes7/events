import Combine
import Foundation

protocol EventFacadeProtocol {
    func getEvents() -> AnyPublisher<[Event], RequestError>
    func getEventDetails(id: String) -> AnyPublisher<EventDetails, RequestError>
    func getImageData(url: String) -> AnyPublisher<Data, RequestError>
    func postCheckin(eventId: String, name: String, email: String) -> AnyPublisher<[String:String], RequestError>
}
