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
    @IBOutlet var webViewHeightConstraint: NSLayoutConstraint!
    
    var webViewHeight: CGFloat = 0
    
    @IBOutlet var webView: WKWebView! {
        didSet {
            webView.backgroundColor = .clear
            webView.isOpaque = false
            webView.navigationDelegate = self
            webView.isHidden = true
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
            self.webView.isHidden = !self.webView.isHidden
            self.setCollapsedButton(isCollapsed: !self.webView.isHidden)
            self.setupWebViewHeight(isHidden: self.webView.isHidden)
        }
    }
    
    private func setupWebViewHeight(isHidden: Bool) {
        let webViewHeight: CGFloat = self.webViewHeight == 0 ? 110 : 0
        let height = isHidden ? 0 : webViewHeight
        webViewHeightConstraint.constant = height
        self.layoutIfNeeded()
    }
    
    private func setCollapsedButton(isCollapsed: Bool) {
        collapseButton.setImage(UIImage(named: isCollapsed ? .collapsedUp : .collapsedDown), for: .normal)
    }
    
    func configure(with model: Model) {
        titleLabel.text = model.title
//        descLabel.text = model.description
        webView.loadHTMLString(model.description, baseURL: nil)
    }
    
    struct Model {
        let title: String
        let description: String
    }
}

extension CollapsibleTextView: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                self.webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { [weak self](height, error) in
                    self?.webViewHeight = height as! CGFloat
                    Logger.info("web view height \(height)", topic: .presentation)
                })
            }
        })
    }
    
}
