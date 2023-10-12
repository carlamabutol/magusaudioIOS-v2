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
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction))
        longGesture.minimumPressDuration = 1.5
        addGestureRecognizer(longGesture)
    }
    
    @objc private func tapAction() {
        tapHandler?()
    }
    
    @objc private func longPressAction() {
        editHandler?()
    }
    
    private func styleView() {
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.Montserrat.semibold1
        imageView.cornerRadius(with: 10)
        imageView.clipsToBounds = true
    }
    
    var tapHandler: (() -> Void)?
    var editHandler: (() -> Void)?
    
    func configure(model: Model) {
        titleLabel.setTextWithShadow(text: model.title)
        imageView.sd_setImage(with: model.imageUrl)
        imageView.contentMode = .scaleAspectFill
        tapHandler = model.tapHandler
        editHandler = model.editHandler
    }
    
    struct Model {
        let imageUrl: URL?
        let title: String
        let tapHandler: () -> Void
        let editHandler: (() -> Void)?
        
        init(
            imageUrl: URL?,
            title: String,
            tapHandler: @escaping () -> Void,
            editHandler: (() -> Void)? = nil
        ) {
            self.imageUrl = imageUrl
            self.title = title
            self.tapHandler = tapHandler
            self.editHandler = editHandler
        }
    }
    
}

