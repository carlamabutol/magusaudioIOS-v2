//
//  TermsAndConditionViewController.swift
//  Magus
//
//  Created by Jomz on 5/26/23.
//

import UIKit

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
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
