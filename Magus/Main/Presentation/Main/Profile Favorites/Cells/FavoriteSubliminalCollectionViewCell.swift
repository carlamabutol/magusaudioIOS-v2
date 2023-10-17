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
            titleLabel.numberOfLines = 2
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
    
    var favoriteButtonHandler: CompletionHandler?
    
    func configure(item: SubliminalCollectionViewCell.SubliminalCellModel) {
        coverImageView.sd_setImage(with: item.imageUrl)
        titleLabel.text = item.title
        durationLabel.text = item.duration
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
