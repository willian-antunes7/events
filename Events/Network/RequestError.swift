import Foundation

enum RequestError: Error {
    case responseError(String)
    case decodingError(Error)
    case malformedApiResponse
    case authenticationFailed(String)

    var localizedDescription: String {
        switch self {
        case let .responseError(message):
            return message
        case let .authenticationFailed(message):
            return message
        case let .decodingError(error):
            switch error {
            case let DecodingError.keyNotFound(codingKey, _):
                return codingKey.debugDescription
            default:
                return error.localizedDescription
            }
        case .malformedApiResponse:
            return "Malformed Response"
        }
    }
}
