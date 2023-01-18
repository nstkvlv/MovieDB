import Foundation.NSURL

enum Scheme: String {
    case https
}

enum Host: String {
    case movieDBApi = "api.themoviedb.org"
    case imageHost = "image.tmdb.org"
    case youTube = "www.youtube.com"
}

class BaseNetworkManager {

    var scheme: Scheme { return .https }

    var headers: [String: String] {
        return [:]
    }

    func createRequest(url: URL, with headers: [String: String]?) -> URLRequest {
        var request = URLRequest(url: url)
        if let headers = headers {
            request.allHTTPHeaderFields = headers
        }
        return request
    }

    func createUrl(host: Host, path: String, queryItems: [URLQueryItem] = []) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme.rawValue
        urlComponents.host = host.rawValue
        urlComponents.path = path
        urlComponents.queryItems = queryItems

        if urlComponents.url == nil {
            return URL(string: "")
        }

        guard let url = urlComponents.url else {
            return URL(string: "")
        }

        return URL(string: url.absoluteString)
    }
}

