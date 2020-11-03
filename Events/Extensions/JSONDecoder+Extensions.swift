import Foundation

extension JSONDecoder {
    static let shared = createSharedDecoder()

    private static func createSharedDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
//        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}
