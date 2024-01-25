//
//  FavoritePlaylistCell.swift
//  Magus
//
//  Created by Jose Mari Pascual on 9/23/23.
//

import UIKit
import RxSwift

class FavoritePlaylistCell: UICollectionViewCell {
    static let identifier = "FavoritePlaylistCell"
    
    let disposeBag = DisposeBag()
    
    @IBOutlet var durationLabel: UILabel! {
        didSet {
            durationLabel.font = .Montserrat.body1
        }
    }
    @IBOutlet var coverImageView: UIImageView! {
        didSet {
            coverImageView.contentMode = .scaleAspectFill
            coverImageView.cornerRadius(with: 5)
        }
    }
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.font = .Montserrat.bold15
            titleLabel.numberOfLines = 1
        }
    }
    
    @IBOutlet var favoriteButton: UIButton! {
        didSet {
            favoriteButton.setTitle("", for: .normal)
            favoriteButton.addTarget(self, action: #selector(favoriteButtonIsTapped), for: .touchUpInside)
            favoriteButton.tintColor = .black
        }
    }
    
    @IBOutlet var optionButton: UIButton! {
        didSet {
            optionButton.setTitle("", for: .normal)
            optionButton.setImage(UIImage(named: .option).withRenderingMode(.alwaysTemplate), for: .normal)
            optionButton.imageView?.contentMode = .scaleAspectFit
            optionButton.tintColor = .black
        }
    }
    @IBOutlet var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.font = .Montserrat.body1
            descriptionLabel.numberOfLines = 3
        }
    }
    
    var favoriteButtonHandler: CompletionHandler?
    
    func configure(item: FavoritePlaylistCell.Model) {
        coverImageView.sd_setImage(with: item.imageUrl)
        titleLabel.text = item.title
        durationLabel.text = item.duration
        descriptionLabel.text = item.description
        favoriteButtonHandler = item.favoriteButtonHandler
        configureFavoriteButton(isFavorite: item.isFavorite)
    }
    
    private func configureFavoriteButton(isFavorite: Bool) {
        let image = UIImage(named: isFavorite ? .favoriteIsActive : .favorite)
        let newImage = image?.resizeImage(targetHeight: 22)
        favoriteButton.setImage(newImage?.withRenderingMode(.alwaysTemplate), for: .normal)
        favoriteButton.imageView?.contentMode = .scaleAspectFit
    }
    
    @objc private func favoriteButtonIsTapped() {
        favoriteButtonHandler?()
    }
}

extension FavoritePlaylistCell {
    
    struct Model: ItemModel {
        
        var id: String
        var title: String
        var imageUrl: URL?
        let duration: String
        let description: String
        let isFavorite: Bool
        var favoriteButtonHandler: () -> Void
        var tapActionHandler: CompletionHandler?
        var optionActionHandler: CompletionHandler?
        
    }
}

