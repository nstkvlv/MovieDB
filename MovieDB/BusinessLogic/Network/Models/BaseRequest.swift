import Foundation.NSURL

struct BaseRequest {
    private let apiKey = Tokens.apiKey

    var body: [URLQueryItem] {
        return [URLQueryItem(name: "api_key", value: apiKey)]
    }
}
