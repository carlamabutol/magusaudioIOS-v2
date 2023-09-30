//
//  ProfilePlaylistsViewModel.swift
//  Magus
//
//  Created by Jose Mari Pascual on 9/24/23.
//

import Foundation
import RxSwift
import RxRelay
import Differentiator

class ProfilePlaylistsViewModel: ViewModel {
    
    
    enum SearchSection {
        case subliminal
        case playlist
        
        var title: String {
            switch self {
            case .subliminal:
                return LocalizedStrings.SearchHeaderTitle.subliminal
            case .playlist:
                return LocalizedStrings.SearchHeaderTitle.playlist
            }
        }
    }
    
    let sections = BehaviorRelay<[SectionViewModel]>(value: [])
    let playlistRelay = BehaviorRelay<[Playlist]>(value: [])
    private let searchRelay = BehaviorRelay<String>(value: "")
    private let playlistUseCase: PlaylistUseCase
    private let searchDebounceTime: RxTimeInterval
    private let selectedPlaylist = PublishRelay<Playlist>()
    var selectedPlaylistObservable: Observable<Playlist> { selectedPlaylist.asObservable()}
    let dataSource = BehaviorRelay<[Section]>(value: [])
    
    init(dependencies: ProfilePlaylistsViewModel.Dependencies = .standard) {
        playlistUseCase = dependencies.playlistUseCase
        searchDebounceTime = dependencies.searchDebounceTime
        super.init()
        
        searchRelay.asObservable()
            .debounce(searchDebounceTime, scheduler: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .subscribe { [weak self] search in
                self?.search()
            }
            .disposed(by: disposeBag)
        
        playlistRelay.asObservable()
            .compactMap { [weak self] in self?.constructDataSource(playlist: $0) }
            .subscribe(onNext: { [weak self] in
                self?.dataSource.accept($0)
            })
            .disposed(by: disposeBag)
    }
    
    private func search() {
        Task {
            do {
                let playlists = try await playlistUseCase.searchPlaylists(search: searchRelay.value)
                Logger.info("Playlists - \(playlists)", topic: .presentation)
                playlistRelay.accept(playlists)
            } catch {
                debugPrint("Network Error Response - \(error.localizedDescription)")
            }
            
        }
    }
    
    func setSearchFilter(_ search: String) {
        self.searchRelay.accept(search)
    }
    
    private func constructDataSource(playlist: [Playlist]) -> [Section] {
        let groupedPlaylist = Set(playlist.compactMap { $0.isOwnPlaylist })
        return groupedPlaylist
            .map { isOwnPlaylist in
                let title = PlaylistGroupTitle(rawValue: isOwnPlaylist)?.title
                let cellModels = playlist
                    .filter({ $0.isOwnPlaylist == isOwnPlaylist })
                    .map { [weak self] playlist in
                        PlaylistCell.Model(imageUrl: URL(string: playlist.cover), title: playlist.title, tapHandler: {
                            self?.selectedPlaylist.accept(playlist)
                        })
                    }
                return Section(items: cellModels, title: title)
            }
    }
    
}

extension ProfilePlaylistsViewModel {
    
    struct Dependencies {
        let store: Store
        let playlistUseCase: PlaylistUseCase
        let searchDebounceTime: RxTimeInterval
        
        static var standard: Dependencies {
            .init(
                store: SharedDependencies.sharedDependencies.store,
                playlistUseCase: SharedDependencies.sharedDependencies.useCases.playlistUseCase,
                searchDebounceTime: .milliseconds(100)
            )
        }
    }
    
    struct Section: SectionModelType {
        
        typealias Item = PlaylistCell.Model
        
        var items: [PlaylistCell.Model]
        var title: String?
        
        init(items: [PlaylistCell.Model], title: String? = nil) {
            self.items = items
            self.title = title
        }
        
        init(original: ProfilePlaylistsViewModel.Section, items: [PlaylistCell.Model]) {
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
