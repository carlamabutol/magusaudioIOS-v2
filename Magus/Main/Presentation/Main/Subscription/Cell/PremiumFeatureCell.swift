//
//  PremiumFeatureCell.swift
//  Magus
//
//  Created by Jomz on 7/3/23.
//

import UIKit
import WebKit

class PremiumFeatureCell: UICollectionViewCell {
    
    static let reuseId = "PremiumFeatureCell"
    
    @IBOutlet var containerView: UIView!
    
    @IBOutlet var featureImageView: UIImageView! {
        didSet {
            featureImageView.contentMode = .scaleAspectFit
        }
    }
    
    @IBOutlet var webView: CustomWKWebView! {
        didSet {
            webView.backgroundColor = .clear
            webView.isOpaque = false
            webView.navigationDelegate = self
        }
    }
    
    
    @IBOutlet var stackView: UIStackView! {
        didSet {
            stackView.axis = .vertical
        }
    }
    
    var didLoadScrollHeight: ((_ scrollHeight: CGFloat) -> Void)?

    
    func configure(item: PremiumViewModel.PremiumFeatures) {
        featureImageView.sd_setImage(with: .init(string: item.image))
        didLoadScrollHeight = item.webViewHeight
        webView.jomLoadHTMLString(htmlString: item.title, baseUrl: nil)
    }
    
}

extension PremiumFeatureCell: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.readyState", completionHandler: { [weak self] (complete, error) in
            if complete != nil {
                webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                    guard let height = height as? CGFloat else { return}
                    self?.didLoadScrollHeight?(height)
                })
            }
        })
    }
}
