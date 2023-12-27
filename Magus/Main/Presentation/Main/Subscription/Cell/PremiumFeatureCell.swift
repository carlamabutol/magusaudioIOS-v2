//
//  PremiumFeatureCell.swift
//  Magus
//
//  Created by Jomz on 7/3/23.
//

import UIKit

class PremiumFeatureCell: UICollectionViewCell {
    
    static let reuseId = "PremiumFeatureCell"
    
    @IBOutlet var containerView: UIView!
    
    @IBOutlet var featureImageView: UIImageView! {
        didSet {
            featureImageView.contentMode = .scaleAspectFit
        }
    }
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.Montserrat.body3
            titleLabel.textAlignment = .center
            titleLabel.numberOfLines = 0
        }
    }
    @IBOutlet var stackView: UIStackView! {
        didSet {
            stackView.axis = .vertical
        }
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(item: PremiumViewModel.PremiumFeatures) {
        titleLabel.text = item.title
        featureImageView.image = UIImage(named: item.image)
    }
    
}
