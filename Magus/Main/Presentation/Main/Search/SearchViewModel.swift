//
//  SearchViewModel.swift
//  Magus
//
//  Created by Jomz on 7/2/23.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel: ViewModel {
    
    static let SEARCH_DEBOUNCE_TIME: RxTimeInterval = .milliseconds(500)
    
    enum SearchSection {
        case subliminal
        case playlist
        
        var title: String {
            switch self {
            case .subliminal:
                return LocalisedStrings.SearchHeaderTitle.subliminal
            case .playlist: 
                return LocalisedStrings.SearchHeaderTitle.playlist
            }
        }
    }
    
    let sections = BehaviorRelay<[SectionViewModel]>(value: [])
    let subliminalRelay = BehaviorRelay<[Subliminal]>(value: [])
    let playlistRelay = BehaviorRelay<[Playlist]>(value: [])
    private let selectedSubliminal = PublishRelay<Subliminal>()
    private let selectedPlaylist = PublishRelay<Playlist>()
    private let searchRelay = BehaviorRelay<String>(value: "")
    private let networkService: NetworkService
    var selectedSubliminalObservable: Observable<Subliminal> { selectedSubliminal.asObservable() }
    var selectedPlaylistObservable: Observable<Playlist> { selectedPlaylist.asObservable() }
    
    init(sharedDependencies: SearchViewModel.Dependencies = .standard) {
        networkService = sharedDependencies.networkService
        super.init()
        Observable.combineLatest(subliminalRelay, playlistRelay)
            .map({ [weak self] subliminals, playlists in
                guard let self = self else { return ([ItemModel](), [ItemModel]()) }
                let subliminalCells: [ItemModel]  = subliminals.map { self.configureSubliminalCell(with: $0) }
                let playlistCell: [ItemModel] = playlists.map { self.configurePlaylistCell(with: $0) }
                return (subliminalCells, playlistCell)
            })
            .subscribe { [weak self] (subliminals, playlist) in
                guard let self else { return }
                var newSection = self.sections.value
                if subliminals.isEmpty {
                    if let subliminalIndex = newSection.lastIndex(where: { $0.header == SearchSection.subliminal.title }) {
                    newSection.remove(at: subliminalIndex)
                }
                } else {
                    if let subliminalIndex = newSection.lastIndex(where: { $0.header == SearchSection.subliminal.title }) {
                        newSection[subliminalIndex].items = subliminals
                    } else {
                        newSection.insert(.init(header: SearchSection.subliminal.title, items: subliminals), at: 0)
                    }
                }
                if playlist.isEmpty {
                    if let playListIndex = newSection.lastIndex(where: { $0.header == SearchSection.playlist.title }) {
                        newSection.remove(at: playListIndex)
                    }
                } else {
                    if let playListIndex = newSection.lastIndex(where: { $0.header == SearchSection.playlist.title }) {
                        newSection[playListIndex].items = playlist
                    } else {
                        newSection.append(.init(header: SearchSection.playlist.title, items: playlist))
                    }
                }
                self.sections.accept(newSection)
            }
            .disposed(by: disposeBag)
        
        searchRelay.asObservable()
            .debounce(Self.SEARCH_DEBOUNCE_TIME, scheduler: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .subscribe { [weak self] search in
                self?.search()
            }
            .disposed(by: disposeBag)
    }
    
    private func search() {
        Task {
            do {
                let response = try await networkService.searchSubliminalAndPlaylist(search: searchRelay.value)
                switch response {
                case .success(let dict):
                    subliminalRelay.accept(dict.subliminal.map { Subliminal.init(subliminalReponse: $0 )})
                    playlistRelay.accept(dict.playlist.map { Playlist.init(searchPlaylistResponse: $0 )})
                case .error(let errorResponse):
                    Logger.error("Search Response Error", topic: .presentation)
                    debugPrint("RESPONSE ERROR - \(errorResponse.message)")
                }
            } catch {
                debugPrint("Network Error Response - \(error.localizedDescription)")
            }
        }
    }
    
//    private func getFeaturedPlaylists() {
//        Task {
//            do {
//                let response = try await categoryUseCase.searchFeatured()
//                featuredRelay.accept(response)
//            } catch {
//                Logger.warning(error.localizedDescription, topic: .presentation)
//            }
//        }
//        
//    }
    
    private func configureSubliminalCell(with subliminal: Subliminal) -> CommonCell.Model {
        return CommonCell.Model(
            id: subliminal.subliminalID,
            title: subliminal.title,
            imageUrl: .init(string: subliminal.cover)
        ) { [weak self] in
            self?.selectedSubliminal.accept(subliminal)
        }
    }
    
    private func configurePlaylistCell(with playlist: Playlist) -> CommonCell.Model {
        return CommonCell.Model(
            id: playlist.playlistID,
            title: playlist.title,
            imageUrl: .init(string: playlist.cover)
        ) { [weak self] in
            self?.selectedPlaylist.accept(playlist)
        }
    }
    
    func setSearchFilter(_ search: String) {
        self.searchRelay.accept(search)
    }
    
}

extension SearchViewModel {
    
    struct Dependencies {
        let store: Store
        let router: Router
        let networkService: NetworkService
        let authenticationUseCase: AuthenticationUseCase
        
        static var standard: Dependencies {
            return .init(
                store: SharedDependencies.sharedDependencies.store,
                router: SharedDependencies.sharedDependencies.router,
                networkService: SharedDependencies.sharedDependencies.networkService,
                authenticationUseCase: SharedDependencies.sharedDependencies.useCases.authenticationUseCase
            )
        }
    }
    
}
