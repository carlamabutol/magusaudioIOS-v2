//
//  SeeAllListViewController.swift
//  Magus
//
//  Created by Jomz on 10/9/23.
//

import UIKit
import RxSwift
import RxDataSources

class SeeAllListViewController: CommonViewController {
    
    private let viewModel = SeeAllViewModel()
    var dataSource: RxCollectionViewSectionedReloadDataSource<SectionViewModel>!
    
    @IBOutlet var navigationBar: ProfileNavigationBar! {
        didSet {
            navigationBar.configure(
                model: ProfileNavigationBar.saveButtonModel(backHandler: { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }, saveHandler: { }, title: "")
            )
        }
    }
    
    @IBOutlet var searchView: SearchView! {
        didSet {
            searchView.backgroundColor = .white
            searchView.cornerRadius(with: 10)
            searchView.applyShadow(radius: 5)
        }
    }
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.font = .Montserrat.bold17
        }
    }
    
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.backgroundColor = .clear
            collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
            collectionView.register(HeaderTitleView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderTitleView.identifier)
            setupCompositionalLayout()
            setupDataSource()}
    }
    
    func setupViewModel(for modelType: SeeAllViewModel.ModelType) {
        viewModel.setup(for: modelType)
    }
    
    override func setupBinding() {
        super.setupBinding()
        
        viewModel.titleObservable
            .map{ $0.rawValue }
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.selectedPlaylistRelay
            .asObservable()
            .subscribe { [weak self] playlist in
                self?.goToPlaylist(playlist: playlist)
            }
            .disposed(by: disposeBag)
        
        searchView.textField.rx.text
            .orEmpty
            .subscribe { [weak self] text in
                guard let self = self else { return }
                self.viewModel.setSearchFilter(search: text)
            }
            .disposed(by: disposeBag)
        
    }
    
    private func goToPlaylist(playlist: Playlist) {
        let playlistVC = PlaylistViewController.instantiate(from: .playlist) as! PlaylistViewController
        navigationController?.pushViewController(playlistVC, animated: true)
        playlistVC.setPlaylist(playlist: playlist)
    }
    
    private func setupDataSource() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionViewModel>(configureCell: { dataSource, collectionView, indexPath, item in
            let cell: HomeCustomCell!
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell
            cell.configure(item: item)
            return cell
        })
        
        viewModel.sections.asObservable()
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        self.dataSource = dataSource
    }
    
    private func setupCompositionalLayout() {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, enviroment in
            return self.gridSection()
        }
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    func gridSection()-> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(15)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15)
        section.interGroupSpacing = 15
        return section
    }
    
}
