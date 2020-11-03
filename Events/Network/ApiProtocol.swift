import Foundation

protocol ApiClientProtocol {
    func request<T: Decodable>(_ route: ApiRouter, _ callback: @escaping ((Result<T, RequestError>) -> Void))
}
