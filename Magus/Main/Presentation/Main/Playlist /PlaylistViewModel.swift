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
    
    private var playlist: Playlist?
    private let playlistRelay = BehaviorRelay<Playlist?>(value: nil)
    var playlistObservable: Observable<Playlist> { playlistRelay.compactMap { $0 }.asObservable() }
    
    private let subliminalCellModelRelay = BehaviorRelay<[SublimincalCellModel]>(value: [])
    var subliminalCellModelObservable: Observable<[SublimincalCellModel]> { subliminalCellModelRelay.asObservable() }
    private let updatedSubliminalRelay = PublishRelay<Subliminal>()
    
    init(dependencies: PlaylistViewModel.Dependencies = .standard) {
        store = dependencies.store
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
    
    private func setupSubliminalCellModels(subliminals: [Subliminal]) -> [SublimincalCellModel] {
        subliminals.map { [weak self] subliminal in
            SublimincalCellModel(
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
    
    func selectedSubliminal(_ indexPath: IndexPath) {
        let subliminal = playlist?.subliminals[indexPath.row]
        store.appState.selectedSubliminal = subliminal
    }
    
}

extension PlaylistViewModel {
    
    struct Dependencies {
        let store: Store
        let user: () -> User?
        let router: Router
        let networkService: NetworkService
        let authenticationUseCase: AuthenticationUseCase
        
        static var standard: Dependencies {
            return .init(
                store: SharedDependencies.sharedDependencies.store,
                user: { SharedDependencies.sharedDependencies.store.appState.user },
                router: SharedDependencies.sharedDependencies.router,
                networkService: SharedDependencies.sharedDependencies.networkService,
                authenticationUseCase: SharedDependencies.sharedDependencies.useCases.authenticationUseCase
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
