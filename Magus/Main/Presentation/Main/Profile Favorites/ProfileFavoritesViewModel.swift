//
//  ProfileFavoritesViewModel.swift
//  Magus
//
//  Created by Jose Mari Pascual on 9/23/23.
//

import Foundation
import RxSwift
import RxRelay

class ProfileFavoritesViewModel: ViewModel {
    
    private let store: Store
    private let subliminalUseCase: SubliminalUseCase
    private let playlistUseCase: PlaylistUseCase
    private let subliminalsRelay = BehaviorRelay<[Subliminal]>(value: [])
    private let playlistRelay = BehaviorRelay<[Playlist]>(value: [])
    private let firstSubliminalRelay = PublishRelay<Subliminal>()
    private let selectedPlaylistRelay = PublishRelay<Playlist>()
    private let subliminalCellModelRelay = BehaviorRelay<[SubliminalCollectionViewCell.SubliminalCellModel]>(value: [])
    var subliminalsObservable: Observable<[SubliminalCollectionViewCell.SubliminalCellModel]> { subliminalCellModelRelay.asObservable() }
    private let playlistCellModelRelay = BehaviorRelay<[SubliminalCollectionViewCell.SubliminalCellModel]>(value: [])
    var playlistObservable: Observable<[SubliminalCollectionViewCell.SubliminalCellModel]> { playlistCellModelRelay.asObservable() }
    var firstSubliminalObservable: Observable<Subliminal> { firstSubliminalRelay.asObservable() }
    var selectedPlaylistObservable: Observable<Playlist> { selectedPlaylistRelay.asObservable() }
    
    let tabSelectionModel = [
        TabSelectionView.TabSelectionModel(index: 0, title: "Subs"),
        TabSelectionView.TabSelectionModel(index: 1, title: "Playlist")
    ]
    
    init(dependencies: ProfileFavoritesViewModel.Dependencies = .standard) {
        store = dependencies.store
        subliminalUseCase = dependencies.subliminalUseCase
        playlistUseCase = dependencies.playlistUseCase
        super.init()
        
        subliminalsRelay.asObservable()
            .map { self.setupSubliminalCellModels(subliminals: $0) }
            .subscribe { [weak self] subliminalCells in
                self?.subliminalCellModelRelay.accept(subliminalCells)
            }
            .disposed(by: disposeBag)
        
        playlistRelay.asObservable()
            .map { self.setupPlaylistCellModels(playlists: $0) }
            .subscribe { [weak self] cells in
                self?.playlistCellModelRelay.accept(cells)
            }
            .disposed(by: disposeBag)
    }
    
    func selectedSubliminal(_ indexPath: IndexPath) {
        let subliminal = subliminalsRelay.value[indexPath.row]
        store.appState.subliminals = subliminalsRelay.value
        store.appState.selectedSubliminal = subliminal
    }
    
    func selectedPlaylist(for indexPath: IndexPath)  {
        let playlist = playlistRelay.value[indexPath.row]
        selectedPlaylistRelay.accept(playlist)
    }
    
    private func setupSubliminalCellModels(subliminals: [Subliminal]) -> [SubliminalCollectionViewCell.SubliminalCellModel] {
        subliminals.map { [weak self] subliminal in
            SubliminalCollectionViewCell.SubliminalCellModel(
                id: subliminal.subliminalID,
                title: subliminal.title,
                imageUrl: URL(string: subliminal.cover),
                duration: subliminal.info.map { $0.duration }.max()?.toMinuteAndSeconds() ?? "",
                isFavorite: subliminal.isLiked == 1,
                favoriteButtonHandler: { [weak self] in
//                    self?.favoriteButtonIsTapped(subliminal)
                }
            )
        }
    }
    
    private func setupPlaylistCellModels(playlists: [Playlist]) -> [SubliminalCollectionViewCell.SubliminalCellModel] {
        playlists.map { [weak self] playlist in
            SubliminalCollectionViewCell.SubliminalCellModel(
                id: playlist.playlistID,
                title: playlist.title,
                imageUrl: URL(string: playlist.cover),
                duration: "",
                isFavorite: playlist.isLiked == 1,
                favoriteButtonHandler: { [weak self] in
//                    self?.favoriteButtonIsTapped(subliminal)
                }
            )
        }
    }
    
    func getAllPlaylistFavorites() {
        Task {
            do {
                let playlists = try await playlistUseCase.getAllLikePlaylist()
                playlistRelay.accept(playlists)
            } catch {
                Logger.warning("Failed to fetch all playlist subliminals \(error.localizedDescription)", topic: .presentation)
            }
        }
    }
    
    func getAllSubliminalFavorites() {
        Task {
            do {
                let subliminals = try await subliminalUseCase.getAllLikeSubliminal()
                subliminalsRelay.accept(subliminals)
                if subliminals.count > 0 {
                    firstSubliminalRelay.accept(subliminals.first!)
                }
            } catch {
                Logger.warning("Failed to fetch all favorite subliminals \(error.localizedDescription)", topic: .presentation)
            }
        }
    }
    
}

extension ProfileFavoritesViewModel {
    
    struct Dependencies {
        let store: Store
        let subliminalUseCase: SubliminalUseCase
        let playlistUseCase: PlaylistUseCase
        
        static var standard: Dependencies {
            return .init(
                store: SharedDependencies.sharedDependencies.store,
                subliminalUseCase: SharedDependencies.sharedDependencies.useCases.subliminalUseCase,
                playlistUseCase: SharedDependencies.sharedDependencies.useCases.playlistUseCase
            )
        }
    }
    
}
