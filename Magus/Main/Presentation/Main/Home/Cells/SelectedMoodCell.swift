//
//  SelectedMoodCell.swift
//  Magus
//
//  Created by Jomz on 10/17/23.
//

import UIKit

class SelectedMoodCell: UICollectionViewCell {
    static let identifier = "SelectedMoodCell"
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.text = "Good Morning!"
            titleLabel.textColor = .TextColor.otherBlack1
            titleLabel.font = .Montserrat.title1
            titleLabel.numberOfLines = 2
        }
    }
    
    @IBOutlet var moodImageView: UIImageView! {
        didSet {
        }
    }
    
    @IBOutlet var subtitleLabel: UILabel! {
        didSet {
            subtitleLabel.font = .Montserrat.bold2
            subtitleLabel.textColor = .TextColor.otherBlack1
            subtitleLabel.numberOfLines = 2
        }
    }
    
    @IBOutlet var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.font = .Montserrat.medium10
            descriptionLabel.textColor = .TextColor.otherBlack1
            descriptionLabel.text = "Here are recommended subliminal for you to boost your mood."
            descriptionLabel.numberOfLines = 2
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialiseTap()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialiseTap()
    }
    
    var tapActionHandler: CompletionHandler?
    
    func configure(model: SelectedMoodCell.Model) {
        titleLabel.text = model.title
        subtitleLabel.text = model.subTitle
        moodImageView.image = UIImage(named: model.imageAsset)
        tapActionHandler = model.tapActionHandler
    }
    
    private func initialiseTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func tapAction() {
        tapActionHandler?()
    }
}

extension SelectedMoodCell {
    
    struct Model: ItemModel {
        
        var id: String
        var title: String
        var subTitle: String
        var imageAsset: ImageAsset
        var imageUrl: URL?
        var tapActionHandler: CompletionHandler?
    }
}
