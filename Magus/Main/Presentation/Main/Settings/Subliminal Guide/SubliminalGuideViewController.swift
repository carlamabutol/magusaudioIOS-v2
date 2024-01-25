//
//  SubliminalGuideViewController.swift
//  Magus
//
//  Created by Jomz on 10/12/23.
//

import UIKit
import RxSwift
import WebKit

class SubliminalGuideViewController: CommonViewController {
    private static let guide = URL(string: "https://magusaudio.com/guide")!
    
    @IBOutlet var navigationBar: ProfileNavigationBar! {
        didSet {
            navigationBar.backgroundColor = .clear
            navigationBar.configure(
                model: .init(leftButtonHandler: { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }, rightButtonModel: nil, rightButtonHandler: nil)
            )
        }
    }
    
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            let request = URLRequest(url: Self.guide)
            webView.backgroundColor = .clear
            webView.isOpaque = false
            webView.load(request)
        }
    }
    
}
