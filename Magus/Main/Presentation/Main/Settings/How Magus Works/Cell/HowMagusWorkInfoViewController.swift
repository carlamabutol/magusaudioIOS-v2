//
//  HowMagusWorkInfoViewController.swift
//  Magus
//
//  Created by Jose Mari Pascual on 10/11/23.
//

import UIKit
import SDWebImage
import WebKit

class HowMagusWorkInfoViewController: CommonViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var webView: WKWebView! {
        didSet {
            webView.backgroundColor = .clear
            webView.isOpaque = false
        }
    }
    
    func configure(with model: IPO) {
        imageView.sd_setImage(with: .init(string: model.image))
        imageView.contentMode = .scaleAspectFit
        webView.loadHTMLString(model.description, baseURL: nil)
    }
    
}
