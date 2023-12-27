//
//  CustomWKWebView.swift
//  Magus
//
//  Created by Jose Mari Pascual on 12/12/23.
//

import UIKit
import WebKit

class CustomWKWebView: WKWebView {
    
    var scrollContentHeight: ((_ height: CGFloat) -> Void)? = nil
    
    func jomLoadHTMLString(htmlString: String, baseUrl: URL? = nil) {
        let headString = "<head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></head>"
        loadHTMLString(htmlString.appending(headString), baseURL: nil)
    }
    
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        navigationDelegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

extension CustomWKWebView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        evaluateJavaScript("document.readyState", completionHandler: { [weak self] (complete, error) in
                if complete != nil {
                    self?.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                        guard let height = height as? CGFloat else { return}
                        self?.scrollContentHeight?(height)
                    })
                }
                })
    }
}
