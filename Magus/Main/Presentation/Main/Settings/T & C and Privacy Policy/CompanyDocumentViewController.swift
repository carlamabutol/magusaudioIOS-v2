//
//  CompanyDocumentViewController.swift
//  Magus
//
//  Created by Jomz on 10/12/23.
//

import UIKit
import WebKit
import RxSwift

class CompanyDocumentViewController: CommonViewController {
    
    private let viewModel = CompanyDocumentViewModel()
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.font = .Montserrat.title1
        }
    }
    
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
            webView.backgroundColor = .clear
            webView.isOpaque = false
        }
    }
    
    func configure(docutype: CompanyDocumentViewModel.DocuType) {
        viewModel.getDocument(type: docutype)
        titleLabel.text = docutype.rawValue
    }
    
    override func setupBinding() {
        super.setupBinding()
        viewModel.documentObservable
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] document  in
                self?.webView.loadHTMLString(document, baseURL: nil)
            }
            .disposed(by: disposeBag)
    }
    
}
