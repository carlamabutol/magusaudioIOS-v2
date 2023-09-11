//
//  SearchViewController.swift
//  Magus
//
//  Created by Jomz on 6/19/23.
//

import UIKit
import RxDataSources
import RxSwift

class SearchViewController: CommonViewController {
    
    private static let header = "Header"
    private static let item = "Item"
    var tabViewModel: MainTabViewModel!
    private let viewModel = SearchViewModel()
    var dataSource: RxCollectionViewSectionedReloadDataSource<SectionViewModel>!
//    weak var tabNavigationDelegate: TabNavigationDelegate?
    
    @IBOutlet var searchView: SearchView! {
        didSet {
            searchView.backgroundColor = .white
            searchView.cornerRadius(with: 10)
            searchView.applyShadow(radius: 5)
        }
    }
    
    
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.register(HomeCustomCell.self, forCellWithReuseIdentifier: Self.item)
            collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
            collectionView.register(HeaderTitleView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderTitleView.identifier)
            collectionView.register(FooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterView.identifier)
            collectionView.backgroundColor = .clear
            setupCompositionalLayout()
            setupDataSource()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupBinding() {
        super.setupBinding()
        searchView.textField.rx.text
            .orEmpty
            .subscribe { [weak self] text in
                guard let self = self else { return }
                self.viewModel.setSearchFilter(text)
            }
            .disposed(by: disposeBag)
        
        searchView.configure { [weak self] in
            guard let self = self else { return }
            self.viewModel.setSearchFilter("")
        }
        
    }
    
    private func setupDataSource() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionViewModel>(configureCell: { dataSource, collectionView, indexPath, item in
            let cell: HomeCustomCell!
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell
            cell.configure(item: item)
            return cell
        }, configureSupplementaryView: { dataSource, collectionView, title, indexPath in
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: title, withReuseIdentifier: HeaderTitleView.identifier, for: indexPath) as! HeaderTitleView
            view.configure(title: dataSource.sectionModels[indexPath.section].header)
            return view
        })
        
        viewModel.sections.asObservable()
            .bind(to: collectionView.rx.items(dataSource: dataSource))
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
                if indexPath.section == 0 {
                    let subliminal = self.viewModel.getSubliminal(model.id)
                    self.tabViewModel.selectSubliminal(subliminal, subliminals: viewModel.subliminalRelay.value)
                }
            }
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
        section.boundarySupplementaryItems = [
            .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top),
        ]
        return section
    }
    
}
