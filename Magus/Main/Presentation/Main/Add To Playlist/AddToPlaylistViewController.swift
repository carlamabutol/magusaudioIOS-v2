//
//  AddToPlaylistViewController.swift
//  Magus
//
//  Created by Jomz on 11/13/23.
//

import UIKit
import RxDataSources
import RxSwift

class AddToPlaylistViewController: CommonViewController {
    
    private let viewModel = AddToPlaylistViewModel()
    private var loadingVC: UIViewController?
    
    @IBOutlet var navigationBar: ProfileNavigationBar! {
        didSet  {
            navigationBar.backgroundColor = .clear
            navigationBar.cornerRadius(with: 5)
            navigationBar.configure(
                model: .init(
                    leftButtonHandler: { [weak self] in
                        self?.navigationController?.popViewController(animated: true)
                    },
                    rightButtonModel: .init(title: "Create New Playlist", image: nil),
                    rightButtonHandler: { [weak self] in
                        self?.pushAddPlaylistVC()
                    }
                )
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
    
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.backgroundColor = .clear
            collectionView.register(AddToPlaylistCell.instantiate(), forCellWithReuseIdentifier: AddToPlaylistCell.identifier)
            collectionView.register(HeaderTitleView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderTitleView.identifier)
            collectionView.alwaysBounceVertical = true
            setupCompositionalLayout()
        }
    }
    
    func configure(subliminal: Subliminal, playlistId: String?) {
        viewModel.subliminal = subliminal
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSource()
    }
    
    override func viewIsAppearing(_ animated: Bool){
        viewModel.search()
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
        
        viewModel.backObservable
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.loadingObservable
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        
        viewModel.alertObservable
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] alertModel in
                switch alertModel {
                case .loading(let isLoading):
                    if isLoading {
                        self?.loadingVC = self?.presentLoading()
                    }
                case .alertModal(let model):
                    if self?.loadingVC == nil {
                        self?.presentAlert(title: model.title, message: model.message, tapOKHandler: model.actionHandler)
                    } else {
                        self?.loadingVC?.dismiss(animated: false, completion: {
                            self?.loadingVC = nil
                            self?.presentAlert(title: model.title, message: model.message, tapOKHandler: model.actionHandler)
                        })
                    }
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    private func goToPlaylist(playlist: Playlist) {
        let playlistVC = PlaylistViewController.instantiate(from: .playlist) as! PlaylistViewController
        navigationController?.pushViewController(playlistVC, animated: true)
        playlistVC.setPlaylist(playlist: playlist)
    }
    
    private func pushAddPlaylistVC(playlist: Playlist? = nil) {
        guard let subliminal = viewModel.subliminalRelay.value else { return }
        let playlistVC = AddPlaylistViewController.instantiate(from: .addPlaylist) as! AddPlaylistViewController
        navigationController?.pushViewController(playlistVC, animated: true)
        playlistVC.loadViewIfNeeded()
        playlistVC.configure(playlist: playlist, subliminal: subliminal)
    }
    
    private func setupDataSource() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<AddToPlaylistViewModel.Section>(configureCell: { dataSource, collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddToPlaylistCell.identifier, for: indexPath) as! AddToPlaylistCell
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(84))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        group.interItemSpacing = .fixed(15)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        section.interGroupSpacing = 15
        section.boundarySupplementaryItems = [
            .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top),
        ]
        return section
    }
}
