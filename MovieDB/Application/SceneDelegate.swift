import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let movieCollectionViewControllerFactory = setupMovieCollectionViewControllerFactory()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = UINavigationController(rootViewController: movieCollectionViewControllerFactory.make())
        window?.makeKeyAndVisible()
    }
}

// MARK: - Private Methods

extension SceneDelegate {
    private func setupMovieCollectionViewControllerFactory() -> MovieCollectionViewControllerFactoryProtocol {
        let movieDBNetworkManager = MovieDBNetworkManager()

        let factory = MovieCollectionViewControllerFactory(
            movieDBNetworkManager: movieDBNetworkManager,
            movieDetailsViewControllerFactory: MovieDetailsViewControllerFactory(movieDBNetworkManager: movieDBNetworkManager)
        )

        return factory
    }
}
