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
    let playlistIdRelay = BehaviorRelay<String?>(value: nil)
    let subliminalRelay = BehaviorRelay<Subliminal?>(value: nil)
    private let isLikeRelay = BehaviorRelay<Bool>(value: false)
    var isLikedObservable: Observable<Bool> { isLikeRelay.asObservable() }
    private let loadingRelay = BehaviorRelay<Bool>(value: true)
    private let alertRelay = PublishRelay<AlertModelEnum>()
    private let backRelay = PublishRelay<Void>()
    var backObservable: Observable<Void> { backRelay.asObservable() }
    var loadingObservable: Observable<Bool> { loadingRelay.asObservable() }
    var alertObservable: Observable<AlertModelEnum> { alertRelay.asObservable() }
    
    private let addedToQueuePublisher = PublishRelay<Bool>()
    var addedToQueueObservable: Observable<Bool> { addedToQueuePublisher.asObservable()}
    let queueSubliminal: () -> [Subliminal]
    let addedSubliminal: () -> [Subliminal]
    
    init(dependencies: PlayerOptionViewModel.Dependencies = .standard) {
        store = dependencies.store
        subliminalUseCase = dependencies.subliminalUseCase
        playlistUseCase = dependencies.playlistUseCase
        queueSubliminal = dependencies.queueSubliminal
        addedSubliminal = dependencies.addedQueue
        
    }
    
    func configure(subliminal: Subliminal, playlistId: String?) {
        subliminalRelay.accept(subliminal)
        playlistIdRelay.accept(playlistId)
        isLikeRelay.accept(subliminal.isLiked == 1)
        
        let alreadyInQueue = addedSubliminal().contains(where: { $0.id == subliminal.id })
        addedToQueuePublisher.accept(alreadyInQueue)
    }
    
    func updateFavorite() {
        guard let selectedSubliminal = subliminalRelay.value else { return }
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
                self.subliminalRelay.accept(subliminal)
            } catch {
                Logger.info("Failed to update favorite \(error)", topic: .presentation)
            }
        }
    }
    
    func removeSubliminalToPlaylist() {
        guard let subliminalId = subliminalRelay.value?.subliminalID, let playlistId = playlistIdRelay.value else {
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
    
    func addToQueueSubliminal() {
        guard let subliminal = subliminalRelay.value,
              queueSubliminal().first(where: { $0.id == subliminal.id }) == nil,
              addedSubliminal().first(where: { $0.id == subliminal.id }) == nil else {
            return
        }
        store.appState.addedQueue.append(subliminal)
        addedToQueuePublisher.accept(true)
        alertRelay.accept(.alertModal(
            AlertViewModel(
                title: "",
                message: "Added to Queue",
                actionHandler: {
                
                }
            )
        ))
    }
     
}

extension PlayerOptionViewModel {
    
    struct Dependencies {
        let store: Store
        let user: () -> User?
        let subliminalUseCase: SubliminalUseCase
        let playlistUseCase: PlaylistUseCase
        let queueSubliminal: () -> [Subliminal]
        let addedQueue: () -> [Subliminal]
        
        static var standard: Dependencies {
            return .init(
                store: SharedDependencies.sharedDependencies.store,
                user: { SharedDependencies.sharedDependencies.store.appState.user },
                subliminalUseCase: SharedDependencies.sharedDependencies.useCases.subliminalUseCase,
                playlistUseCase: SharedDependencies.sharedDependencies.useCases.playlistUseCase,
                queueSubliminal: { SharedDependencies.sharedDependencies.store.appState.subliminalQueue },
                addedQueue: { SharedDependencies.sharedDependencies.store.appState.addedQueue }
            )
        }
    }
    
}
