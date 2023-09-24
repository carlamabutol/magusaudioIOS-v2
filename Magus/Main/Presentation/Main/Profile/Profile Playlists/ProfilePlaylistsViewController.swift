//
//  ProfilePlaylistsViewController.swift
//  Magus
//
//  Created by Jomz on 9/20/23.
//

import UIKit

class ProfilePlaylistsViewController: CommonViewController {
    
    @IBOutlet var proflieNavigationBar: ProfileNavigationBar!
    
    @IBOutlet var searchView: SearchView! {
        didSet {
            searchView.backgroundColor = .white
            searchView.cornerRadius(with: 10)
            searchView.applyShadow(radius: 5)
        }
    }
    
    @IBOutlet var collectionView: UICollectionView!
    
}
