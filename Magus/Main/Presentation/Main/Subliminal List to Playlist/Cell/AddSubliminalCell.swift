//
//  AddSubliminalCell.swift
//  Magus
//
//  Created by Jomz on 11/25/23.
//

import UIKit

class AddSubliminalCell: UICollectionViewCell {

    static let identifier = "AddSubliminalCell"
    
    @IBOutlet var imageView: UIImageView! {
        didSet {
            imageView.roundCorners(corners: .allCorners, radius: 5)
        }
    }
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var statusIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .clear
        styleView()
        initializeGesture()
    }
    
    private func initializeGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func tapAction() {
        tapHandler?()
    }
    
    private func styleView() {
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.Montserrat.semibold15
    }
    
    var tapHandler: (() -> Void)?
    
    func configure(model: Model) {
        titleLabel.text = model.title
        imageView.sd_setImage(with: model.imageUrl)
        imageView.contentMode = .scaleAspectFill
        statusIcon.image = UIImage(named: model.actionImage)
        tapHandler = model.tapHandler
    }
    
    struct Model {
        let imageUrl: URL?
        let title: String
        let actionImage: ImageAsset
        let tapHandler: () -> Void
        
        init(
            imageUrl: URL?,
            title: String,
            actionImage: ImageAsset,
            tapHandler: @escaping () -> Void
        ) {
            self.imageUrl = imageUrl
            self.title = title
            self.actionImage = actionImage
            self.tapHandler = tapHandler
        }
    }
}
