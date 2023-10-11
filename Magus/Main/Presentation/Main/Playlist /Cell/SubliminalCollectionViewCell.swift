//
//  SubliminalCollectionViewCell.swift
//  Magus
//
//  Created by Jomz on 9/10/23.
//

import UIKit
import SDWebImage
import RxSwift

class SubliminalCollectionViewCell: UICollectionViewCell {
    
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
    
    static let cellIdentifier = "SubliminalCollectionViewCell"
    
    var favoriteButtonHandler: CompletionHandler?
    
    func configure(item: SubliminalCellModel) {
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

extension SubliminalCollectionViewCell {
    
    struct SubliminalCellModel: ItemModel {
        
        
        var id: String
        var title: String
        var imageUrl: URL?
        let duration: String
        let isFavorite: Bool
        var favoriteButtonHandler: () -> Void
        var tapActionHandler: CompletionHandler?
    }
}
