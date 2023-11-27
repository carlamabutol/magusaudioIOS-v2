//
//  ProfilePlaylistsViewController.swift
//  Magus
//
//  Created by Jomz on 9/20/23.
//

import UIKit
import RxSwift
import RxDataSources

class ProfilePlaylistsViewController: CommonViewController {
    
    private let viewModel = ProfilePlaylistsViewModel()
    private var loadingVC: UIViewController?
    
    @IBOutlet var profileNavigationBar: ProfileNavigationBar! {
        didSet {
            profileNavigationBar.backgroundColor = .clear
        }
    }
    
    @IBOutlet var searchView: SearchView! {
        didSet {
            searchView.backgroundColor = .white
            searchView.cornerRadius(with: 10)
            searchView.applyShadow(radius: 5)
        }
    }
    
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.backgroundColor = .clear
            collectionView.register(PlaylistCell.instantiate(), forCellWithReuseIdentifier: PlaylistCell.identifier)
            collectionView.register(HeaderTitleView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderTitleView.identifier)
            collectionView.alwaysBounceVertical = true
            setupCompositionalLayout()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSource()
        profileNavigationBar.configure(
            model: .init(
                leftButtonHandler: {[weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }, rightButtonModel: .init(title: nil, image: .addPlaylist), rightButtonHandler: { [weak self] in
                    // TODO: ADD PLAYLIST
                    self?.pushAddPlaylistVC()
                }
            )
        )
    }
    
    override func setupBinding() {
        super.setupBinding()
        let refreshControl = UIRefreshControl()
        collectionView.refreshControl = refreshControl
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe { [weak self] event in
                self?.viewModel.search()
            }
            .disposed(by: disposeBag)
        
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
        
        viewModel.selectedPlaylistObservable
            .subscribe { [weak self] playlist in
                self?.goToPlaylist(playlist: playlist)
            }
            .disposed(by: disposeBag)
        
        viewModel.editPlaylistObservable
            .distinctUntilChanged()
            .subscribe { [weak self] playlist in
                self?.pushAddPlaylistVC(playlist: playlist)
            }
            .disposed(by: disposeBag)
        
        viewModel.loadingObservable
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
    }
    
    private func goToPlaylist(playlist: Playlist) {
        let playlistVC = PlaylistViewController.instantiate(from: .playlist) as! PlaylistViewController
        navigationController?.pushViewController(playlistVC, animated: true)
        playlistVC.setPlaylist(playlist: playlist)
    }
    
    private func pushAddPlaylistVC(playlist: Playlist? = nil) {
        let playlistVC = AddPlaylistViewController.instantiate(from: .addPlaylist) as! AddPlaylistViewController
        navigationController?.pushViewController(playlistVC, animated: true)
        playlistVC.loadViewIfNeeded()
        playlistVC.configure(playlist: playlist)
    }
    
    private func setupDataSource() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<ProfilePlaylistsViewModel.Section>(configureCell: { dataSource, collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaylistCell.identifier, for: indexPath) as! PlaylistCell
                cell.configure(model: item)
                return cell
            }, configureSupplementaryView: { dataSource, collectionView, title, indexPath in
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: title, withReuseIdentifier: HeaderTitleView.identifier, for: indexPath) as! HeaderTitleView
                view.configure(title: dataSource.sectionModels[indexPath.section].title ?? "")
                return view
            })
        
        viewModel.dataSource.asObservable()
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
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
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.40))
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
