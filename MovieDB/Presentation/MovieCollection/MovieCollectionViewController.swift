import UIKit

protocol MovieCollectionViewControllerProtocol: AnyObject {
    func setupCollectionView()
    func reloadData()
    func addLoadingSpinner()
    func removeLoadingSpinner()
    func appendNewItems()
    func pushViewController(_ viewController: UIViewController)
}

final class MovieCollectionViewController: UIViewController {

    var presenter: MovieCollectionPresenterProtocol?

    private lazy var spinner = UIActivityIndicatorView(style: .large)
    private var collectionView: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movies"
        presenter?.viewDidLoad()
    }
}

// MARK: - GalleryCollectionViewProtocol

extension MovieCollectionViewController: MovieCollectionViewControllerProtocol {
    func addLoadingSpinner() {
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    func removeLoadingSpinner() {
        spinner.stopAnimating()
        spinner.removeFromSuperview()
    }

    func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.itemSize = CGSize(width: view.frame.width / 2 - 10, height: 300)

        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)

        guard let collectionView = collectionView else { return }

        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(
            MovieCell.self,
            forCellWithReuseIdentifier: String(describing: MovieCell.self)
        )

        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    func reloadData() {
        collectionView?.reloadData()
    }

    func appendNewItems() {
        collectionView?.performBatchUpdates({
            let array = Array((presenter?.movies.count ?? 0) - 21 ... (presenter?.movies.count ?? 0) - 1)
            let indexPathes: [IndexPath] = array.map { IndexPath(item: $0, section: 0) }
            collectionView?.insertItems(at: indexPathes)
        })
    }

    func pushViewController(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension MovieCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.movies.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MovieCell.self), for: indexPath) as? MovieCell else {
            return UICollectionViewCell()
        }

        cell.fillData(
            imageURL: presenter?.getImageURL(forMovieAt: indexPath.item),
            rating: String(presenter?.movies[indexPath.item].voteAverage ?? 0.0)
        )
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == (presenter?.movies.count ?? 0) - 5 {
            presenter?.fetchNextPageMovies()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.didSelectCell(on: indexPath.item)
    }
}
