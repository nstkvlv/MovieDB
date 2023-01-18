struct PopularMoviesResponse: Decodable {
    struct Movie: Decodable {
        let id: Int
        let posterPath: String?
        let voteAverage: Double

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case posterPath = "poster_path"
            case voteAverage = "vote_average"
        }
    }

    let results: [Movie]
}
