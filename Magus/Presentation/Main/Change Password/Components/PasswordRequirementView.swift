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
    
    func configure(text: String) {
        titleLabel.text = text
    }
    
    func isCheckRequirements(_ isCheck: Bool) {
        stateButton.image = UIImage(named: isCheck ? .check : .cross)
    }
    
}
