//
//  PlayerOptionViewModel.swift
//  Magus
//
//  Created by Jomz on 11/2/23.
//

import Foundation
import RxSwift
import RxRelay

class PlayerOptionViewModel: ViewModel {
    
    private let subliminalUseCase: SubliminalUseCase
    private let playlistUseCase: PlaylistUseCase
    private let store: Store
    var playlistId: String?
    var subliminal: Subliminal?
    var isLikeRelay = BehaviorRelay<Bool>(value: false)
    var isLikedObservable: Observable<Bool> { isLikeRelay.asObservable() }
    private let loadingRelay = BehaviorRelay<Bool>(value: true)
    private let alertRelay = PublishRelay<AlertModel>()
    private let backRelay = PublishRelay<Void>()
    var backObservable: Observable<Void> { backRelay.asObservable() }
    var loadingObservable: Observable<Bool> { loadingRelay.asObservable() }
    var alertObservable: Observable<AlertModel> { alertRelay.asObservable() }
    
    init(dependencies: PlayerOptionViewModel.Dependencies = .standard) {
        store = dependencies.store
        subliminalUseCase = dependencies.subliminalUseCase
        playlistUseCase = dependencies.playlistUseCase
    }
    
    func updateFavorite() {
        guard let selectedSubliminal = subliminal else { return }
        Task {
            do {
                var subliminal = selectedSubliminal
                subliminal.isLiked = subliminal.isLiked == 0 ? 1 : 0
                if selectedSubliminal.isLiked == 0 {
                    let _ = try await subliminalUseCase.addToFavorite(id: selectedSubliminal.subliminalID)
                    Logger.info("Successfully added to favorite", topic: .presentation)
                } else {
                    let _ = try await subliminalUseCase.deleteToFavorite(id: selectedSubliminal.subliminalID)
                    Logger.info("Successfully removed from favorite", topic: .presentation)
                }
                isLikeRelay.accept(subliminal.isLiked == 1)
                self.subliminal = subliminal
            } catch {
                Logger.info("Failed to update favorite \(error)", topic: .presentation)
            }
        }
    }
    
    func removeSubliminalToPlaylist() {
        guard let subliminalId = subliminal?.subliminalID, let playlistId = playlistId else {
            return
        }
        alertRelay.accept(.loading(true))
        Task {
            do {
                let message = try await playlistUseCase.deleteSubliminalToPlaylist(playlistId: playlistId, subliminalId: subliminalId)
                Logger.info(message.message, topic: .presentation)
                alertRelay.accept(
                    .alertModal(.init(
                        title: "",
                        message: message.message,
                        actionHandler: { [weak self] in
                            self?.backRelay.accept(())
                        }
                    ))
                )
            } catch MessageError.message(let message){
                alertRelay.accept(
                    .alertModal(.init(
                        title: "",
                        message: message,
                        actionHandler: { }
                    ))
                )
                Logger.warning("Network Error Response - \(message)", topic: .presentation)
            }
        }
    }
     
}

extension PlayerOptionViewModel {
    
    struct Dependencies {
        let store: Store
        let user: () -> User?
        let subliminalUseCase: SubliminalUseCase
        let playlistUseCase: PlaylistUseCase
        
        static var standard: Dependencies {
            return .init(
                store: SharedDependencies.sharedDependencies.store,
                user: { SharedDependencies.sharedDependencies.store.appState.user },
                subliminalUseCase: SharedDependencies.sharedDependencies.useCases.subliminalUseCase,
                playlistUseCase: SharedDependencies.sharedDependencies.useCases.playlistUseCase
            )
        }
    }
    
}
