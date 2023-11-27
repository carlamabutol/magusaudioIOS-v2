//
//  AddToPlaylistCell.swift
//  Magus
//
//  Created by Jomz on 11/15/23.
//

import UIKit

class AddToPlaylistCell: UICollectionViewCell {
    static let identifier = "AddToPlaylistCell"
    
    @IBOutlet var coverImageView: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor.Background.lightBlue
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
        subtitleLabel.font = UIFont.Montserrat.body2
        contentView.cornerRadius(with: 10)
        contentView.applyShadow(shadowOpacity: 0.2)
        coverImageView.cornerRadius(with: 10)
        coverImageView.clipsToBounds = true
    }
    
    var tapHandler: (() -> Void)?
    
    func configure(model: Model) {
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
        coverImageView.sd_setImage(with: model.imageUrl)
        coverImageView.contentMode = .scaleAspectFill
        tapHandler = model.tapHandler
    }
    
    struct Model {
        let imageUrl: URL?
        let title: String
        let subtitle: String
        let tapHandler: () -> Void
        
        init(
            imageUrl: URL?,
            title: String,
            subtitle: String,
            tapHandler: @escaping () -> Void
        ) {
            self.imageUrl = imageUrl
            self.title = title
            self.subtitle = subtitle
            self.tapHandler = tapHandler
        }
    }
    
}
