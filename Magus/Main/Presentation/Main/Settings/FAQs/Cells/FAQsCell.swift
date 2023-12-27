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
        }
    }
    
    func configure(model: SettingsViewModel.FAQsModel) {
        webView.scrollContentHeight = { height in
            model.didLoadScrollHeight?(height)
        }
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
