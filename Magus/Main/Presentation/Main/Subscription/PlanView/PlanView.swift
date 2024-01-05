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
            coverImageView.contentMode = .scaleAspectFill
        }
    }
    
    @IBOutlet var containerView: UIView! {
        didSet {
            containerView.cornerRadius(with: 5)
        }
    }
    
    @IBOutlet var checkContainerView: UIView! {
        didSet {
            checkContainerView.backgroundColor = .white
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
    
    var tapHandler: CompletionHandler?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialisedGesture()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialisedGesture()
    }
    
    private func initialisedGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        self.addGestureRecognizer(tapGesture)
        containerView.cornerRadius(with: 5)
        checkContainerView.circle()
        checkContainerView.applyShadow(shadowOpacity: 0.2, offset: .init(width: 2, height: 2))
//        checkContainerView.layer.shouldRasterize = false
    }
    
    @objc private func tapGestureHandler() {
        tapHandler?()
    }
    
    func configure(model: PremiumViewModel.PremiumPlan) {
        titleLabel.text = model.premiumType.rawValue
        coverImageView.image = UIImage(named: model.premiumType.coverImage)
        amountLabel.text = model.amount.commaRepresentation + " PHP"
        amountLabel.textColor = model.isSelected ? .white : .black
        titleLabel.textColor = model.isSelected ? .white : .black
        containerView.backgroundColor = model.isSelected ? .Background.primaryBlue : .clear
        checkIndicator.layer.opacity = model.isSelected ? 1 : 0
        tapHandler = model.tapHandler
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        Logger.info("FRAME 111 \(frame) -- \(bounds)", topic: .presentation)
    }
    
}
