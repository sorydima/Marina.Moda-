//
//  ContentView.swift
//  MarinaModaPWAWeb
//
//  Created by Dmitry Sorokin
//

import SwiftUI
import WebKit

struct ContentView: View {
    let urlString: String = "https://marina.rechain.network/"
    
    var body: some View {
        WebView(url: URL(string: urlString)!)
    }
}

struct WebView: UIViewRepresentable {
    var url: URL
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator // Set the navigation delegate
        webView.configuration.allowsInlineMediaPlayback = true
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

        // Handle navigation actions
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url,
               navigationAction.navigationType == .linkActivated {
                // Check if the link is internal or external
                if isInternalLink(url) {
                    // Open internal links in the web-view
                    decisionHandler(.allow)
                } else {
                    // Open external links in Safari
                    UIApplication.shared.open(url)
                    decisionHandler(.cancel)
                }
            } else {
                decisionHandler(.allow)
            }
        }

        // Check if the link is internal (belonging to the same host as the original URL)
        private func isInternalLink(_ url: URL) -> Bool {
            return url.host == parent.url.host
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
