import Foundation.NSURL
import Alamofire
import UIKit.UIImage

typealias PopularMovie = PopularMoviesResponse.Movie

protocol MovieDBNetworkManagerProtocol: PopularMoviesNetworkManagerProtocol, MovieDetailsNetworkManagerProtocol {}

protocol PopularMoviesNetworkManagerProtocol {
    func fetchPopularMovies(page: Int, with completion: @escaping ([PopularMovie]) -> Void)
    func getImageURL(imagePath: String) -> URL?
}

protocol MovieDetailsNetworkManagerProtocol {
    func fetchMovieDetails(movieId: String, with completion: @escaping (MovieDetailsResonse) -> Void)
    func fetchMovieCast(movieId: String, with completion: @escaping (MovieCastResponse) -> Void)
    func fetchMovieTrailerURL(movieId: String, with completion: @escaping (URL) -> Void)
    func getImageURL(imagePath: String) -> URL?
}

final class MovieDBNetworkManager: BaseNetworkManager {
    private func createPopularMoviesUrl(page: Int) -> URL? {
        createUrl(
            host: Host.movieDBApi,
            path: HTTPNetworkRoutes.popularMovie.rawValue,
            queryItems: PopularMoviesRequest(page: page).body
        )
    }

    private func createMovieImageUrl(imagePath: String) -> URL? {
        createUrl(
            host: Host.imageHost,
            path: HTTPNetworkRoutes.movieImage.rawValue + imagePath
        )
    }

    private func createMovieDetailsUrl(movieId: String) -> URL? {
        createUrl(
            host: Host.movieDBApi,
            path: HTTPNetworkRoutes.movieInfo.rawValue + movieId,
            queryItems: BaseRequest().body
        )
    }

    private func createMovieCastUrl(movieId: String) -> URL? {
        createUrl(
            host: Host.movieDBApi,
            path: String(format: HTTPNetworkRoutes.credits.rawValue, movieId),
            queryItems: BaseRequest().body
        )
    }

    private func createMovieTrailerUrl(movieId: String) -> URL? {
        createUrl(
            host: Host.movieDBApi,
            path: String(format: HTTPNetworkRoutes.videos.rawValue, movieId),
            queryItems: BaseRequest().body
        )
    }

    private func createYouTubeUrl(key: String) -> URL? {
        createUrl(
            host: .youTube,
            path: String(format: HTTPNetworkRoutes.youTubeTrailer.rawValue, key),
            queryItems: YouTubeTrailerRequest().body
        )
    }
}

// MARK: - MovieDBNetworkManagerProtocol

extension MovieDBNetworkManager: MovieDBNetworkManagerProtocol {
    func fetchPopularMovies(page: Int, with completion: @escaping ([PopularMovie]) -> Void) {
        guard let url = createPopularMoviesUrl(page: page) else { return }

        DispatchQueue.global(qos: .userInitiated).async {
            AF.request(url).responseDecodable(of: PopularMoviesResponse.self) { response in
                switch response.result {
                case .success:
                    guard let data = response.data,
                          let popularMoviesResponse = try? JSONDecoder().decode(PopularMoviesResponse.self, from: data) else {
                        return
                    }

                    DispatchQueue.main.async {
                        completion(popularMoviesResponse.results)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    func getImageURL(imagePath: String) -> URL? {
        createMovieImageUrl(imagePath: imagePath)
    }

    func fetchMovieDetails(movieId: String, with completion: @escaping (MovieDetailsResonse) -> Void) {
        guard let url = createMovieDetailsUrl(movieId: movieId) else { return }

        DispatchQueue.global(qos: .userInitiated).async {
            AF.request(url).responseDecodable(of: MovieDetailsResonse.self) { response in
                switch response.result {
                case .success:
                    guard let data = response.data,
                          let movieResponse = try? JSONDecoder().decode(MovieDetailsResonse.self, from: data) else {
                        return
                    }
                    DispatchQueue.main.async {
                        completion(movieResponse)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    func fetchMovieCast(movieId: String, with completion: @escaping (MovieCastResponse) -> Void) {
        guard let url = createMovieCastUrl(movieId: movieId) else { return }

        DispatchQueue.global(qos: .userInitiated).async {
            AF.request(url).responseDecodable(of: MovieCastResponse.self) { response in
                switch response.result {
                case .success:
                    guard let data = response.data,
                          let movieResponse = try? JSONDecoder().decode(MovieCastResponse.self, from: data) else {
                        return
                    }
                    DispatchQueue.main.async {
                        completion(movieResponse)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    func fetchMovieTrailerURL(movieId: String, with completion: @escaping (URL) -> Void) {
        guard let url = createMovieTrailerUrl(movieId: movieId) else { return }

        DispatchQueue.global(qos: .userInitiated).async {
            AF.request(url).responseDecodable(of: MovieTrailerResponse.self) { [weak self] response in
                switch response.result {
                case .success:
                    guard let data = response.data,
                          let movieResponse = try? JSONDecoder().decode(MovieTrailerResponse.self, from: data),
                          let key = movieResponse.results.first?.key,
                          let url = self?.createYouTubeUrl(key: key) else {
                        return
                    }

                    DispatchQueue.main.async {
                        completion(url)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
