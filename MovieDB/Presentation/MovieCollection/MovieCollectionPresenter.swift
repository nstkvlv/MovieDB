import Foundation
import UIKit.UIViewController

protocol MovieCollectionPresenterProtocol {
    var movies: [PopularMovie] { get }

    func viewDidLoad()
    func setView(_ view: MovieCollectionViewControllerProtocol)
    func getImageURL(forMovieAt index: Int) -> URL?
    func fetchNextPageMovies()
    func didSelectCell(on index: Int)
}

final class MovieCollectionPresenter: MovieCollectionPresenterProtocol {

    weak var view: MovieCollectionViewControllerProtocol?

    private let movieDBNetworkManager: PopularMoviesNetworkManagerProtocol
    private let movieDetailsViewControllerFactory: MovieDetailsViewControllerFactoryProtocol
    private var isFetchInProgress = false
    private var currentPage = 0

    var movies = [PopularMovie]()

    init(
        movieDBNetworkManager: PopularMoviesNetworkManagerProtocol,
        movieDetailsViewControllerFactory: MovieDetailsViewControllerFactoryProtocol
    ) {
        self.movieDBNetworkManager = movieDBNetworkManager
        self.movieDetailsViewControllerFactory = movieDetailsViewControllerFactory
    }
}

// MARK: - MovieCollectionPresenterProtocol

extension MovieCollectionPresenter {
    func setView(_ view: MovieCollectionViewControllerProtocol) {
        self.view = view
    }

    func viewDidLoad() {
        view?.setupCollectionView()
        view?.addLoadingSpinner()
        fetchPopularMovies()
    }

    func getImageURL(forMovieAt index: Int) -> URL? {
        movieDBNetworkManager.getImageURL(imagePath: movies[index].posterPath ?? "")
    }

    func fetchNextPageMovies() {
        guard !isFetchInProgress else { return }

        fetchPopularMovies()
    }

    func didSelectCell(on index: Int) {
        let movieDetailsViewController = movieDetailsViewControllerFactory.make(movieId: movies[index].id)
        view?.pushViewController(movieDetailsViewController)
    }
}

// MARK: - Private methods

extension MovieCollectionPresenter {
    private func fetchPopularMovies() {
        isFetchInProgress = true
        currentPage += 1
        movieDBNetworkManager.fetchPopularMovies(page: currentPage) { [weak self] movies in
            self?.isFetchInProgress = false

            guard self?.currentPage == 1 else {
                self?.movies.append(contentsOf: movies)
                self?.view?.appendNewItems()
                return
            }

            self?.movies = movies
            self?.view?.reloadData()
            self?.view?.removeLoadingSpinner()
        }
    }
}
