//
//  PlaylistViewController.swift
//  Magus
//
//  Created by Jomz on 9/10/23.
//

import UIKit
import RxSwift
import RxDataSources


class PlaylistViewController: CommonViewController {
    
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
        }
    }
    
    func setPlaylist(playlist: Playlist) {
        viewModel.setPlaylist(playlist: playlist)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupDataSource()
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
            .subscribe { [weak self] in
                self?.configure(playlist: $0)
            }
            .disposed(by: disposeBag)
        
    }
    
    private func setupDataSource() {
        viewModel.subliminalCellModelObservable
            .bind(to: collectionView.rx.items(cellIdentifier: SubliminalCollectionViewCell.cellIdentifier, cellType: SubliminalCollectionViewCell.self)) { (row, element, cell) in
                cell.configure(item: element)
            }
            .disposed(by: disposeBag)
    }
    
    func configure(playlist: Playlist) {
        coverImageView.sd_setImage(with: .init(string: playlist.cover))
        playlistTitle.text = playlist.title
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
