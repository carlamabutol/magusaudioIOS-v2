//
//  CompanyDocumentViewController.swift
//  Magus
//
//  Created by Jomz on 10/12/23.
//

import UIKit

class CompanyDocumentViewController: CommonViewController {
    
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
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.font = .Montserrat.title1
        }
    }
    
    @IBOutlet var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.font = .Montserrat.body3
            descriptionLabel.numberOfLines = 0
        }
    }
    
    func configure(title: String, desc: String) {
        titleLabel.text = title
        descriptionLabel.text = desc
    }
    
}
