//
//  WebView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 5/22/23.
//

import SwiftUI
import WebKit
import LoyaltyMobileSDK

struct WebView: UIViewRepresentable {
    typealias UIViewType = WKWebView
    let url: URL
    let redirectUrlString: String
    let onDismiss: () -> Void

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.navigationDelegate = context.coordinator
        webView.configuration.userContentController.add(context.coordinator, name: "app")
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "app", let messageBody = message.body as? String {
                Logger.debug("Received message: \(messageBody)")
            }
        }
        
        func webView(_ webView: WKWebView,
                     decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url {
                Logger.debug("Redirecting URL: \(url) and expected URL: \(parent.redirectUrlString)")
                if url.absoluteString == parent.redirectUrlString {
                    // Handle the redirection: clear cookie, dismiss the WebView, show a new sheet, etc.
                    Logger.debug("Clear cookie...")
                    webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
                        for cookie in cookies {
                            webView.configuration.websiteDataStore.httpCookieStore.delete(cookie)
                        }
                    }
                    Logger.debug("Redireting...Close webview.")
                    parent.onDismiss()
                }
            }
            decisionHandler(.allow)
        }

    }
}
