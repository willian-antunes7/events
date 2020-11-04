import Foundation

struct Event: Equatable, Hashable, Codable {
    
    var id: String
    var title: String
    var date: Int
    var price: Double
    
}
