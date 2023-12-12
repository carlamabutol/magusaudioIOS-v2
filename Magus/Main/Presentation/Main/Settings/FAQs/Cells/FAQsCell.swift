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
    
    @IBOutlet var webView: WKWebView! {
        didSet {
            webView.backgroundColor = .clear
            webView.isOpaque = false
        }
    }
    
    func configure(description: String) {
        webView.loadHTMLString(description, baseURL: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = .white
        contentView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
    }
    
}
