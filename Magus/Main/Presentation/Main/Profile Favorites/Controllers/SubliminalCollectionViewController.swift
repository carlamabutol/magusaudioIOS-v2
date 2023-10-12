//
//  SubliminalCollectionViewController.swift
//  Magus
//
//  Created by Jose Mari Pascual on 9/23/23.
//

import UIKit
import RxSwift

class SubliminalCollectionViewController: CommonViewController {     
    
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
    
    let emptyButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        return button
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
        
        collectionView.register(FavoriteSubliminalCollectionViewCell.instantiate(), forCellWithReuseIdentifier: FavoriteSubliminalCollectionViewCell.identifier)
    }
    
    private func setupDataSource() {
        
        favoritesViewModel.subliminalsObservable
            .bind(to: collectionView.rx.items(cellIdentifier: FavoriteSubliminalCollectionViewCell.identifier, cellType: FavoriteSubliminalCollectionViewCell.self)) { (row, element, cell) in
                cell.configure(item: element)
            }
            .disposed(by: disposeBag)
    }
    
    override func setupBinding() {
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
                self.favoritesViewModel.selectedSubliminal(indexPath)
                Logger.info("Selected Model - \(model)", topic: .presentation)
            }
            .disposed(by: disposeBag)
    }
    
}

extension SubliminalCollectionViewController: UICollectionViewDelegateFlowLayout {
    /// 1
    func collectionView(_ collectionView: UICollectionView,
                  layout collectionViewLayout: UICollectionViewLayout,
                  insetForSectionAt section: Int) -> UIEdgeInsets {
        /// 2
        return .zero
    }

    /// 3
    func collectionView(_ collectionView: UICollectionView,
                   layout collectionViewLayout: UICollectionViewLayout,
                   sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width, height: 50)
    }
}
