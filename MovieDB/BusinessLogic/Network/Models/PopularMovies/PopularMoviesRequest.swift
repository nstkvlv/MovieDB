import Foundation.NSURL

struct PopularMoviesRequest {
    private var apiKey = Tokens.apiKey
    private let language = "en-US"
    private let page: Int

    var body: [URLQueryItem] {
        return [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "language", value: language),
            URLQueryItem(name: "page", value: "\(page)")
        ]
    }

    init(page: Int) {
        self.page = page
    }
}
