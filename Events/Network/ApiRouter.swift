import Alamofire

enum ApiRouter: URLRequestConvertible {
    case getEvents
    case getEventDetails(String)
    case postCheckin(String, String, String)
    
    var method: HTTPMethod {
        switch self {
        case .postCheckin:
            return .post
        default:
            return .get
        }
    }

    private static func baseUrlWithPath(path: String) -> URL {
        URL(string: "https://5f5a8f24d44d640016169133.mockapi.io/api" + path)!
    }

    var url: URL {
        switch self {
        case .getEvents:
            return ApiRouter.baseUrlWithPath(path: "/events")
        case .getEventDetails:
            return ApiRouter.baseUrlWithPath(path: "/events")
        default:
            return ApiRouter.baseUrlWithPath(path: "/v1")
        }
    }

    func asURLRequest() -> URLRequest {
        var mutableURLRequest = URLRequest(url: url)
        mutableURLRequest.httpMethod = method.rawValue
        return requestWithParameters(mutableURLRequest, parameters: parameters())
    }

    private func requestWithParameters(_ request: URLRequest, parameters: [String: Any]) -> URLRequest {
        switch method {
        case .get:
            return try! URLEncoding.default.encode(request, with: parameters)
        default:
            return try! JSONEncoding.default.encode(request, with: parameters)
        }
    }

    private func parameters() -> [String: Any] {
        switch self {
        case let .getEventDetails(id):
            return ["id":id]
        case let .postCheckin(eventId, name, email):
            return ["eventId": eventId, "name": name, "email": email]
        case .getEvents:
            return [:]
        }
    }
}
