import Foundation

struct Person: Equatable, Codable, Identifiable {
    
    var id: String
    var eventId: String
    var name: String
    var picture: String
    
}
