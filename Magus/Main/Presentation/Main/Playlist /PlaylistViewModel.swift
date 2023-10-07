//
//  PlaylistViewModel.swift
//  Magus
//
//  Created by Jomz on 9/10/23.
//

import Foundation
import RxRelay
import RxSwift
import RxDataSources

class PlaylistViewModel: ViewModel {
    
    private let store: Store
    private let playlistUseCase: PlaylistUseCase
    
    private var playlist: Playlist?
    private let playlistRelay = BehaviorRelay<Playlist?>(value: nil)
    var playlistObservable: Observable<Playlist> { playlistRelay.compactMap { $0 }.asObservable() }
    
    private let subliminalCellModelRelay = BehaviorRelay<[SubliminalCollectionViewCell.SubliminalCellModel]>(value: [])
    var subliminalCellModelObservable: Observable<[SubliminalCollectionViewCell.SubliminalCellModel]> { subliminalCellModelRelay.asObservable() }
    private let updatedSubliminalRelay = PublishRelay<Subliminal>()
    
    init(dependencies: PlaylistViewModel.Dependencies = .standard) {
        store = dependencies.store
        playlistUseCase = dependencies.playlistUseCase
        super.init()
        
        let subliminalsObservable = updatedSubliminalRelay.asObservable()
            .compactMap { [weak self] updatedSubliminal in
                let newSubliminals = self?.playlist?.subliminals.map { subliminal in
                    var newSubliminal = subliminal
                    let isLiked = subliminal.subliminalID == updatedSubliminal.subliminalID ? updatedSubliminal.isLiked : subliminal.isLiked
                    newSubliminal.isLiked = isLiked
                    return newSubliminal
                }
                self?.playlist?.subliminals = newSubliminals ?? []
                return newSubliminals
            }
        
        playlistObservable
            .map { $0.subliminals }
            .map { self.setupSubliminalCellModels(subliminals: $0) }
            .subscribe { [weak self] subliminalCells in
                self?.subliminalCellModelRelay.accept(subliminalCells)
            }
            .disposed(by: disposeBag)
        
        subliminalsObservable
            .map { self.setupSubliminalCellModels(subliminals: $0) }
            .subscribe { [weak self] subliminalCells in
                self?.subliminalCellModelRelay.accept(subliminalCells)
            }
            .disposed(by: disposeBag)
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
                    self?.favoriteButtonIsTapped(subliminal)
                }
            )
        }
    }

    func setPlaylist(playlist: Playlist) {
        self.playlist = playlist
        playlistRelay.accept(playlist)
    }
    
    private func favoriteButtonIsTapped(_ subliminal: Subliminal) {
        var updatedSubliminal = subliminal
        updatedSubliminal.isLiked = subliminal.isLiked == 0 ? 1 : 0
        updatedSubliminalRelay.accept(updatedSubliminal)
    }
    
    func updatePlaylistFavorite() {
        guard var playlist = playlist else { return }
        playlist.isLiked = playlist.isLiked == 0 ? 1 : 0
        if playlist.isLiked == 1 {
            addToFavorite(id: playlist.playlistID)
        } else {
            removeToFavorite(id: playlist.playlistID)
        }
        self.playlist?.isLiked = playlist.isLiked
        playlistRelay.accept(playlist)
    }
    
    private func addToFavorite(id: String) {
        Task {
            do {
                _ = try await playlistUseCase.addToFavorite(id: id)
                Logger.info("Successfully added to favorite", topic: .presentation)
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
    
    func selectedSubliminal(_ indexPath: IndexPath) {
        let subliminal = playlist?.subliminals[indexPath.row]
        store.appState.selectedSubliminal = subliminal
    }
    
    func playPlaylist() {
        guard let firstSub = playlist?.subliminals.first else { return }
        store.appState.selectedSubliminal = firstSub
    }
    
}

extension PlaylistViewModel {
    
    struct Dependencies {
        let store: Store
        let user: () -> User?
        let playlistUseCase: PlaylistUseCase
        
        static var standard: Dependencies {
            return .init(
                store: SharedDependencies.sharedDependencies.store,
                user: { SharedDependencies.sharedDependencies.store.appState.user },
                playlistUseCase: SharedDependencies.sharedDependencies.useCases.playlistUseCase
            )
        }
    }
    
}

extension PlaylistViewModel {
    
    struct SublimincalCellModel: ItemModel {
        
        var id: String
        var title: String
        var imageUrl: URL?
        let duration: String
        let isFavorite: Bool
        var favoriteButtonHandler: () -> Void
    }
    
    struct SectionViewModel {
        var header: String!
        var items: [SublimincalCellModel]
    }
    
}

extension PlaylistViewModel.SectionViewModel: SectionModelType {
    typealias Item = PlaylistViewModel.SublimincalCellModel
    init(original: PlaylistViewModel.SectionViewModel, items: [PlaylistViewModel.SublimincalCellModel]) {
        self = original
        self.items = items
    }
}
