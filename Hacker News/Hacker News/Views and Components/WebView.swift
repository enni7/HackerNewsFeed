//
//  WebView.swift
//  Hacker News
//
//  Created by Anna Izzo on 01/08/22.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    
    let urlString: String
    
    var url : URL? {
        return URL(string: urlString)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = url {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
    
    typealias UIViewType = WKWebView
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(urlString: Item.storyExample.url ?? "")
    }
}
