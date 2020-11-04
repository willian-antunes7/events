import Foundation

class RequestFailure: Decodable {
    let errors: [String]

    private enum CodingKeys: String, CodingKey {
        case errors
    }

    required init(from decoder: Decoder) {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        let errorsDictionary = (try? container.decode([[String: String]].self, forKey: .errors)) ?? []
        errors = errorsDictionary.map { error in error["message"]! }
    }

    func getReason() -> String {
        errors.first ?? "Something went wrong"
    }
}
