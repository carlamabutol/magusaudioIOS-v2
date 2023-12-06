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
    private let updatedSubliminalRelay = PublishRelay<Subliminal>()
    private let updatedPlaylistRelay = PublishRelay<Playlist>()
    private let subliminalsRelay = BehaviorRelay<[Subliminal]>(value: [])
    private let playlistRelay = BehaviorRelay<[Playlist]>(value: [])
    private let firstSubliminalRelay = PublishRelay<Subliminal>()
    private let selectedPlaylistRelay = PublishRelay<Playlist>()
    private let selectedOptionRelay = PublishRelay<Subliminal>()
    private let subliminalCellModelRelay = BehaviorRelay<[FavoriteSubliminalCollectionViewCell.SubliminalCellModel]>(value: [])
    var subliminalsObservable: Observable<[FavoriteSubliminalCollectionViewCell.SubliminalCellModel]> { subliminalCellModelRelay.asObservable() }
    private let playlistCellModelRelay = BehaviorRelay<[FavoritePlaylistCell.Model]>(value: [])
    var playlistObservable: Observable<[FavoritePlaylistCell.Model]> { playlistCellModelRelay.asObservable() }
    var firstSubliminalObservable: Observable<Subliminal> { firstSubliminalRelay.asObservable() }
    var selectedPlaylistObservable: Observable<Playlist> { selectedPlaylistRelay.asObservable() }
    var selectedOptionObservable: Observable<Subliminal> { selectedOptionRelay.asObservable() }
    
    let tabSelectionModel = [
        TabSelectionView.TabSelectionModel(index: 0, title: "Subs"),
        TabSelectionView.TabSelectionModel(index: 1, title: "Playlist")
    ]
    
    init(dependencies: ProfileFavoritesViewModel.Dependencies = .standard) {
        store = dependencies.store
        subliminalUseCase = dependencies.subliminalUseCase
        playlistUseCase = dependencies.playlistUseCase
        super.init()
        
        // Needed to add a listener from the selectedSubliminal so we can update the status on the subliminal list
        dependencies.subminalObservable
            .distinctUntilChanged()
            .subscribe { [weak self] subliminal in
                self?.updatedSubliminalRelay.accept(subliminal)
            }
            .disposed(by: disposeBag)
        
        updatedSubliminalRelay.asObservable()
            .compactMap { [weak self] updatedSubliminal in
                let newSubliminals = self?.subliminalsRelay.value.map { subliminal in
                    var newSubliminal = subliminal
                    let isLiked = subliminal.subliminalID == updatedSubliminal.subliminalID ? updatedSubliminal.isLiked : subliminal.isLiked
                    newSubliminal.isLiked = isLiked
                    return newSubliminal
                }
                return newSubliminals
            }
            .map { self.setupSubliminalCellModels(subliminals: $0) }
            .subscribe { [weak self] subliminalCells in
                self?.subliminalCellModelRelay.accept(subliminalCells)
            }
            .disposed(by: disposeBag)
        
        updatedPlaylistRelay.asObservable()
            .compactMap { [weak self] updatedPlaylist in
                let newPlaylists = self?.playlistRelay.value.map { playlist in
                    var newPlaylist = playlist
                    let isLiked = playlist.playlistID == updatedPlaylist.playlistID ? updatedPlaylist.isLiked : playlist.isLiked
                    newPlaylist.isLiked = isLiked
                    return newPlaylist
                }
                return newPlaylists
            }
            .map { self.setupPlaylistCellModels(playlists: $0) }
            .subscribe { [weak self] playlistCells in
                self?.playlistCellModelRelay.accept(playlistCells)
            }
            .disposed(by: disposeBag)
        
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
        store.appState.subliminalQueue = subliminalsRelay.value
        store.appState.selectedSubliminal = subliminal
    }
    
    func selectedPlaylist(for indexPath: IndexPath)  {
        let playlist = playlistRelay.value[indexPath.row]
        selectedPlaylistRelay.accept(playlist)
    }
    
    private func setupSubliminalCellModels(subliminals: [Subliminal]) -> [FavoriteSubliminalCollectionViewCell.SubliminalCellModel] {
        subliminals.map { [weak self] subliminal in
            FavoriteSubliminalCollectionViewCell.SubliminalCellModel(
                id: subliminal.subliminalID,
                title: subliminal.title,
                imageUrl: URL(string: subliminal.cover),
                duration: subliminal.info.map { $0.duration }.max()?.toMinuteAndSeconds() ?? "",
                isFavorite: subliminal.isLiked == 1,
                favoriteButtonHandler: { [weak self] in
                    self?.favoriteButtonIsTapped(subliminal)
                },
                optionActionHandler: { [weak self] in
                    self?.selectedOptionRelay.accept(subliminal)
                })
        }
    }
    
    private func setupPlaylistCellModels(playlists: [Playlist]) -> [FavoritePlaylistCell.Model] {
        playlists.map { [weak self] playlist in
            FavoritePlaylistCell.Model(
                id: playlist.playlistID,
                title: playlist.title,
                imageUrl: URL(string: playlist.cover),
                duration: "--:--",
                description: playlist.description ?? "-",
                isFavorite: playlist.isLiked == 1,
                favoriteButtonHandler: { [weak self] in
                    self?.favoriteButtonIsTapped(playlist)
                }
            )
        }
    }
    
    private func favoriteButtonIsTapped(_ subliminal: Subliminal) {
        var updatedSubliminal = subliminal
        updatedSubliminal.isLiked = subliminal.isLiked == 0 ? 1 : 0
        updatedSubliminalRelay.accept(updatedSubliminal)
        store.appState.selectedSubliminal = updatedSubliminal
        updateFavorite(updatedSubliminal)
    }
    
    private func favoriteButtonIsTapped(_ playlist: Playlist) {
        var updatedPlaylist = playlist
        updatedPlaylist.isLiked = playlist.isLiked == 0 ? 1 : 0
        updatedPlaylistRelay.accept(updatedPlaylist)
        updateFavorite(updatedPlaylist)
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
    
    func updateFavorite(_ selectedSubliminal: Subliminal) {
        Task {
            do {
                if selectedSubliminal.isLiked == 0 {
                    let _ = try await subliminalUseCase.deleteToFavorite(id: selectedSubliminal.subliminalID)
                    Logger.info("Successfully removed from favorite", topic: .presentation)
                } else {
                    let _ = try await subliminalUseCase.addToFavorite(id: selectedSubliminal.subliminalID)
                    Logger.info("Successfully added to favorite", topic: .presentation)
                }
            } catch {
                Logger.info("Failed to update favorite \(error)", topic: .presentation)
            }
        }
    }
    
    func updateFavorite(_ selectedPlaylist: Playlist) {
        Task {
            do {
                if selectedPlaylist.isLiked == 0 {
                    let _ = try await playlistUseCase.addToFavorite(id: selectedPlaylist.playlistID)
                    Logger.info("Successfully added to favorite", topic: .presentation)
                } else {
                    let _ = try await playlistUseCase.deletePlaylist(id: selectedPlaylist.playlistID)
                    Logger.info("Successfully removed from favorite", topic: .presentation)
                }
            } catch {
                Logger.info("Failed to update favorite \(error)", topic: .presentation)
            }
        }
    }
    
    private func addToFavorite(id: String) {
        Task {
            do {
                _ = try await playlistUseCase.addToFavorite(id: id)
                Logger.info("Successfully added playlist to favorite", topic: .presentation)
            } catch {
                Logger.info("Failed to update favorite \(error)", topic: .presentation)
            }
        }
    }
    
    private func removeToFavorite(id: String) {
        Task {
            do {
                _ = try await playlistUseCase.deleteToFavorite(id: id)
                Logger.info("Successfully removed from favorite", topic: .presentation)
            } catch {
                Logger.info("Failed to update favorite \(error)", topic: .presentation)
            }
        }
    }
    
}

extension ProfileFavoritesViewModel {
    
    struct Dependencies {
        let store: Store
        let subliminalUseCase: SubliminalUseCase
        let playlistUseCase: PlaylistUseCase
        let subminalObservable: Observable<Subliminal>
        
        static var standard: Dependencies {
            return .init(
                store: SharedDependencies.sharedDependencies.store,
                subliminalUseCase: SharedDependencies.sharedDependencies.useCases.subliminalUseCase,
                playlistUseCase: SharedDependencies.sharedDependencies.useCases.playlistUseCase,
                subminalObservable: SharedDependencies.sharedDependencies.store.observable(of: \.selectedSubliminal).compactMap({ $0 })
            )
        }
    }
    
}
