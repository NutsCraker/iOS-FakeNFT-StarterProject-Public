//
//  WebsiteViewController.swift
//  FakeNFT
//
//  Created by Andrei Kashin on 24.07.2023.
//

import UIKit
import WebKit

final class WebsiteViewController: UIViewController, WKUIDelegate {
    
    // MARK: - Properties
    private var webView: WKWebView?
    private var websiteURL: String?
    
    // MARK: - Lifecycle
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView?.uiDelegate = self
        view = webView
    }
    
    init(webView: WKWebView?, websiteURL: String?) {
        self.webView = webView
        self.websiteURL = websiteURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let websiteURL = websiteURL,
              let myURL = URL(string: websiteURL) else { return }
        let myRequest = URLRequest(url: myURL)
        webView?.load(myRequest)
    }
}

