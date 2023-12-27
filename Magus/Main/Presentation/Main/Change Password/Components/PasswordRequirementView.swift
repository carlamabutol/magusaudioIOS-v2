//
//  PasswordRequirementView.swift
//  Magus
//
//  Created by Jomz on 8/7/23.
//

import UIKit

class PasswordRequirementView: ReusableXibView {
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.font = .Montserrat.medium1
            titleLabel.numberOfLines = 2
        }
    }
    
    @IBOutlet var stateButton: UIImageView!
    
    func configure(model: ChangePasswordViewModel.PasswordRequirementModel) {
        titleLabel.text = model.text
        stateButton.image = UIImage(named: model.imageName)
    }
    
}
