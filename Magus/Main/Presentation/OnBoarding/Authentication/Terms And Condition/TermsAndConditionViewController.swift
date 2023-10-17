//
//  TermsAndConditionViewController.swift
//  Magus
//
//  Created by Jomz on 5/26/23.
//

import UIKit
import RxSwift

class TermsAndConditionViewController: CommonViewController {
    
    @IBOutlet var scrollView: UIScrollView! 
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.text = LocalisedStrings.TermsAndCondition.title
            titleLabel.numberOfLines = 2
            titleLabel.font = UIFont.Montserrat.title1
        }
    }
    
    @IBOutlet var acceptButton: FormButton! {
        didSet {
            acceptButton.setTitle(LocalisedStrings.TermsAndCondition.accept, for: .normal)
        }
    }
    @IBOutlet var descLabel: UILabel! {
        didSet {
            descLabel.numberOfLines = 0
            descLabel.font = UIFont.Montserrat.body3
            descLabel.text = LocalisedStrings.TermsAndCondition.description
        }
    }
    
    override func setupBinding() {
        acceptButton.rx.tap
            .subscribe { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }

}
