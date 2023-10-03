//
//  AddPlaylistViewModel.swift
//  Magus
//
//  Created by Jose Mari Pascual on 9/30/23.
//

import Foundation
import RxRelay
import RxSwift

class AddPlaylistViewModel: ViewModel {
    private let playlistUseCase: PlaylistUseCase
    var playlistID: String? = nil
    private let isLoadingRelay = PublishRelay<Bool>()
    private let alertRelay = PublishRelay<AlertViewModel>()
    private let backRelay = PublishRelay<Void>()
    let optionRelay = BehaviorRelay<[PlaylistOptionCell.Model]>(value: PlaylistOptionCell.options)
    var isLoadingObservable: Observable<Bool> { isLoadingRelay.asObservable() }
    var alertObservable: Observable<AlertViewModel> { alertRelay.asObservable() }
    var backObservable: Observable<Void> { backRelay.asObservable() }
    let playlistTitle = BehaviorRelay<String>(value: "")
    
    init(dependencies: AddPlaylistViewModel.Dependencies = .standard) {
        playlistUseCase = dependencies.playlistUseCase
        super.init()
        
    }
    
    func addPlaylist() {
        isLoadingRelay.accept(true)
        if let playlistID = playlistID {
            savePlaylist(playlistID: playlistID)
            return
        }
        Task {
            do {
                _ = try await playlistUseCase.addPlaylist(title: playlistTitle.value)
                Logger.info("Added to playlist succesfully.", topic: .presentation)
                alertRelay.accept(
                    .init(
                        title: "",
                        message: "Added to playlist succesfully.",
                        actionHandler: { [weak self] in self?.backRelay.accept(())}
                    )
                )
            } catch MessageError.message(let message){
                alertRelay.accept(
                    .init(
                        title: "",
                        message: message,
                        actionHandler: { }
                    )
                )
                Logger.warning("Failed to add Playlist \(message)", topic: .presentation)
            }
            isLoadingRelay.accept(false)
        }
    }
    
    func savePlaylist(playlistID: String) {
        Task {
            do {
                _ = try await playlistUseCase.savePlaylist(playlistID: playlistID, title: playlistTitle.value)
                alertRelay.accept(
                    .init(
                        title: "",
                        message: "Updated playlist succesfully.",
                        actionHandler: { [weak self] in self?.backRelay.accept(())}
                    )
                )
            } catch MessageError.message(let message){
                alertRelay.accept(
                    .init(
                        title: "",
                        message: message,
                        actionHandler: { }
                    )
                )
                Logger.warning("Failed to add Playlist \(message)", topic: .presentation)
            }
            isLoadingRelay.accept(false)
        }
    }
    
}

extension AddPlaylistViewModel {
    
    struct Dependencies {
        let store: Store
        let playlistUseCase: PlaylistUseCase
        
        static var standard: Dependencies {
            return .init(store: SharedDependencies.sharedDependencies.store,
                         playlistUseCase: SharedDependencies.sharedDependencies.useCases.playlistUseCase)
        }
    }
    
    struct ErrorModel {
        let title: String
        let message: String
        
        init(title: String = "", message: String) {
            self.title = title
            self.message = message
        }
    }
    
}
