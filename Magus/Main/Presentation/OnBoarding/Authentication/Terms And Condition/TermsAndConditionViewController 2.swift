//
//  TermsAndConditionViewController.swift
//  Magus
//
//  Created by Jomz on 5/26/23.
//

import UIKit
import RxSwift

class TermsAndConditionViewController: CommonViewController {
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.text = LocalizedStrings.TermsAndCondition.title
            titleLabel.numberOfLines = 2
            titleLabel.font = UIFont.Montserrat.title1
        }
    }
    
    @IBOutlet var acceptButton: FormButton! {
        didSet {
            acceptButton.setTitle(LocalizedStrings.TermsAndCondition.accept, for: .normal)
        }
    }
    @IBOutlet var descLabel: UILabel! {
        didSet {
            descLabel.numberOfLines = 0
            descLabel.font = UIFont.Montserrat.body3
            descLabel.text = LocalizedStrings.TermsAndCondition.description
            descLabel.setLineSpacing(lineSpacing: 24)
            descLabel.backgroundColor = .clear
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setupBinding() {
        acceptButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
