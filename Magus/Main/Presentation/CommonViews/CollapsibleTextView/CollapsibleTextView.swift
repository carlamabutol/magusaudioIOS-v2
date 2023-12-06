//
//  CollapsibleTextView.swift
//  Magus
//
//  Created by Jomz on 10/12/23.
//

import UIKit
import RxSwift
import WebKit

class CollapsibleTextView: ReusableXibView {
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.font = .Montserrat.medium2
            titleLabel.numberOfLines = 2
        }
    }
    
    @IBOutlet var descLabel: UILabel! {
        didSet {
            descLabel.font = .Montserrat.body3
            descLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet var collapsedView: UIView! {
        didSet {
            collapsedView.isUserInteractionEnabled = true
        }
    }
    
    @IBOutlet var collapseButton: UIButton! {
        didSet {
            collapseButton.isUserInteractionEnabled = true
            collapseButton.setImage(UIImage(named: .collapsedDown), for: .normal)
        }
    }
    
    @IBOutlet var webView: WKWebView! {
        didSet {
            webView.backgroundColor = .clear
            webView.isOpaque = false
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        initialise()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        initialise()
    }
    
    private func setupViews() {
        cornerRadius(with: 5)
        applyShadow(radius: 1, offset: .init(width: 0, height: 1.5))
    }
    
    private func initialise() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func tapAction() {
        UIView.animate(withDuration: 0.2) {
            self.descLabel.isHidden = !self.descLabel.isHidden
            self.webView.isHidden = !self.webView.isHidden
            self.setCollapsedButton(isCollapsed: !self.descLabel.isHidden)
            self.layoutIfNeeded()
        }
    }
    
    private func setCollapsedButton(isCollapsed: Bool) {
        collapseButton.setImage(UIImage(named: isCollapsed ? .collapsedUp : .collapsedDown), for: .normal)
    }
    
    func configure(with model: Model) {
        titleLabel.text = model.title
        descLabel.text = model.description
    }
    
    struct Model {
        let title: String
        let description: String
    }
}
