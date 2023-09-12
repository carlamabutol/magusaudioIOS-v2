//
//  CollapsedPlayerView.swift
//  Magus
//
//  Created by Jomz on 8/19/23.
//

import UIKit
import SDWebImage
import Hero
import RxSwift

protocol PlayerDelegate: AnyObject {
    func playOrPauseAction()
    func favoriteAction()
    
}

class CollapsedPlayerView: ReusableXibView {
    
    @IBOutlet var subliminalImageView: UIImageView! {
        didSet {
            subliminalImageView.heroID = "cover"
        }
    }
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.font = .Montserrat.bold17
        }
    }
    
    @IBOutlet var audioProgressLabel: UILabel! {
        didSet {
            audioProgressLabel.font = .Montserrat.body2
        }
    }
    
    @IBOutlet var favoriteButton: UIButton! {
        didSet {
            favoriteButton.isHeroEnabled = false
        }
    }
    
    @IBOutlet var playPauseButton: UIButton! {
        didSet {
            favoriteButton.isHeroEnabled = false
            updateFavorite(isLiked: false)
        }
    }
    
    @IBOutlet var progressView: UIProgressView!
    
    func configure(subliminal: Subliminal) {
        isHidden = false
        titleLabel.text = subliminal.title
        subliminalImageView.sd_setImage(with: .init(string: subliminal.cover), placeholderImage: .init(named: "Cover Image"))
        updateFavorite(isLiked: subliminal.isLiked == 1)
    }
    
    func configureProgress(progress: Float) {
        progressView.progress = progress
    }
    
    func configureTime(time: String) {
        audioProgressLabel.text = time
    }
    
    func updatePlayerStatus(status: PlayerStatus) {
        let image = UIImage(named: status == .isPlaying ? "pause" : "play")
        let newImage = image?.resizeImage(targetHeight: 59)
        playPauseButton.setImage(newImage, for: .normal)
        playPauseButton.imageView?.contentMode = .scaleAspectFit
    }
    
    func updateFavorite(isLiked: Bool) {
        let image = UIImage(named: isLiked ? "active heart" : "heart")
        let newImage = image?.resizeImage(targetHeight: 21)
        favoriteButton.setImage(newImage, for: .normal)
        favoriteButton.imageView?.contentMode = .scaleAspectFit
    }
    
    
}
