import Foundation
@testable import Events

extension Event {
    static func makeStub(id: String = "12", title: String = "event", date: Int = 0, price: Double = 1.0) -> Event {
        return Event(id: id, title: title, date: date, price: price)
    }
}

extension EventDetails {
    static func makeStub(id: String = "12", people: [Person] = [], date: Int = 0, description: String = "nice event", image: String = "imageurl", longitude: Double = 0.0, latitude: Double = 0.0, price: Double = 1.0, title: String = "event") -> EventDetails {
        return EventDetails(id: id, people: people, date: date, description: description, image: image, longitude: longitude, latitude: latitude, price: price, title: title)
    }
}
