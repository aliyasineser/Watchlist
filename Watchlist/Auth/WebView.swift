//
//  WebView.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 08.11.22.
//

import SwiftUI
import WebKit

struct AuthPermissionRootView: UIViewRepresentable {

    private let viewModel: AuthPermissionViewModelProtocol

    init(viewModel: AuthPermissionViewModelProtocol) {
        self.viewModel = viewModel
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: viewModel.authPermissionURL)
        webView.load(request)
    }

    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let response = navigationResponse.response as? HTTPURLResponse,
           let headers = response.allHeaderFields as? [String: Any],
           (headers["authentication-callback"] as? String) != nil {
            viewModel.signIn()
        }
        decisionHandler(.allow)
    }
}
