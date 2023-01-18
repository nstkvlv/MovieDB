protocol MovieDetailsViewControllerFactoryProtocol {
    func make(movieId: Int) -> MovieDetailsViewController
}

final class MovieDetailsViewControllerFactory: MovieDetailsViewControllerFactoryProtocol {
    private let movieDBNetworkManager: MovieDetailsNetworkManagerProtocol

    init(movieDBNetworkManager: MovieDetailsNetworkManagerProtocol) {
        self.movieDBNetworkManager = movieDBNetworkManager
    }

    func make(movieId: Int) -> MovieDetailsViewController {
        let movieDetailsViewController = MovieDetailsViewController()
        let movieDetailsPresenter = MovieDetailsPresenter(
            movieId: movieId,
            movieDBNetworkManager: MovieDBNetworkManager()
        )
        movieDetailsViewController.presenter = movieDetailsPresenter
        movieDetailsPresenter.view = movieDetailsViewController

        return movieDetailsViewController
    }
}
