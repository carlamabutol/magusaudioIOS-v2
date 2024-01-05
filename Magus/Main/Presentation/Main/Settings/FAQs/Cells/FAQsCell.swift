//
//  FAQsCell.swift
//  Magus
//
//  Created by Jomz on 12/11/23.
//

import UIKit
import WebKit

class FAQsCell: UICollectionViewCell {
    
    static let identifier = "FAQsCell"
    
    @IBOutlet var webView: CustomWKWebView! {
        didSet {
            webView.backgroundColor = .clear
            webView.isOpaque = false
            webView.navigationDelegate = self
        }
    }
    
    var didLoadScrollHeight: ((_ scrollHeight: CGFloat) -> Void)?
    
    func configure(model: SettingsViewModel.FAQsModel) {
        didLoadScrollHeight = model.didLoadScrollHeight
        webView.jomLoadHTMLString(htmlString: model.description, baseUrl: nil)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = .white
        contentView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
    }
    
}

extension FAQsCell: WKNavigationDelegate {
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
