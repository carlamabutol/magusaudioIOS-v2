//
//  PlaylistCollectionViewController.swift
//  Magus
//
//  Created by Jose Mari Pascual on 9/23/23.
//

import UIKit
import RxSwift

class PlaylistCollectionViewController: CommonViewController {
    
    weak var favoritesViewModel: ProfileFavoritesViewModel!
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 18
        layout.minimumInteritemSpacing = 24
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSource()
        view.backgroundColor = .clear
    }
    
    override func setupView() {
        
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        collectionView.register(FavoritePlaylistCell.instantiate(), forCellWithReuseIdentifier: FavoritePlaylistCell.identifier)
    }
    
    private func setupDataSource() {
        
        favoritesViewModel.playlistObservable
            .bind(to: collectionView.rx.items(cellIdentifier: FavoritePlaylistCell.identifier, cellType: FavoritePlaylistCell.self)) { (row, element, cell) in
                cell.configure(item: element)
            }
            .disposed(by: disposeBag)
    }
    
}

extension PlaylistCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                  layout collectionViewLayout: UICollectionViewLayout,
                  insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView,
                   layout collectionViewLayout: UICollectionViewLayout,
                   sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width, height: 100)
    }
}
