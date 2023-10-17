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
            containerView.cornerRadius(with: 5)
        }
    }
    
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var checkContainerView: UIView! {
        didSet {
            checkContainerView.backgroundColor = .white
            checkContainerView.circle()
            checkContainerView.applyShadow(shadowOpacity: 0.2, offset: .init(width: 2, height: 2))
            checkContainerView.layer.shouldRasterize = false
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
    @IBOutlet var checkIndicator: UIImageView!
    
    func configure(model: PremiumViewModel.PremiumPlan) {
        titleLabel.text = model.premiumType.rawValue
//        coverImageView.image = UIImage(named: model.premiumType.coverImage)
        amountLabel.text = model.amount.commaRepresentation + "PHP"
        containerView.backgroundColor = model.isSelected ? .Background.primary : .clear
        checkIndicator.isHidden = !model.isSelected
    }
    
    
}
