//
//  PlanView.swift
//  Magus
//
//  Created by Jomz on 7/11/23.
//

import UIKit

class PlanView: ReusableXibView {
    
    @IBOutlet var coverImageView: UIImageView! {
        didSet {
            
        }
    }
    
    @IBOutlet var containerView: UIView! {
        didSet {
            containerView.backgroundColor = .Background.primary
            containerView.cornerRadius(with: 5)
        }
    }
    
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var checkContainerView: UIView! {
        didSet {
            checkContainerView.backgroundColor = .white
            checkContainerView.circle()
        }
    }
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.font = .Montserrat.body1
        }
    }
    @IBOutlet var amountLabel: UILabel! {
        didSet {
            amountLabel.font = .Montserrat.body1
        }
    }
    
    
}
