//
//  SubsViewController.swift
//  Magus
//
//  Created by Jomz on 6/19/23.
//

import UIKit
import RxSwift

class SubsViewController: CommonViewController {
    
    var tabViewModel: MainTabViewModel!
    private let viewModel = AudioPlayerViewModel()
    
    @IBOutlet var advanceVolumeBtn: UIButton! {
        didSet {
            let image = UIImage(named: "advance volume")
            let newImage = resizeImage(image: image!, targetHeight: 21)
            advanceVolumeBtn.setImage(newImage, for: .normal)
            advanceVolumeBtn.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    @IBOutlet var previousButton: UIButton! {
        didSet {
            let image = UIImage(named: "previous")
            let newImage = resizeImage(image: image!, targetHeight: 49)
            previousButton.setImage(newImage, for: .normal)
            previousButton.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    @IBOutlet var playPauseButton: UIButton! {
        didSet {
            let image = UIImage(named: "play")
            let newImage = resizeImage(image: image!, targetHeight: 59)
            playPauseButton.setImage(newImage, for: .normal)
            playPauseButton.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    @IBOutlet var nextButton: UIButton! {
        didSet {
            let image = UIImage(named: "next")
            let newImage = resizeImage(image: image!, targetHeight: 49)
            nextButton.setImage(newImage, for: .normal)
            nextButton.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    @IBOutlet var favoriteButton: UIButton! {
        didSet {
            let image = UIImage(named: "heart")
            let newImage = resizeImage(image: image!, targetHeight: 21)
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
    
    override func setupBinding() {
        super.setupBinding()
        tabViewModel.selectedSubliminalObservable
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] subliminal in
                self?.titleLbl.text = subliminal.element?.title
                self?.descriptionLbl.text = subliminal.element?.description
            }
            .disposed(by: disposeBag)
        
        tabViewModel.subliminalAudiosObservable
            .subscribe { [weak self] audioArray in
                self?.viewModel.createArrayAudioPlayer(with: audioArray)
            }
            .disposed(by: disposeBag)
        
        playPauseButton.rx.tap
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] _ in
                self?.viewModel.playAudio()
                self?.updatePlayerStatus()
            }
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] _ in
                self?.viewModel.next()
                self?.updatePlayerStatus()
            }
            .disposed(by: disposeBag)
        
        previousButton.rx.tap
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] _ in
                self?.viewModel.previous()
                self?.updatePlayerStatus()
            }
            .disposed(by: disposeBag)
        
        viewModel.progressRelay
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] progress in
                self?.progressView.progress = progress
            }
            .disposed(by: disposeBag)
    }
    
    private func updatePlayerStatus() {
        guard let isPlaying: Bool = viewModel.activePlayer?.isPlaying else { return }
        let image = UIImage(named: isPlaying ? "pause" : "play")
        let newImage = resizeImage(image: image!, targetHeight: 59)
        playPauseButton.setImage(newImage, for: .normal)
        playPauseButton.imageView?.contentMode = .scaleAspectFit
    }
    
    fileprivate func resizeImage(image: UIImage, targetHeight: CGFloat) -> UIImage {
        // Get current image size
        let size = image.size

        // Compute scaled, new size
        let heightRatio = targetHeight / size.height
        let newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Create new image
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        // Return new image
        return newImage!
    }
}
