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
    var playlist: Playlist? = nil
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
        if let playlistID = playlist?.playlistID {
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
                        actionHandler: { }
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
    
    func toggleFavorite() {
        playlist?.isLiked = playlist?.isLiked == 1 ? 0 : 1
        let isFavorite = playlist?.isLiked == 1
        optionRelay.accept(isFavorite ? PlaylistOptionCell.activeOptions : PlaylistOptionCell.options)
        guard let playlistID = playlist?.playlistID else { return }
        Task {
            do {
                if isFavorite {
                    _ = try await playlistUseCase.deleteToFavorite(id: playlistID)
                } else {
                    _ = try await playlistUseCase.addToFavorite(id: playlistID)
                }
            } catch MessageError.message(let message){
                Logger.warning("Toggle Playlist Favorite \(message)", topic: .presentation)
            }
        }
    }
    
    func savePlaylist(playlistID: String) {
        Task {
            do {
                let response = try await playlistUseCase.savePlaylist(playlistID: playlistID, title: playlistTitle.value)
                alertRelay.accept(
                    .init(
                        title: "",
                        message: response.message,
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
    
    func deletePlaylist() {
        guard let playlistID = playlist?.playlistID else { return }
        isLoadingRelay.accept(true)
        Task {
            do {
                let response = try await playlistUseCase.deletePlaylist(id: playlistID)
                isLoadingRelay.accept(false)
                alertRelay.accept(
                    .init(
                        title: "",
                        message: response.message,
                        actionHandler: { [weak self] in self?.backRelay.accept(())}
                    )
                )
            } catch MessageError.message(let message){
                isLoadingRelay.accept(false)
                alertRelay.accept(
                    .init(
                        title: "",
                        message: message,
                        actionHandler: { }
                    )
                )
                Logger.warning("Failed to add Playlist \(message)", topic: .presentation)
            }
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
