import UIKit
import Kingfisher
import WebKit

protocol MovieDetailsViewControllerProtocol: AnyObject {
    func setup()
    func fillData(movie: MovieDetails)
    func fillCastList(cast: String?)
    func addMovieTrailer(url: URL)
}

final class MovieDetailsViewController: UIViewController {
    var presenter: MovieDetailsPresenterProtocol?

    private lazy var spinner = UIActivityIndicatorView(style: .large)
    private lazy var imageView = UIImageView()
    private lazy var titleLabel = UILabel()
    private lazy var overviewLabel = UILabel()
    private lazy var castTextView = UITextView()
    private lazy var webViewLoadingLabel = UILabel()

    private var webView: WKWebView?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
}

// MARK: - MovieDetailsViewControllerProtocol

extension MovieDetailsViewController: MovieDetailsViewControllerProtocol {
    func setup() {
        view.backgroundColor = .white

        let scrollView = setupScrollView()

        let webViewContainerView = setupWebViewContainer()
    
        let mainStackView = setupMainStackView(
            arrangedSubviews: [imageView, titleLabel, overviewLabel, webViewContainerView, castTextView],
            scrollView: scrollView
        )

        setupImageView(mainStackView: mainStackView)
        setupTitleLabel(mainStackView: mainStackView)
        setupOverviewLabel(mainStackView: mainStackView)
        setupCastTextView(mainStackView: mainStackView)

        addLoadingSpinner()
    }

    func fillData(movie: MovieDetails) {
        imageView.kf.setImage(with: movie.imageUrl) { [weak self] result in
            if case .success = result {
                self?.removeLoadingSpinner()
                self?.titleLabel.text = movie.title
                self?.overviewLabel.text = movie.overview
                self?.fillCastList(cast: movie.cast)
                self?.webViewLoadingLabel.text = "Trailer is loading..."
            }
        }
    }

    func fillCastList(cast: String?) {
        castTextView.text = cast ?? "Cast List is loading..."
    }

    func addMovieTrailer(url: URL) {
        let request = URLRequest(url: url)
        webView?.load(request)
        webView?.isHidden = false
        webViewLoadingLabel.removeFromSuperview()
    }
}

// MARK: - Private Methods

extension MovieDetailsViewController {
    private func setupScrollView() -> UIScrollView {
        let scrollView = UIScrollView(frame: view.bounds)

        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true

        return scrollView
    }

    private func setupWebViewContainer() -> UIView {
        let webViewContainerView = UIView()

        webViewLoadingLabel.font = .systemFont(ofSize: 18, weight: .medium)
        webViewLoadingLabel.textAlignment = .center

        webViewContainerView.addSubview(webViewLoadingLabel)
        webViewLoadingLabel.translatesAutoresizingMaskIntoConstraints = false
        webViewLoadingLabel.centerXAnchor.constraint(equalTo: webViewContainerView.centerXAnchor).isActive = true
        webViewLoadingLabel.centerYAnchor.constraint(equalTo: webViewContainerView.centerYAnchor).isActive = true

        let webViewConfig = WKWebViewConfiguration()
        webViewConfig.allowsInlineMediaPlayback = true

        webView = WKWebView(frame: view.bounds, configuration: webViewConfig)

        guard let webView = webView else { return UIView() }
        webView.isHidden = true

        webViewContainerView.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: webViewContainerView.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: webViewContainerView.bottomAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: webViewContainerView.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: webViewContainerView.trailingAnchor).isActive = true

        webViewContainerView.heightAnchor.constraint(equalToConstant: 200).isActive = true

        return webViewContainerView
    }

    private func setupMainStackView(arrangedSubviews: [UIView], scrollView: UIScrollView) -> UIStackView {
        let mainStackView = UIStackView(arrangedSubviews: arrangedSubviews)
        mainStackView.axis = .vertical
        mainStackView.contentMode = .center
        mainStackView.spacing = 15

        let scrollContentGuide = scrollView.contentLayoutGuide
        let scrollFrameGuide = scrollView.frameLayoutGuide

        scrollView.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.leadingAnchor.constraint(equalTo: scrollContentGuide.leadingAnchor).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: scrollContentGuide.trailingAnchor).isActive = true
        mainStackView.topAnchor.constraint (equalTo: scrollContentGuide.topAnchor).isActive = true
        mainStackView.bottomAnchor.constraint (equalTo: scrollContentGuide.bottomAnchor).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: scrollFrameGuide.leadingAnchor).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: scrollFrameGuide.trailingAnchor).isActive = true

        return mainStackView
    }

    private func setupCastTextView(mainStackView: UIStackView) {
        castTextView.font = .systemFont(ofSize: 15)
        castTextView.isScrollEnabled = false
        castTextView.isEditable = false

        castTextView.translatesAutoresizingMaskIntoConstraints = false
        castTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 300).isActive = true
    }

    private func setupOverviewLabel(mainStackView: UIStackView) {
        overviewLabel.numberOfLines = 0
        overviewLabel.textAlignment = .justified
        overviewLabel.font = .systemFont(ofSize: 20)

        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 10).isActive = true
        overviewLabel.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -10).isActive = true
    }


    private func setupTitleLabel(mainStackView: UIStackView) {
        titleLabel.font = .systemFont(ofSize: 25, weight: .bold)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
    }

    private func setupImageView(mainStackView: UIStackView) {
        imageView.contentMode = .scaleToFill

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor).isActive = true
    }

    private func addLoadingSpinner() {
        spinner.hidesWhenStopped = true
        spinner.startAnimating()

        view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    private func removeLoadingSpinner() {
        spinner.stopAnimating()
        spinner.removeFromSuperview()
    }
}
