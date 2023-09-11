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
    
    private var playlist: Playlist?
    private let playlistRelay = BehaviorRelay<Playlist?>(value: nil)
    var playlistObservable: Observable<Playlist> { playlistRelay.compactMap { $0 }.asObservable() }
    
    private let subliminalCellModelRelay = BehaviorRelay<[SublimincalCellModel]>(value: [])
    var subliminalCellModelObservable: Observable<[SublimincalCellModel]> { subliminalCellModelRelay.asObservable() }
    private let updatedSubliminalRelay = BehaviorRelay<Subliminal?>(value: nil)
    private let updatedSubliminalRelay1 = PublishRelay<Subliminal>()
    
    init(dependencies: PlaylistViewModel.Dependencies = .standard) {
        
        super.init()
        
        let subliminalsObservable = updatedSubliminalRelay1.asObservable()
            .compactMap { [weak self] updatedSubliminal in
                self?.playlist?.subliminals.map { subliminal in
                    var newSubliminal = subliminal
                    let isLiked = subliminal.subliminalID == updatedSubliminal.subliminalID ? updatedSubliminal.isLiked : subliminal.isLiked
                    newSubliminal.isLiked = isLiked
                    return newSubliminal
                }
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
                cover: URL(string: subliminal.cover),
                title: subliminal.title,
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
        updatedSubliminalRelay1.accept(updatedSubliminal)
    }
    
}

extension PlaylistViewModel {
    
    struct Dependencies {
        let user: () -> User?
        let router: Router
        let networkService: NetworkService
        let authenticationUseCase: AuthenticationUseCase
        
        static var standard: Dependencies {
            return .init(
                user: { SharedDependencies.sharedDependencies.store.appState.user },
                router: SharedDependencies.sharedDependencies.router,
                networkService: SharedDependencies.sharedDependencies.networkService,
                authenticationUseCase: SharedDependencies.sharedDependencies.useCases.authenticationUseCase
            )
        }
    }
    
}

extension PlaylistViewModel {
    
    struct SublimincalCellModel {
        let id: String
        let cover: URL?
        let title: String
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
