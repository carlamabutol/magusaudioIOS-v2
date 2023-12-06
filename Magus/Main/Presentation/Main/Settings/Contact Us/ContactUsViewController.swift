//
//  ContactUsViewController.swift
//  Magus
//
//  Created by Jomz on 12/5/23.
//

import UIKit
import WebKit

class ContactUsViewController: CommonViewController {
    private static let contactUsURL = URL(string: "https://magusaudio.com/support")!
    
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
    
    @IBOutlet var webView: WKWebView! {
        didSet {
            let request = URLRequest(url: Self.contactUsURL)
            webView.backgroundColor = .clear
            webView.isOpaque = false
            webView.load(request)
        }
    }
}
