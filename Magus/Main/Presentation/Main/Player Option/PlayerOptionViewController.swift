//
//  PlayerOptionViewController.swift
//  Magus
//
//  Created by Jomz on 10/30/23.
//

import UIKit
import RxSwift
import SDWebImage

class PlayerOptionViewController: CommonViewController {
    
    private let viewModel = PlayerOptionViewModel()
    private var loadingVC: UIViewController?
    
    @IBOutlet var closeButton: UIButton!
    
    @IBOutlet var coverImage: UIImageView! {
        didSet {
            coverImage.cornerRadius(with: 5)
            coverImage.applyShadow(shadowOpacity: 0.1)
        }
    }
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.font = .Montserrat.semibold24
            titleLabel.numberOfLines = 2
            titleLabel.textColor = .white
        }
    }
    
    @IBOutlet var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.font = .Montserrat.semibold15
            descriptionLabel.numberOfLines = 3
            descriptionLabel.text = LocalisedStrings.LoremIpsum.desc1
            descriptionLabel.textColor = .white
        }
    }
    
    @IBOutlet var likeButton: UIButton! {
        didSet {
            likeButton.titleLabel?.font = .Montserrat.semibold17
            likeButton.titleEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 0)
        }
    }
    
    @IBOutlet var addToPlaylistButton: UIButton! {
        didSet {
            addToPlaylistButton.titleLabel?.font = .Montserrat.semibold17
            addToPlaylistButton.setTitle(LocalisedStrings.Player.addToPlaylist, for: .normal)
            addToPlaylistButton.titleEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 0)
        }
    }
    
    @IBOutlet var addToQueueButton: UIButton! {
        didSet {
            addToQueueButton.titleLabel?.font = .Montserrat.semibold17
            addToQueueButton.setTitle(LocalisedStrings.Player.addToQueue, for: .normal)
            addToQueueButton.titleEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 0)
        }
    }
    
    var isAlreadyAddedInPlaylist: Bool = false
    
    private var dismissCompletion: CompletionHandler?
    
    func configure(subliminal: Subliminal, playlistId: String? = nil, dismiss: @escaping CompletionHandler) {
        titleLabel.setTextWithShadow(text: subliminal.title)
        descriptionLabel.text = subliminal.description
        isAlreadyAddedInPlaylist = playlistId != nil
        updatePlaylist(isAdded: playlistId != nil)
        dismissCompletion = dismiss
        coverImage.sd_setImage(with: .init(string: subliminal.cover))
        viewModel.configure(subliminal: subliminal, playlistId: playlistId)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear // Make the
    }
    
    override func setupBinding() {
        super.setupBinding()
        closeButton.rx.tap
            .subscribe { [weak self] _ in
                self?.closeButtonTapped()
            }
            .disposed(by: disposeBag)
        
        likeButton.rx.tap
            .subscribe { [weak self] _ in
                self?.viewModel.updateFavorite()
            }
            .disposed(by: disposeBag)
        
        addToPlaylistButton.rx.tap
            .subscribe { [weak self] _ in
                guard let self else { return }
                if self.isAlreadyAddedInPlaylist {
                    self.viewModel.removeSubliminalToPlaylist()
                } else {
                    self.goToAddToPlaylist()
                }
            }
            .disposed(by: disposeBag)
        
        addToQueueButton.rx.tap
            .subscribe { [weak self] _ in
                self?.viewModel.addToQueueSubliminal()
            }
            .disposed(by: disposeBag)
        
        viewModel.addedToQueueObservable
            .subscribe { [weak self] inQueue in
                self?.updateQueue(inQueue: inQueue)
            }
            .disposed(by: disposeBag)
        
        viewModel.isLikedObservable
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] isLike in
                self?.updateFavorite(isLiked: isLike)
            }
            .disposed(by: disposeBag)
        
        viewModel.alertObservable
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] alertModel in
                switch alertModel {
                case .loading(let isLoading):
                    if isLoading {
                        self?.loadingVC = self?.presentLoading()
                    }
                case .alertModal(let model):
                    if self?.loadingVC == nil {
                        self?.presentAlert(title: model.title, message: model.message, tapOKHandler: model.actionHandler)
                    } else {
                        self?.loadingVC?.dismiss(animated: false, completion: {
                            self?.loadingVC = nil
                            self?.presentAlert(title: model.title, message: model.message, tapOKHandler: model.actionHandler)
                        })
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
        dismissCompletion?()
    }
    
    private func updateFavorite(isLiked: Bool) {
        let image = UIImage(named: isLiked ? .likeActive : .like)
        let newImage = image?.resizeImage(targetHeight: 31)
        likeButton.setImage(newImage, for: .normal)
        likeButton.imageView?.contentMode = .scaleAspectFit
        likeButton.setTitle(isLiked ? LocalisedStrings.Player.favoriteRemove : LocalisedStrings.Player.favorite, for: .normal)

    }
    
    private func updateQueue(inQueue: Bool) {
        let image = UIImage(named: inQueue ? .addToQueueActive : .addToQueue)
        let newImage = image?.resizeImage(targetHeight: 31)
        addToQueueButton.setImage(newImage, for: .normal)
        addToQueueButton.imageView?.contentMode = .scaleAspectFit
        let title = inQueue ? LocalisedStrings.Player.addedToQueue : LocalisedStrings.Player.addToQueue
        addToQueueButton.setTitle(title, for: .normal)
    }
    
    private func updatePlaylist(isAdded: Bool) {
        let image = UIImage(named: isAdded ? .addToPlaylistActive : .addToPlaylist)
        let newImage = image?.resizeImage(targetHeight: 31)
        let title = LocalisedStrings.Player.addToPlaylist
//        let title = isAdded ? LocalisedStrings.Player.removeFromPlaylist : LocalisedStrings.Player.addToPlaylist
        addToPlaylistButton.setTitle(title, for: .normal)
        addToPlaylistButton.setImage(newImage, for: .normal)
        addToPlaylistButton.imageView?.contentMode = .scaleAspectFit
    }
    
    private func goToAddToPlaylist() {
        guard let subliminal = viewModel.subliminalRelay.value else { return }
        let vc = AddToPlaylistViewController.instantiate(from: .addToPlaylist) as! AddToPlaylistViewController
        vc.configure(subliminal: subliminal, playlistId: viewModel.playlistIdRelay.value)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
