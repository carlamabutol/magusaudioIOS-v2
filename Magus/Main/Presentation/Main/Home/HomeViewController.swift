//
//  HomeViewController.swift
//  Magus
//
//  Created by Jomz on 6/19/23.
//

import UIKit
import RxDataSources
import RxSwift

class HomeViewController: CommonViewController {
    
    private static let header = "Header"
    private static let item = "Item"
    private let viewModel = HomeViewModel()
    var dataSource: RxCollectionViewSectionedReloadDataSource<SectionViewModel>!
    
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.register(HomeCustomCell.self, forCellWithReuseIdentifier: Self.item)
            collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
            collectionView.register(SelectedMoodCell.instantiate(), forCellWithReuseIdentifier: SelectedMoodCell.identifier)
            collectionView.register(HeaderTitleView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderTitleView.identifier)
            collectionView.register(FooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterView.identifier)
            setupCompositionalLayout()
            setupDataSource()
        }
    }
    @IBOutlet var searchView: SearchView! {
        didSet {
            searchView.textField.isUserInteractionEnabled = false
            searchView.isUserInteractionEnabled = true
            searchView.backgroundColor = .white
            searchView.cornerRadius(with: 10)
            searchView.applyShadow(radius: 5)
            let tapGesutre = UITapGestureRecognizer(target: self, action: #selector(tapSearchView))
            searchView.addGestureRecognizer(tapGesutre)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getHomeDetails()
    }
    
    @objc private func tapSearchView() {
        tabBarController?.selectedIndex = 1
    }
    
    override func setupBinding() {
        super.setupBinding()
        
        viewModel.selectedFooterObservable
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] modelType in
                self?.seeAll(for: modelType)
            }
            .disposed(by: disposeBag)
        
        viewModel.selectedPlaylistObservable
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] playlist in
                self?.goToPlaylist(with: playlist)
            }
            .disposed(by: disposeBag)
        
    }
    
    private func setupDataSource() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionViewModel>(configureCell: { dataSource, collectionView, indexPath, item in
            switch dataSource[indexPath.section].header {
            case LocalisedStrings.HomeHeaderTitle.mood:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectedMoodCell.identifier, for: indexPath) as! SelectedMoodCell
                
                cell.configure(model: item as! SelectedMoodCell.Model)
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as! CategoryCell
                
                cell.configure(item: item)
                return cell
            }
//            switch indexPath.section {
//            case 0:
//                cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as! CategoryCell
//
//                cell.configure(item: item)
//            case 1:
//                cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as! CategoryCell
//
//                cell.configure(item: item)
//            default:
//                cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as! CategoryCell
//
//                cell.configure(item: item)
//            }
        }, configureSupplementaryView: { dataSource, collectionView, title, indexPath in
            if title == UICollectionView.elementKindSectionHeader {
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: title, withReuseIdentifier: HeaderTitleView.identifier, for: indexPath) as! HeaderTitleView
                view.configure(title: dataSource.sectionModels[indexPath.section].header)
                return view
            } else {
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: title, withReuseIdentifier: FooterView.identifier, for: indexPath) as! FooterView
                view.configure(for: dataSource.sectionModels[indexPath.section].footerTapHandler)
                return view
            }
        })
        
        viewModel.sections.asObservable()
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        self.dataSource = dataSource
    }
    
    private func setupCompositionalLayout() {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, enviroment in
            guard let self = self else { return self!.categorySection() }
            let header = self.dataSource[sectionIndex].header
            switch header {
            case LocalisedStrings.HomeHeaderTitle.mood:
                return self.moodSection()
            case LocalisedStrings.HomeHeaderTitle.category:
                return self.categorySection()
            case LocalisedStrings.HomeHeaderTitle.recommendations:
                return self.recommendationSection()
            case LocalisedStrings.HomeHeaderTitle.featuredPlayList:
                return self.featuredPlaylistSection()
            default:
                return self.categorySection()
            }
        }
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    private func goToPlaylist(with playlist: Playlist) {
        let playlistVC = PlaylistViewController.instantiate(from: .playlist) as! PlaylistViewController
        navigationController?.pushViewController(playlistVC, animated: true)
        playlistVC.setPlaylist(playlist: playlist)
    }
    
    private func seeAll(for modelType: SeeAllViewModel.ModelType) {
        let seeAllVC = SeeAllListViewController.instantiate(from: .seeAll) as! SeeAllListViewController
        seeAllVC.setupViewModel(for: modelType)
        navigationController?.pushViewController(seeAllVC, animated: true)
    }
    
    func moodSection()-> NSCollectionLayoutSection {
        let heightDimension = NSCollectionLayoutDimension.estimated(100)
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: heightDimension)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: heightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15)
        section.orthogonalScrollingBehavior = .none
        return section
    }
    
    func categorySection()-> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.35), heightDimension: .absolute(115))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [
            .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top),
            .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30)), elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom),
        ]
        return section
    }
    
    func recommendationSection()-> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(140))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [
            .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top),
            .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30)), elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom),
        ]
        return section
    }
    
    func featuredPlaylistSection()-> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(140))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [
            .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top),
        ]
        return section
    }
}
