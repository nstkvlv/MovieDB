protocol MovieDetailsPresenterProtocol {
    func viewDidLoad()
}

final class MovieDetailsPresenter: MovieDetailsPresenterProtocol {

    weak var view: MovieDetailsViewControllerProtocol?

    private let movieId: String
    private let movieDBNetworkManager: MovieDetailsNetworkManagerProtocol

    private var movie: MovieDetails?

    init(movieId: Int, movieDBNetworkManager: MovieDetailsNetworkManagerProtocol) {
        self.movieId = String(movieId)
        self.movieDBNetworkManager = movieDBNetworkManager
    }

    func viewDidLoad() {
        view?.setup()
        fetchMovieDetails()
    }
}

// MARK: - Private Methods

extension MovieDetailsPresenter {
    private func fetchMovieDetails() {
        movieDBNetworkManager.fetchMovieDetails(movieId: movieId) { [weak self] movieDetails in
            let imageUrl = self?.movieDBNetworkManager.getImageURL(imagePath: movieDetails.backdropPath ?? "")

            self?.movie = .init(
                title: movieDetails.originalTitle,
                overview: movieDetails.overview,
                imageUrl: imageUrl
            )

            guard let movie = self?.movie else { return }
            self?.view?.fillData(movie: movie)

            self?.fetchMovieCast()
            self?.fetchMovieTrailer()
        }
    }

    private func fetchMovieCast() {
        movieDBNetworkManager.fetchMovieCast(movieId: movieId) { [weak self] result in
            let arrayOfActors: [String] = result.cast.map { "\($0.name) - \($0.character)" }
            let listOfActors = arrayOfActors.joined(separator: "\n")

            self?.movie?.cast = listOfActors
            self?.view?.fillCastList(cast: listOfActors)
        }
    }

    private func fetchMovieTrailer() {
        movieDBNetworkManager.fetchMovieTrailerURL(movieId: movieId) { [weak self] url in
            self?.movie?.trailerURL = url
            self?.view?.addMovieTrailer(url: url)
        }
    }
}
