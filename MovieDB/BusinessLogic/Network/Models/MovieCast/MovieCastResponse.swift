import Foundation.NSURL

struct MovieCastResponse: Codable {
    struct Actor: Codable {
        let id: Int
        let name: String
        let character: String
    }

    let cast: [Actor]
}
