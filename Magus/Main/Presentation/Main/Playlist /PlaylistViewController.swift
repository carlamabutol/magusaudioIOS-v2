//
//  PlaylistViewController.swift
//  Magus
//
//  Created by Jomz on 9/10/23.
//

import UIKit
import RxSwift
import RxDataSources

class PlaylistViewController: BlurCommonViewController {
    private let playerViewModel = AudioPlayerViewModel.shared
    
    @IBOutlet var gradientView: UIView!
    
    @IBOutlet var addSubButton: UIButton! {
        didSet {
            let image = UIImage(named: .addIcon)
            let newImage = image?.resizeImage(targetHeight: 22)
            addSubButton.setTitle("", for: .normal)
            addSubButton.setImage(newImage?.withRenderingMode(.alwaysTemplate), for: .normal)
            addSubButton.imageView?.contentMode = .scaleAspectFit
            addSubButton.tintColor = .black
        }
    }
    
    @IBOutlet var favoriteButton: UIButton! {
        didSet {
            favoriteButton.setTitle("", for: .normal)
        }
    }
    
    @IBOutlet var controlButton: UIButton! {
        didSet {
            controlButton.setTitle("", for: .normal)
        }
    }
    
    @IBOutlet var repeatButton: UIButton! {
        didSet {
            repeatButton.setTitle("", for: .normal)
            repeatButton.setImage(UIImage(named: .repeatOnce).withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    private let viewModel: PlaylistViewModel = PlaylistViewModel()
    
    lazy var collapsedPlayerView: CollapsedPlayerView = {
        let view = CollapsedPlayerView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    @IBOutlet var backButton: UIButton! {
        didSet {
            backButton.setImage(UIImage(named: .leftArrow).withRenderingMode(.alwaysTemplate), for: .normal)
            backButton.tintColor = .black
        }
    }
    
    @IBOutlet var coverImageView: UIImageView! {
        didSet {
            coverImageView.contentMode = .scaleAspectFill
        }
    }
    
    @IBOutlet var playlistTitle: UILabel! {
        didSet {
            playlistTitle.font = .Montserrat.title3
            playlistTitle.numberOfLines = 2
        }
    }
    
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.backgroundColor = .clear
            collectionView.delegate = self
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 18
            layout.minimumInteritemSpacing = 24
            collectionView
                .setCollectionViewLayout(layout, animated: true)
            collectionView.contentInset = .init(top: 0, left: 20, bottom: 70, right: 20)
        }
    }
    
    lazy var emptyView: EmptyPlaylistView = {
        let view = EmptyPlaylistView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .yellow
        return view
    }()
    
    func setPlaylist(playlist: Playlist) {
        viewModel.setPlaylist(playlist: playlist)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSource()
        setupGradientView(view: gradientView)
        
        view.addSubview(emptyView)
        emptyView.fillView(fromView: collectionView)
    }
    
    fileprivate func setupCollapsedPlayerView() {
        let padding: CGFloat = 10
        let bottom = getSafeAreaLayoutGuide().1
        let paddingBottom = bottom + padding
        view.addSubview(collapsedPlayerView)
        NSLayoutConstraint.activate([
            collapsedPlayerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -paddingBottom),
            collapsedPlayerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            collapsedPlayerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            collapsedPlayerView.heightAnchor.constraint(equalToConstant: 90)
        ])
        collapsedPlayerView.cornerRadius(with: 5)
        collapsedPlayerView.applyShadow(radius: 5)
    }
    
    override func setupBinding() {
        super.setupBinding()
        
        viewModel.playlistObservable
            .subscribe { [weak self] playlist in
                self?.addSubButton.isHidden = playlist.isOwnPlaylist == 0
                if(playlist.isOwnPlaylist == 0){
                   self?.addSubButton.layer.transform = CATransform3DMakeScale(0, 0, 0);
                }else{
                    self?.addSubButton.layer.transform = CATransform3DIdentity
                }
                self?.configure(playlist: playlist)
            }
            .disposed(by: disposeBag)
        
        playerViewModel.playerStatusObservable
            .distinctUntilChanged()
            .subscribe { [weak self] status in
                self?.updatePlayerStatus(status: status)
            }
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .subscribe { [weak self] _ in self?.popViewController() }
            .disposed(by: disposeBag)
        
        addSubButton.rx.tap
            .subscribe { [weak self] _ in self?.addSubliminal() }
            .disposed(by: disposeBag)
        
        controlButton.rx.tap
            .subscribe { [weak self] _ in
                self?.viewModel.playPlaylist()
            }
            .disposed(by: disposeBag)
        
        favoriteButton.rx.tap
            .subscribe { [weak self] _ in
                self?.viewModel.updatePlaylistFavorite()
            }
            .disposed(by: disposeBag)
        
        viewModel.optionTapObservable
            .subscribe { [weak self] (subliminal, playlist) in
                self?.showOptions(selectedSubliminal: subliminal, playlist: playlist)
            }
            .disposed(by: disposeBag)
        
        viewModel.subliminalCellModelObservable
            .map { !$0.isEmpty }
            .subscribe { [weak self] isHidden in
                self?.emptyView.isHidden = isHidden
            }
            .disposed(by: disposeBag)
        
        viewModel.subliminalCellModelObservable
            .map { $0.isEmpty }
            .bind(to: repeatButton.rx.isHidden,
                  addSubButton.rx.isHidden,
                  controlButton.rx.isHidden
            )
            .disposed(by: disposeBag)
        
        emptyView.addButton.rx.tap
            .subscribe { [weak self] _ in
                self?.addSubliminal()
            }
            .disposed(by: disposeBag)
        
        viewModel.subliminalCellModelObservable
            .compactMap { $0.first?.imageUrl }
            .subscribe { [weak self] imageUrl in
                self?.coverImageView.sd_setImage(with: imageUrl)
            }
            .disposed(by: disposeBag)
        
        Observable
            .zip(
                collectionView
                    .rx
                    .itemSelected
                ,collectionView
                    .rx
                    .modelSelected(SectionViewModel.Item.self)
            )
            .bind{ [unowned self] indexPath, model in
                self.viewModel.selectedSubliminal(indexPath)
            }
            .disposed(by: disposeBag)

        
    }
    
    private func showOptions(selectedSubliminal: Subliminal, playlist: Playlist) {
        let viewController = PlayerOptionViewController.instantiate(from: .playerOption) as! PlayerOptionViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.navigationBar.isHidden = true
        presentModally(navController, animated: true)
        viewController.loadViewIfNeeded()
        viewController.configure(subliminal: selectedSubliminal, playlistId: playlist.playlistID) {
            self.toggleBlurEffect(isHidden: true)
        }
        toggleBlurEffect(isHidden: false)
    }
    
    private func setupDataSource() {
        viewModel.subliminalCellModelObservable
            .bind(to: collectionView.rx.items(cellIdentifier: SubliminalCollectionViewCell.cellIdentifier, cellType: SubliminalCollectionViewCell.self)) { (row, element, cell) in
                cell.configure(item: element)
            }
            .disposed(by: disposeBag)
    }
    
    private func addSubliminal() {
        guard let playlist = viewModel.playlist else { return }
        let vc = SubliminalListViewController.instantiate(from: .subliminalList) as! SubliminalListViewController
        navigationController?.pushViewController(vc, animated: true)
        vc.configure(playlist: playlist)
    }
    
    func configure(playlist: Playlist) {
        coverImageView.sd_setImage(with: .init(string: playlist.cover))
        configureFavoriteButton(isFavorite: playlist.isLiked == 1)
        updatePlayerStatus(status: .unknown)
        setTextWithShadow(text: playlist.title)
    }
    
    private func configureFavoriteButton(isFavorite: Bool) {
        let image = UIImage(named: isFavorite ? .favoriteIsActive : .favorite)
        let newImage = image?.resizeImage(targetHeight: 22)
        favoriteButton.setImage(newImage?.withRenderingMode(.alwaysTemplate), for: .normal)
        favoriteButton.imageView?.contentMode = .scaleAspectFit
        favoriteButton.tintColor = .black
    }
    
    private func updatePlayerStatus(status: PlayerStatus) {
        let image = UIImage(named: status == .isPlaying ? "pause" : "play")
        let newImage = image?.resizeImage(targetHeight: 40)
        controlButton.setImage(newImage, for: .normal)
        controlButton.imageView?.contentMode = .scaleAspectFit
    }
    
    private func setTextWithShadow(text: String) {
        let myShadow = NSShadow()
        myShadow.shadowBlurRadius = 3
        myShadow.shadowOffset = CGSize(width: 3, height: 3)
        myShadow.shadowColor = UIColor.gray
        let myAttribute = [NSAttributedString.Key.shadow: myShadow,
                           NSAttributedString.Key.font: UIFont.Montserrat.title3,
                           NSAttributedString.Key.foregroundColor: UIColor.white]
        let myAttrString = NSAttributedString(string: text, attributes: myAttribute)
        playlistTitle.attributedText = myAttrString
    }
}

extension PlaylistViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width, height: 50)
    }
    
}
