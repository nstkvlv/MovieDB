struct MovieDetailsResonse: Codable {
    let id: Int
    let backdropPath: String?
    let overview: String
    let originalTitle: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case backdropPath = "backdrop_path"
        case overview = "overview"
        case originalTitle = "original_title"
    }
}
