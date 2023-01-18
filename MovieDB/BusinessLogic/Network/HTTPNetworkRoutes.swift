enum HTTPNetworkRoutes: String {
    case popularMovie = "/3/movie/popular"
    case movieImage = "/t/p/w500"
    case movieInfo = "/3/movie/"
    case credits = "/3/movie/%@/credits"
    case videos = "/3/movie/%@/videos"
    case youTubeTrailer = "/embed/%@"
}
