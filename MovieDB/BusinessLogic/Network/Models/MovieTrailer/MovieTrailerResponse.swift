struct MovieTrailerResponse: Codable {
    struct MovieVideo: Codable {
        let key: String
    }

    let results: [MovieVideo]
}
