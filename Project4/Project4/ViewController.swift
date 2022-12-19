//
//  ViewController.swift
//  Project4
//
//  Created by Дария Григорьева on 18.12.2022.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    var webSite: String?
    
    private let webView = WKWebView()
    private let progressView = UIProgressView(progressViewStyle: .default)
    
    override func loadView() {
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadWebView()
        configureNavigationItem()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    private func configureNavigationItem() {
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        let backButton = UIBarButtonItem(title: "⬅️", style: .plain, target: webView, action: #selector(webView.goBack))
        let forwardButton = UIBarButtonItem(title: "➡️", style: .plain, target: webView, action: #selector(webView.goForward))
        toolbarItems = [progressButton, backButton, forwardButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func loadWebView() {
        guard let webSite,
              let url = URL(string: "https://" + webSite) else {
            return
        }
        
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    private func showAlert(title: URL) {
        let ac = UIAlertController(title: "Don't allow", message: "You can't go to this website \(title)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(ac, animated: true)
    }
    
    
}
extension ViewController: WKNavigationDelegate {
    
    // MARK: - WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host,
           let webSite {
            if host.contains(webSite) {
                decisionHandler(.allow)
                return
            }
        }
        decisionHandler(.cancel)
    }
    
}
