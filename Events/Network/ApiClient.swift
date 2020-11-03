import Alamofire

class ApiClient: ApiClientProtocol {
    static let shared = ApiClient()
    private var session = Session.default

    private init() {}

    func request<T: Decodable>(_ route: ApiRouter,
                               _ callback: @escaping ((Swift.Result<T, RequestError>) -> Void)) {
        session
            .request(route)
            .validate()
            .responseData { (response: DataResponse<Data, AFError>) in
                switch response.result {
                case let .success(apiResponse):
                    callback(self.deserializeSuccessResponse(decoder: T.self, data: apiResponse))
                case let .failure(error):
                    callback(.failure(.responseError(self.getErrorMessage(error: error, data: response.data))))
                }
            }
    }

    private func deserializeSuccessResponse<T: Decodable>(decoder _: T.Type, data: Data) -> Swift.Result<T, RequestError> {
        do {
            let parsedApiResponse = try JSONDecoder().decode(T.self, from: data)
            return .success(parsedApiResponse)
        } catch {
            return .failure(.decodingError(error))
        }
    }

    private func getErrorMessage(error: Error, data: Data?) -> String {
        if let data = data,
            let failure = try? JSONDecoder.shared.decode(RequestFailure.self, from: data) {
            return failure.getReason()
        }
        return error.localizedDescription
    }
}
