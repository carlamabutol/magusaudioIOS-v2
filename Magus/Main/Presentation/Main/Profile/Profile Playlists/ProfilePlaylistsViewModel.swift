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
    
    private let playlistUseCase: PlaylistUseCase
    let sections = BehaviorRelay<[SectionViewModel]>(value: [])
    private let magusPlaylistRelay = PublishRelay<[Playlist]>()
    private let ownPlaylistRelay = PublishRelay<[Playlist]>()
    private let searchRelay = BehaviorRelay<String>(value: "")
    private let searchDebounceTime: RxTimeInterval
    private let selectedPlaylist = PublishRelay<Playlist>()
    private let editPlaylist = PublishRelay<Playlist>()
    private let loadingRelay = BehaviorRelay<Bool>(value: true)
    let fullScreenLoadingRelay = PublishRelay<Bool>()
    var loadingObservable: Observable<Bool> { loadingRelay.asObservable() }
    var selectedPlaylistObservable: Observable<Playlist> { selectedPlaylist.asObservable()}
    var editPlaylistObservable: Observable<Playlist> { editPlaylist.asObservable()}
    let dataSource = BehaviorRelay<[Section]>(value: [])
    
    init(dependencies: ProfilePlaylistsViewModel.Dependencies = .standard) {
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
        let groupedPlaylist = Set(playlist.compactMap { $0.isOwnPlaylist })
        return groupedPlaylist
            .sorted(by: { $0 > $1 })
            .map { isOwnPlaylist in
                let title = PlaylistGroupTitle(rawValue: isOwnPlaylist)?.title
                let cellModels = playlist
                    .filter({ $0.isOwnPlaylist == isOwnPlaylist })
                    .map { [weak self] playlist in
                        PlaylistCell.Model(imageUrl: URL(string: playlist.cover), title: playlist.title, tapHandler: {
                            self?.selectedPlaylist.accept(playlist)
                        }) {
                            self?.editPlaylist.accept(playlist)
                        }
                    }
                return Section(items: cellModels, title: title)
            }
    }
    
    private func constructOwnPlaylistSection(playlist: [Playlist]) -> [Section] {
        let cellModels = playlist
            .map { [weak self] playlist in
                let cellModel = PlaylistCell.Model(imageUrl: URL(string: playlist.cover), title: playlist.title, tapHandler: {
                            self?.selectedPlaylist.accept(playlist)
                        })
                return cellModel
            }
        return [.init(items: cellModels, title: PlaylistGroupTitle.isOwnPlaylist.title)]
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
                searchDebounceTime: .milliseconds(200)
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
