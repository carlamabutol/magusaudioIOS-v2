//
//  MoodCell.swift
//  Magus
//
//  Created by Jomz on 6/13/23.
//

import UIKit
import SDWebImage

class MoodCell: UICollectionViewCell {
    
    static let identifier = "MoodCell"
    
    @IBOutlet var moodContainerView: UIView! {
        didSet {
            moodContainerView.backgroundColor = .Background.moodBackgroundColor
            moodContainerView.applyShadow(radius: 5)
            moodContainerView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectMood))
            moodContainerView.addGestureRecognizer(tapGesture)
        }
    }
    @IBOutlet var moodImageView: UIImageView!
    @IBOutlet var moodTitleLabel: UILabel!
    
    var handleSelection: (() -> Void)?
    
    func configure(model: MoodCell.Model) {
        moodImageView.sd_setImage(with: URL(string: model.image))
        moodTitleLabel.text = model.title
        handleSelection = model.handleSelection
        if model.isSelected {
            moodContainerView.backgroundColor = UIColor(hexString: model.selectedColor)
        }
    }
    
    @objc private func selectMood() {
        handleSelection?()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        moodContainerView.backgroundColor = .Background.moodBackgroundColor
    }
    
}

extension MoodCell {
    struct Model: Identifiable {
        let id: Int
        let title: String
        let image: String
        let selectedColor: String
        var isSelected: Bool
        let handleSelection: () -> Void
    }
}
