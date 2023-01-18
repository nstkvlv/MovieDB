protocol MovieCollectionViewControllerFactoryProtocol {
    func make() -> MovieCollectionViewController
}

final class MovieCollectionViewControllerFactory: MovieCollectionViewControllerFactoryProtocol {
    private let movieDBNetworkManager: PopularMoviesNetworkManagerProtocol
    private let movieDetailsViewControllerFactory: MovieDetailsViewControllerFactoryProtocol

    init(
        movieDBNetworkManager: PopularMoviesNetworkManagerProtocol,
        movieDetailsViewControllerFactory: MovieDetailsViewControllerFactoryProtocol
    ) {
        self.movieDBNetworkManager = movieDBNetworkManager
        self.movieDetailsViewControllerFactory = movieDetailsViewControllerFactory
    }

    func make() -> MovieCollectionViewController {
        let movieCollectionPresenter = MovieCollectionPresenter(
            movieDBNetworkManager: movieDBNetworkManager,
            movieDetailsViewControllerFactory: movieDetailsViewControllerFactory
        )
        let movieCollectionViewController = MovieCollectionViewController()

        movieCollectionViewController.presenter = movieCollectionPresenter
        movieCollectionPresenter.view = movieCollectionViewController

        return movieCollectionViewController
    }
}
