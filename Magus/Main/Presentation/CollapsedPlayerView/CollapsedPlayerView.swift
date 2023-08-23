//
//  CollapsedPlayerView.swift
//  Magus
//
//  Created by Jomz on 8/19/23.
//

import UIKit
import SDWebImage
import Hero

class CollapsedPlayerView: ReusableXibView {
    
    @IBOutlet var subliminalImageView: UIImageView! {
        didSet {
            subliminalImageView.heroID = "cover"
        }
    }
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var audioProgressLabel: UILabel!
    
    @IBOutlet var favoriteButton: UIButton! {
        didSet {
            favoriteButton.isHeroEnabled = false
        }
    }
    
    @IBOutlet var playPauseButton: UIButton! {
        didSet {
            favoriteButton.isHeroEnabled = false
        }
    }
    
    @IBOutlet var progressView: UIProgressView!
    
    func configure(title: String, image: String) {
        titleLabel.text = title
        subliminalImageView.sd_setImage(with: .init(string: image))
    }
    
    func updatePlayerStatus(isPlaying: Bool) {
        let image = UIImage(named: isPlaying ? "pause" : "play")
        let newImage = image?.resizeImage(targetHeight: 59)
        playPauseButton.setImage(newImage, for: .normal)
        playPauseButton.imageView?.contentMode = .scaleAspectFit
    }
    
}
