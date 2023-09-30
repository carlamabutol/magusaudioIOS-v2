//
//  PlaylistCell.swift
//  Magus
//
//  Created by Jomz on 9/29/23.
//

import UIKit

class PlaylistCell: UICollectionViewCell {
    static let identifier = "PlaylistCell"
    
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.Montserrat.semibold1
        imageView.cornerRadius(with: 10)
        imageView.clipsToBounds = true
    }
    
    var tapHandler: (() -> Void)?
    
    func configure(model: Model) {
        titleLabel.setTextWithShadow(text: model.title)
        imageView.sd_setImage(with: model.imageUrl)
        imageView.contentMode = .scaleAspectFill
        tapHandler = model.tapHandler
    }
    
    struct Model {
        let imageUrl: URL?
        let title: String
        let tapHandler: () -> Void
    }
    
}

