import Foundation.NSURL

struct YouTubeTrailerRequest {
    var body: [URLQueryItem] {
        return [
            URLQueryItem(name: "playsinline", value: "1"),
            URLQueryItem(name: "autoplay", value: "1"),
        ]
    }
}
