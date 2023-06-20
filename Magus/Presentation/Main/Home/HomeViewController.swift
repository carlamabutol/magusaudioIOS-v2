//
//  HomeViewController.swift
//  Magus
//
//  Created by Jomz on 6/19/23.
//

import UIKit
import RxDataSources

class HomeViewController: CommonViewController {
    
    private let viewModel = HomeViewModel()
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var searchBar: UISearchBar!
    
    private func setupDataSource() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, Int>> { sectionModel, collectionView, indexPath, item in
            
        }
    }
}

struct SectionViewModel {
    var header: String!
    var items: [String]
}

extension SectionViewModel: SectionModelType {
    typealias Item = String
    init(original: SectionViewModel, items: [String]) {
        self = original
        self.items = items
    }
}
