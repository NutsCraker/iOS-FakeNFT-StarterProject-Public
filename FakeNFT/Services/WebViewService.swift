
import UIKit
import WebKit
import ProgressHUD

final class WebViewService: UIViewController {
    // MARK: - Variables

    private let timeoutInterval = 5

    private var urlRequest: URLRequest

    private var observation: NSKeyValueObservation?

    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = .asset(.white)
        return webView
    }()

    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = .asset(.blue)
        progressView.trackTintColor = .asset(.lightGray)
        progressView.setProgress(0.0, animated: false)
        return progressView
    }()

    // MARK: - Conversion initializes

    init(url: String) {
        guard let url = URL(string: url) else {
            fatalError("URL failed")
        }

        urlRequest = URLRequest(url: url)
        super.init(nibName: nil, bundle: nil)
    }

    init(url: URL) {
        urlRequest = URLRequest(url: url)
        super.init(nibName: nil, bundle: nil)
    }

    init(request: URLRequest) {
        urlRequest = request
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    // MARK: - Usage view methods

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self
        webView.addSubview(progressView)
        view.addSubview(webView)

        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        observation = webView.observe(\WKWebView.estimatedProgress, options: .new) { [weak self]_, change in
            DispatchQueue.main.async { [weak self] in
                let progressValue = fabs(change.newValue ?? 0.0)
                self?.progressView.progress = Float(progressValue)

                if progressValue >= 0.0001 {
                    ProgressHUD.dismiss()
                }
            }
        }

        didLoadPage()
    }

    deinit {
        observation = nil
    }

    // MARK: - Private methods

    private func didLoadPage() {
        urlRequest.timeoutInterval = TimeInterval(timeoutInterval)
        webView.load(urlRequest)
        ProgressHUD.show()
    }

    private func setupView() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            progressView.leadingAnchor.constraint(equalTo: webView.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: webView.trailingAnchor)
        ])
    }
}

// MARK: - Extensions

extension WebViewService: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation) {
        progressView.setProgress(0.0, animated: false)
        progressView.isHidden = false
    }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
        progressView.isHidden = true
        title = webView.title
    }

    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation, withError error: Error) {
        let errorView = AlertMaker.make(
            title: "Упс! Что-то пошло не так",
            message: error.localizedDescription,
            repeatHandle: { [weak self] in
                guard let self else { return }
                self.didLoadPage()
            },
            cancelHandle: { [weak self] in
                guard let self else { return }
                self.navigationController?.popViewController(animated: true)
                ProgressHUD.dismiss()
            })

        present(errorView, animated: true)
    }
}
