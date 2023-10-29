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
    var audioPlayerViewModel: AudioPlayerViewModel!
    
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
    
    @IBOutlet var tracksStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.bringSubviewToFront(optionStackView)
        view.bringSubviewToFront(closeButton)
    }
    
    func configure(subliminal: Subliminal) {
        titleLbl.text = subliminal.title
        descriptionLbl.text = subliminal.guide
        coverImageView.sd_setImage(with: .init(string: subliminal.cover)) { [weak self] image, error, _, _ in
            self?.coverImageView.image = image
            self?.coverImageView.contentMode = .scaleAspectFill
        }
        updateFavorite(isLiked: subliminal.isLiked == 0)
        setupTracksVolumeViews(tracks: subliminal.info)
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
                case .repeatOnce, .noRepeat:
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
    }
    
    private func setupTracksVolumeViews(tracks: [SubliminalAudioInfo]) {
        tracksStackView.spacing = 10
        let arrangedViews = tracksStackView.arrangedSubviews
        arrangedViews
            .forEach { [weak self] view in
                self?.tracksStackView.removeArrangedSubview(view)
            }
        
        tracks.forEach { info in
            
            let containerView = UIView()
            
            let stackView = UIStackView()
            stackView.spacing = 5
            stackView.axis = .vertical
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            let label = UILabel()
            label.text = String(info.volume)
            label.font = UIFont.Montserrat.medium7
            label.numberOfLines = 2
            label.translatesAutoresizingMaskIntoConstraints = false
            label.widthAnchor.constraint(lessThanOrEqualToConstant: 45).isActive = true
            
            let progressContainerView = UIView()
            progressContainerView.backgroundColor = .clear
            let progressView = VerticalProgressBar()
            progressView.progress = CGFloat(info.volume) / 100
            progressView.translatesAutoresizingMaskIntoConstraints = false
            progressContainerView.addSubview(progressView)
            
            containerView.addSubview(stackView)
            NSLayoutConstraint
                .activate([
                    stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
                    stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                    stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                    stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                    
                    progressView.widthAnchor.constraint(equalToConstant: 15),
                    progressView.centerXAnchor.constraint(equalTo: progressContainerView.centerXAnchor),
                    progressView.topAnchor.constraint(equalTo: progressContainerView.topAnchor),
                    progressView.bottomAnchor.constraint(equalTo: progressContainerView.bottomAnchor),
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

import UIKit

class VerticalProgressBar: UIView {
    private let progressView = UIView()
    private var panGesture: UIPanGestureRecognizer!

    var progress: CGFloat = 0 {
        didSet {
            updateProgressBar()
        }
    }

    init() {
        super.init(frame: .zero)
        setupProgressBar()
        setupPanGesture()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupProgressBar()
        setupPanGesture()
    }
    
    var progressViewHeightConstraint: NSLayoutConstraint!

    private func setupProgressBar() {
        backgroundColor = .lightGray

        addSubview(progressView)
        progressView.backgroundColor = .green
        progressView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor),
            progressView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        progressViewHeightConstraint = progressView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: progress)
        progressViewHeightConstraint.isActive = true
    }

    private func updateProgressBar() {
        progressViewHeightConstraint.isActive = false
        progressViewHeightConstraint = progressView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: progress)
        progressViewHeightConstraint.isActive = true
    }

    private func setupPanGesture() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(panGesture)
    }
    
    var initialTranslation: CGPoint = CGPoint(x: 0, y: 0)

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        
        // You can adjust the sensitivity factor to control the speed reduction.
        let sensitivity: CGFloat = 0.5
        
        // Calculate the modified translation
        let modifiedTranslation = CGPoint(
            x: translation.x - (initialTranslation.x * sensitivity),
            y: translation.y - (initialTranslation.y * sensitivity)
        )
        
        initialTranslation = translation
        
        let newProgress = max(0, min(1, progress - modifiedTranslation.y / frame.height))
        progress = newProgress

        if gesture.state == .ended {
            // You can handle any additional logic when the gesture ends here
        }
    }
}
