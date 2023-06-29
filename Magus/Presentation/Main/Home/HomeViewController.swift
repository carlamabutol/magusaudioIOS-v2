//
//  HomeViewController.swift
//  Magus
//
//  Created by Jomz on 6/19/23.
//

import UIKit
import RxDataSources

class HomeViewController: CommonViewController {
    
    private static let header = "Header"
    private static let item = "Item"
    private let viewModel = HomeViewModel()
    var dataSource: RxCollectionViewSectionedReloadDataSource<SectionViewModel>!
    
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.register(HomeCustomCell.self, forCellWithReuseIdentifier: Self.item)
            collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
            collectionView.register(HeaderTitleView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderTitleView.identifier)
            setupCompositionalLayout()
            setupDataSource()
        }
    }
    
    @IBOutlet var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getAllCategory()
    }
    
    private func setupDataSource() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionViewModel>(configureCell: { dataSource, collectionView, indexPath, item in
            let cell: HomeCustomCell!
            switch indexPath.section {
            case 0:
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as! CategoryCell
                
                cell.configure(item: item)
            case 1:
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.item, for: indexPath) as! HomeCustomCell
                cell.backgroundColor = .randomColor()
            default:
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.item, for: indexPath) as! HomeCustomCell
                cell.backgroundColor = .randomColor()
            }
            return cell
        }, configureSupplementaryView: { dataSource, collectionView, title, indexPath in
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderTitleView.identifier, for: indexPath) as! HeaderTitleView
            view.configure(title: dataSource.sectionModels[indexPath.section].header)
            return view
        })
        
        viewModel.sections.asObservable()
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        self.dataSource = dataSource
    }
    
    private func setupCompositionalLayout() {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, enviroment in
            switch sectionIndex {
            case 0 :
                return self.categorySection()
            case 1 :
                return self.recommendationSection()
            default:
                return self.featuredPlaylistSection()
            }
        }
        collectionView.setCollectionViewLayout(layout, animated: true)
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
