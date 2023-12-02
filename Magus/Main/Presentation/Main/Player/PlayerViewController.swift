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

class PlayerViewController: BlurCommonViewController {
    
    var tabViewModel: MainTabViewModel!
    var audioPlayerViewModel: AudioPlayerViewModel!
    var volumeDisposeBag = DisposeBag()
    
    @IBOutlet var gradientView: UIView!
    
    @IBOutlet var advanceVolumeBtn: UIButton! {
        didSet {
            let image = UIImage(named: .advanceVolume)
            let newImage = image?.resizeImage(targetHeight: 21)
            advanceVolumeBtn.setImage(newImage, for: .normal)
            advanceVolumeBtn.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    @IBOutlet var previousButton: UIButton! {
        didSet {
            let image = UIImage(named: .previous)
            let newImage = image?.resizeImage(targetHeight: 49)
            previousButton.setImage(newImage, for: .normal)
            previousButton.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    @IBOutlet var playPauseButton: UIButton! {
        didSet {
            let image = UIImage(named: .play)
            let newImage = image?.resizeImage(targetHeight: 59)
            playPauseButton.setImage(newImage, for: .normal)
            playPauseButton.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    @IBOutlet var nextButton: UIButton! {
        didSet {
            let image = UIImage(named: .next)
            let newImage = image?.resizeImage(targetHeight: 49)
            nextButton.setImage(newImage, for: .normal)
            nextButton.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    @IBOutlet var favoriteButton: UIButton! {
        didSet {
            let image = UIImage(named: .favorite)
            let newImage = image?.resizeImage(targetHeight: 21)
            favoriteButton.setImage(newImage, for: .normal)
            favoriteButton.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    @IBOutlet var titleLbl: UILabel! {
        didSet {
            titleLbl.font = .Montserrat.title3
            titleLbl.numberOfLines = 2
        }
    }
    
    @IBOutlet var descriptionLbl: UILabel! {
        didSet {
            descriptionLbl.font = .Montserrat.body3
        }
    }
    @IBOutlet var progressView: UIProgressView! {
        didSet {
            progressView.progress = 0
        }
    }
    
    @IBOutlet var timeLabel: UILabel! {
        didSet {
            timeLabel.font = .Montserrat.body1
            timeLabel.text = ""
        }
    }
    
    @IBOutlet var coverImageView: UIImageView! {
        didSet {
            coverImageView.isHeroEnabled = true
            coverImageView.heroID = "cover"
            coverImageView.contentMode = .scaleAspectFill
        }
    }
    
    @IBOutlet var scrollView: ScrollViewWithPanGesture! {
        didSet {
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
            scrollView.addGestureRecognizer(panGesture)
        }
    }
    
    @IBOutlet var optionStackView: UIStackView!
    
    @IBOutlet var optionButton: UIButton!
    @IBOutlet var repeatView: UIButton! {
        didSet {
            repeatView.setTitle("", for: .normal)
            repeatView.setImage(UIImage(named: .repeatAll).withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    @IBOutlet var closeButton: UIButton! {
        didSet {
            closeButton.setTitle("", for: .normal)
        }
    }
    
    @IBOutlet var tracksTitleLabel: UILabel! {
        didSet {
            tracksTitleLabel.text = "Advance Volume"
            tracksTitleLabel.font = .Montserrat.bold3
        }
    }
    
    @IBOutlet var tracksContainerView: UIView! {
        didSet {
            tracksContainerView.cornerRadius(with: 5)
        }
    }
    @IBOutlet var tracksStackView: UIStackView!
    @IBOutlet var tracksContainerStackView: UIStackView! {
        didSet {
            tracksContainerStackView.isHidden = true
        }
    }
    
    func configure(subliminal: Subliminal) {
        titleLbl.text = subliminal.title
        descriptionLbl.text = subliminal.guide
        coverImageView.sd_setImage(with: .init(string: subliminal.cover)) { [weak self] image, error, _, _ in
            self?.coverImageView.image = image
            self?.coverImageView.contentMode = .scaleAspectFill
        }
        updateFavorite(isLiked: subliminal.isLiked == 1)
        setupTracksVolumeViews(tracks: subliminal.info)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientView(view: gradientView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tracksContainerStackView.isUserInteractionEnabled = tabViewModel.user()?.isPremium == true
    }
    
    @objc private func panGesture(_ sender: UIGestureRecognizer) {
        let location = sender.location(in: scrollView)
        Logger.info("gesture - \(location)", topic: .presentation)
    }
    
    override func setupBinding() {
        super.setupBinding()
        
        audioPlayerViewModel.selectedSubliminalObservable
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] subliminal in
                self?.configure(subliminal: subliminal)
            }
            .disposed(by: disposeBag)
        
        playPauseButton.rx.tap
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] _ in
                self?.audioPlayerViewModel.playAudio()
            }
            .disposed(by: disposeBag)
        
        repeatView.rx.tap
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] _ in
                self?.audioPlayerViewModel.updateRepat()
            }
            .disposed(by: disposeBag)
        
        audioPlayerViewModel.repeatStatus.asObservable()
            .subscribe { [weak self] repeatState in
                switch repeatState {
                case .repeatAll:
                    self?.repeatView.setImage(UIImage(named: .repeatAll).withRenderingMode(.alwaysOriginal), for: .normal)
                case .repeartCurrentlyPlaying:
                    self?.repeatView.setImage(UIImage(named: .repeatOnce).withRenderingMode(.alwaysOriginal), for: .normal)
                }
            }
            .disposed(by: disposeBag)
        
        audioPlayerViewModel.playerStatusObservable
            .map {
                $0 == .isPlaying || $0 == .isPaused || $0 == .isReadyToPlay
            }
            .bind(
                to: playPauseButton.rx.isEnabled,
                  nextButton.rx.isEnabled,
                  previousButton.rx.isEnabled,
                  favoriteButton.rx.isEnabled,
                  advanceVolumeBtn.rx.isEnabled
            )
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] _ in
                self?.audioPlayerViewModel.next()
            }
            .disposed(by: disposeBag)
        
        previousButton.rx.tap
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] _ in
                self?.audioPlayerViewModel.previous()
            }
            .disposed(by: disposeBag)
        
        closeButton.rx.tap
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        favoriteButton.rx.tap
            .debounce(.milliseconds(200), scheduler: MainScheduler.asyncInstance)
            .subscribe { [weak self] _ in
                self?.audioPlayerViewModel.updateFavorite()
            }
            .disposed(by: disposeBag)
        
        advanceVolumeBtn.rx.tap
            .subscribe { [weak self] _ in
                self?.tracksContainerStackView.isHidden.toggle()
            }
            .disposed(by: disposeBag)
        
        audioPlayerViewModel.progressObservable
            .bind(to: progressView.rx.progress)
            .disposed(by: disposeBag)
        
        audioPlayerViewModel.timeRelay
            .map { $0.replacingOccurrences(of: " - ", with: "/")}
            .bind(to: timeLabel.rx.text)
            .disposed(by: disposeBag)
        
        audioPlayerViewModel.playerStateObservable
            .distinctUntilChanged()
            .subscribe { [weak self] status in
                self?.updatePlayerStatus(status: status)
            }
            .disposed(by: disposeBag)
        
        optionButton.rx.tap
            .subscribe { [weak self] _ in
                self?.showOptions()
            }
            .disposed(by: disposeBag)
    }
    
    @objc private func showOptions() {
        guard let subliminal = audioPlayerViewModel.selectedSubliminal else { return }
        let viewController = PlayerOptionViewController.instantiate(from: .playerOption) as! PlayerOptionViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.navigationBar.isHidden = true
        presentModally(navController, animated: true)
        viewController.loadViewIfNeeded()
        viewController.configure(subliminal: subliminal, playlistId: subliminal.playlistId) {
            self.toggleBlurEffect(isHidden: true)
        }
        toggleBlurEffect(isHidden: false)
    }
    
    private func setupTracksVolumeViews(tracks: [SubliminalAudioInfo]) {
        tracksStackView.spacing = 10
        let arrangedViews = tracksStackView.arrangedSubviews
        arrangedViews
            .forEach { [weak self] view in
                self?.tracksStackView.removeArrangedSubview(view)
                view.removeFromSuperview()
            }
        volumeDisposeBag = DisposeBag()
        
        tracks.forEach { info in
            
            let containerView = UIView()
            containerView.translatesAutoresizingMaskIntoConstraints = false
            
            let stackView = UIStackView()
            stackView.spacing = 5
            stackView.axis = .vertical
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            let label = UILabel()
            label.text = info.trackTitle
            label.font = UIFont.Montserrat.medium7
            label.numberOfLines = 2
            label.translatesAutoresizingMaskIntoConstraints = false
            
            let progressContainerView = UIView()
            let progress = CGFloat(info.volume) / 100
            progressContainerView.backgroundColor = .clear
            let progressView = VerticalProgressBar(minimumProgress: progress)
            progressView.progress = progress
            progressView.backgroundColor = .white
            progressView.cornerBorderRadius(cornerRadius: 10, borderColor: .black, borderWidth: 0.2)
            progressView.translatesAutoresizingMaskIntoConstraints = false
            progressContainerView.addSubview(progressView)
            progressView.setCornerRadius(5)
            
            progressView.progressRelay.asObservable()
                .subscribe { [weak self] progress in
                    self?.audioPlayerViewModel.updateVolume(level: Float(progress), trackID: info.trackID)
                }
                .disposed(by: volumeDisposeBag)
            
            containerView.addSubview(stackView)
            NSLayoutConstraint
                .activate([
                    stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
                    stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                    stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                    stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                    
                    progressView.widthAnchor.constraint(equalToConstant: 15),
                    progressView.centerXAnchor.constraint(equalTo: progressContainerView.centerXAnchor),
                    progressView.centerYAnchor.constraint(equalTo: progressContainerView.centerYAnchor),
                    progressView.heightAnchor.constraint(equalTo: progressContainerView.heightAnchor),
                    
                    containerView.widthAnchor.constraint(lessThanOrEqualToConstant: 35)
                    
                ])
            
            stackView.addArrangedSubview(progressContainerView)
            stackView.addArrangedSubview(label)
            
            tracksStackView.addArrangedSubview(containerView)
            
        }
        
    }
    
    private func updatePlayerStatus(status: AppState.PlayerState) {
        let image = UIImage(named: status == .isPlaying ? "pause" : "play")
        let newImage = image?.resizeImage(targetHeight: 59)
        playPauseButton.setImage(newImage, for: .normal)
        playPauseButton.imageView?.contentMode = .scaleAspectFit
    }
    
    private func updateFavorite(isLiked: Bool) {
        let image = UIImage(named: isLiked ? "active heart" : "heart")
        let newImage = image?.resizeImage(targetHeight: 21)
        favoriteButton.setImage(newImage, for: .normal)
        favoriteButton.imageView?.contentMode = .scaleAspectFit
    }
    
    deinit {
        print("Deinit Player View Controller")
    }
}
