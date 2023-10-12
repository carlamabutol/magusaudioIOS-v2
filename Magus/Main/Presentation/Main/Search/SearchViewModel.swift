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
    private let searchRelay = BehaviorRelay<String>(value: "")
    private let networkService: NetworkService
    
    init(sharedDependencies: SearchViewModel.Dependencies = .standard) {
        networkService = sharedDependencies.networkService
        super.init()
        Observable.combineLatest(subliminalRelay, playlistRelay)
            .map({ subliminals, playlists in
                let subliminalCells: [CategoryCell.Model]  = subliminals.map { CategoryCell.Model(id: $0.subliminalID, title: $0.title, imageUrl: .init(string: $0.cover )) }
                let playlistCell: [CategoryCell.Model] = playlists.map { CategoryCell.Model(id: $0.playlistID, title: $0.title, imageUrl: .init(string: $0.cover )) }
                return (subliminalCells, playlistCell)
            })
            .subscribe { [weak self] (subliminals, playlist) in
                guard let self else { return }
                var newSection = self.sections.value
                if newSection.isEmpty {
                    newSection.insert(.init(header: SearchSection.subliminal.title, items: subliminals), at: 0)
                } else {
                    newSection[0].items = subliminals
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
    
    func setSearchFilter(_ search: String) {
        self.searchRelay.accept(search)
    }
    
    func getSubliminal(_ subliminalID: String) -> Subliminal {
        return subliminalRelay.value.first(where: { $0.subliminalID == subliminalID })!
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
