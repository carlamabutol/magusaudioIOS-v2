//
//  PremiumViewController.swift
//  Magus
//
//  Created by Jomz on 6/19/23.
//

import UIKit

class PremiumViewController: CommonViewController {
    
    let viewModel = PremiumViewModel()
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.text = LocalizedStrings.Premium.title
            titleLabel.font = .Montserrat.title3
        }
    }
    
    @IBOutlet var subTitleLabel: UILabel! {
        didSet {
            subTitleLabel.text = LocalizedStrings.Premium.subTitle
            subTitleLabel.font = .Montserrat.body3
        }
    }
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var chooseYourPlanLabel: UILabel! {
        didSet {
            chooseYourPlanLabel.text = LocalizedStrings.Premium.chooseYourPlan
            chooseYourPlanLabel.font = .Montserrat.body3
        }
    }
    
    @IBOutlet var planStackView: UIStackView!
    
    @IBOutlet var continueButton: UIButton! {
        didSet {
            continueButton.setTitle(LocalizedStrings.Premium.continueBtn, for: .normal)
            continueButton.setTitleColor(.ButtonColor.primaryBlue, for: .normal)
            continueButton.titleLabel?.font = .Montserrat.bold1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
