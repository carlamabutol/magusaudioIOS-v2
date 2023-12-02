//
//  AddToPlaylistViewModel.swift
//  Magus
//
//  Created by Jomz on 11/14/23.
//

import Foundation
import RxSwift
import RxRelay
import Differentiator

class AddToPlaylistViewModel: ViewModel {
    
    let sections = BehaviorRelay<[SectionViewModel]>(value: [])
    var subliminal: Subliminal?
    private let store: Store
    private let playlistUseCase: PlaylistUseCase
    private let magusPlaylistRelay = PublishRelay<[Playlist]>()
    private let searchRelay = BehaviorRelay<String>(value: "")
    private let searchDebounceTime: RxTimeInterval
    private let loadingRelay = BehaviorRelay<Bool>(value: true)
    private let alertRelay = PublishRelay<AlertModel>()
    private let backRelay = PublishRelay<Void>()
    var backObservable: Observable<Void> { backRelay.asObservable() }
    var loadingObservable: Observable<Bool> { loadingRelay.asObservable() }
    var alertObservable: Observable<AlertModel> { alertRelay.asObservable() }
    let fullScreenLoadingRelay = PublishRelay<Bool>()
    let dataSource = BehaviorRelay<[Section]>(value: [])
    
    init(dependencies: AddToPlaylistViewModel.Dependencies = .standard) {
        store = dependencies.store
        playlistUseCase = dependencies.playlistUseCase
        searchDebounceTime = dependencies.searchDebounceTime
        super.init()
        
        searchRelay.asObservable()
            .debounce(searchDebounceTime, scheduler: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .subscribe { [weak self] search in
                self?.loadingRelay.accept(true)
                self?.search()
            }
            .disposed(by: disposeBag)
        
        magusPlaylistRelay.asObservable()
            .compactMap { [weak self] in self?.constructDataSource(playlist: $0) }
            .subscribe(onNext: { [weak self] in
                self?.dataSource.accept($0)
                self?.loadingRelay.accept(false)
            })
            .disposed(by: disposeBag)
    }
    
    func search() {
        Task {
            do {
                let playlists = try await playlistUseCase.searchPlaylists(search: searchRelay.value)
                magusPlaylistRelay.accept(playlists)
            } catch {
                Logger.warning("Network Error Response - \(error.localizedDescription)", topic: .presentation)
            }
            
        }
    }
    
    func setSearchFilter(_ search: String) {
        self.searchRelay.accept(search)
    }
    
    private func constructDataSource(playlist: [Playlist]) -> [Section] {
        let cellModels = playlist
            .map { [weak self] playlist in
                let subtitle = "\(playlist.subliminals.count) Subliminals"
                return AddToPlaylistCell.Model(imageUrl: URL(string: playlist.cover), title: playlist.title, subtitle: subtitle, tapHandler: {
                    self?.addSubliminalToPlaylist(playlistId: playlist.playlistID)
                })
            }
        return [.init(items: cellModels, title: PlaylistGroupTitle.isOwnPlaylist.title)]
    }
    
    private func addSubliminalToPlaylist(playlistId: String) {
        guard let subliminalId = subliminal?.subliminalID else {
            return
        }
        alertRelay.accept(.loading(true))
        Task {
            do {
                let message = try await playlistUseCase.addSubliminalToPlaylist(playlistId: playlistId, subliminalId: subliminalId)
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

extension AddToPlaylistViewModel {
    
    struct Dependencies {
        let store: Store
        let playlistUseCase: PlaylistUseCase
        let searchDebounceTime: RxTimeInterval
        
        static var standard: Dependencies {
            .init(
                store: SharedDependencies.sharedDependencies.store,
                playlistUseCase: SharedDependencies.sharedDependencies.useCases.playlistUseCase,
                searchDebounceTime: .milliseconds(200)
            )
        }
    }
    
    struct Section: SectionModelType {
        
        typealias Item = AddToPlaylistCell.Model
        
        var items: [Item]
        var title: String?
        
        init(items: [Item], title: String? = nil) {
            self.items = items
            self.title = title
        }
        
        init(original: AddToPlaylistViewModel.Section, items: [Item]) {
            self = original
            self.items = items
        }
    }
    
    enum PlaylistGroupTitle: Int {
        case madeByMagus
        case isOwnPlaylist
        
        var title: String {
            switch self {
            case .madeByMagus: return "Made By Magus"
            case .isOwnPlaylist: return "My Playlist"
            }
        }
    }
}
