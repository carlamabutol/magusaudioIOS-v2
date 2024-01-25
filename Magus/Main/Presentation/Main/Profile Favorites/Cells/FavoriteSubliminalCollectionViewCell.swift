//
//  FavoriteSubliminalCollectionViewCell.swift
//  Magus
//
//  Created by Jose Mari Pascual on 9/23/23.
//

import UIKit
import RxSwift

class FavoriteSubliminalCollectionViewCell: UICollectionViewCell {
    static let identifier = "FavoriteSubliminalCollectionViewCell"
    
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
            optionButton.addTarget(self, action: #selector(optionButtonIsTapped), for: .touchUpInside)
        }
    }
    
    var favoriteButtonHandler: CompletionHandler?
    var optionButtonHandler: CompletionHandler?
    
    func configure(item: FavoriteSubliminalCollectionViewCell.SubliminalCellModel) {
        coverImageView.sd_setImage(with: item.imageUrl)
        titleLabel.text = item.title
        durationLabel.text = item.duration
        favoriteButtonHandler = item.favoriteButtonHandler
        optionButtonHandler = item.optionActionHandler
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
    
    @objc private func optionButtonIsTapped() {
        optionButtonHandler?()
    }
}

extension FavoriteSubliminalCollectionViewCell {
    
    struct SubliminalCellModel: ItemModel {
        
        var id: String
        var title: String
        var imageUrl: URL?
        let duration: String
        let isFavorite: Bool
        var favoriteButtonHandler: () -> Void
        var tapActionHandler: CompletionHandler?
        var optionActionHandler: CompletionHandler?
        
    }
}
