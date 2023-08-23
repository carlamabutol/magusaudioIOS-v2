//
//  PlayerViewController.swift
//  Magus
//
//  Created by Jomz on 6/19/23.
//

import UIKit
import RxSwift
import SDWebImage
import Hero

class PlayerViewController: CommonViewController {
    
    var tabViewModel: MainTabViewModel!
    var playerViewModel: AudioPlayerViewModel!
    
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var advanceVolumeBtn: UIButton! {
        didSet {
            let image = UIImage(named: "advance volume")
            let newImage = image?.resizeImage(targetHeight: 21)
            advanceVolumeBtn.setImage(newImage, for: .normal)
            advanceVolumeBtn.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    @IBOutlet var previousButton: UIButton! {
        didSet {
            let image = UIImage(named: "previous")
            let newImage = image?.resizeImage(targetHeight: 49)
            previousButton.setImage(newImage, for: .normal)
            previousButton.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    @IBOutlet var playPauseButton: UIButton! {
        didSet {
            let image = UIImage(named: "play")
            let newImage = image?.resizeImage(targetHeight: 59)
            playPauseButton.setImage(newImage, for: .normal)
            playPauseButton.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    @IBOutlet var nextButton: UIButton! {
        didSet {
            let image = UIImage(named: "next")
            let newImage = image?.resizeImage(targetHeight: 49)
            nextButton.setImage(newImage, for: .normal)
            nextButton.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    @IBOutlet var favoriteButton: UIButton! {
        didSet {
            let image = UIImage(named: "heart")
            let newImage = image?.resizeImage(targetHeight: 21)
            favoriteButton.setImage(newImage, for: .normal)
            favoriteButton.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    @IBOutlet var titleLbl: UILabel! {
        didSet {
            titleLbl.font = .Montserrat.title3
        }
    }
    
    @IBOutlet var descriptionLbl: UILabel! {
        didSet {
            descriptionLbl.font = .Montserrat.body3
        }
    }
    @IBOutlet var progressView: UIProgressView!
    
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var coverImageView: UIImageView! {
        didSet {
            coverImageView.isHeroEnabled = true
            coverImageView.heroID = "cover"
            coverImageView.contentMode = .scaleAspectFill
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configure(subliminal: Subliminal) {
        titleLbl.text = subliminal.title
        descriptionLbl.text = subliminal.guide
        coverImageView.sd_setImage(with: .init(string: subliminal.cover))
        updatePlayerStatus()
    }
    
    override func setupBinding() {
        super.setupBinding()
        
        playPauseButton.rx.tap
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] _ in
                self?.playerViewModel.playAudio()
                self?.updatePlayerStatus()
            }
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] _ in
                self?.playerViewModel.next()
                self?.updatePlayerStatus()
            }
            .disposed(by: disposeBag)
        
        previousButton.rx.tap
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] _ in
                self?.playerViewModel.previous()
                self?.updatePlayerStatus()
            }
            .disposed(by: disposeBag)
        
        closeButton.rx.tap
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        playerViewModel.progressObservable
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: progressView.rx.progress)
            .disposed(by: disposeBag)
    }
    
    private func updatePlayerStatus() {
        guard let isPlaying: Bool = playerViewModel.activePlayer?.isPlaying else { return }
        let image = UIImage(named: isPlaying ? "pause" : "play")
        let newImage = image?.resizeImage(targetHeight: 59)
        playPauseButton.setImage(newImage, for: .normal)
        playPauseButton.imageView?.contentMode = .scaleAspectFit
    }
    
    deinit {
        print("Deinit Player View Controller")
    }
}
