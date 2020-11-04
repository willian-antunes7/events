import Foundation

struct EventDetails: Equatable, Codable {
    
    var id: String
    var people: [Person]
    var date: Int
    var description: String
    var image: String
    var longitude: Double
    var latitude: Double
    var price: Double
    var title: String
    
}
