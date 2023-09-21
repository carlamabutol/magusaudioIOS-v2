//
//  MySubsViewController.swift
//  Magus
//
//  Created by Jomz on 8/10/23.
//

import UIKit
import RxSwift

class MySubsViewController: CommonViewController {
    var profileViewModel: ProfileViewModel!
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.font = .Montserrat.bold17
        }
    }
    
    @IBOutlet var playlistsButton: UIButton! {
        didSet {
            playlistsButton.titleLabel?.font = .Montserrat.bold15
        }
    }
    @IBOutlet var favoritesButton: UIButton! {
        didSet {
            favoritesButton.titleLabel?.font = .Montserrat.bold15
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupBinding() {
        super.setupBinding()
        
        playlistsButton.rx.tap
            .subscribe { [weak self] _ in
                self?.goToPlaylists()
            }
            .disposed(by: disposeBag)
        
        favoritesButton.rx.tap
            .subscribe { [weak self] _ in
                self?.goToFavorites()
            }
            .disposed(by: disposeBag)
        
    }
    
    private func goToPlaylists() {
        let playlistVC = ProfilePlaylistsViewController.instantiate(from: .profilePlaylists)
        navigationController?.pushViewController(playlistVC, animated: true)
    }
    
    private func goToFavorites() {
        let favoriteVC = ProfileFavoritesViewController.instantiate(from: .profileFavorites)
        navigationController?.pushViewController(favoriteVC, animated: true)
    }
}
