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
                return LocalizedStrings.SearchHeaderTitle.subliminal
            case .playlist:
                return LocalizedStrings.SearchHeaderTitle.playlist
            }
        }
    }
    
    let sections = BehaviorRelay<[SectionViewModel]>(value: [])
    
    private let subliminalRelay = BehaviorRelay<[CategoryCell.Model]>(value: [])
    private let playlistRelay = BehaviorRelay<[CategoryCell.Model]>(value: [])
    private let networkService: NetworkService
    let searchRelay = BehaviorRelay<String>(value: "")
    
    init(sharedDependencies: SearchViewModel.Dependencies = .standard) {
        networkService = sharedDependencies.networkService
        super.init()
        Observable.combineLatest(subliminalRelay, playlistRelay)
            .subscribe { [weak self] subliminals, playlist in
                guard let self else { return }
                var newSection = self.sections.value
                if newSection.isEmpty {
                    newSection.insert(.init(header: SearchSection.subliminal.title, items: subliminals), at: 0)
                } else {
                    newSection[0].items = subliminals
                }
                if let playListIndex = newSection.lastIndex(where: { $0.header == SearchSection.playlist.title }) {
                    newSection[playListIndex].items = playlist
                } else {
                    newSection.append(.init(header: SearchSection.playlist.title, items: playlist))
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
                    subliminalRelay.accept(dict.subliminal.map { CategoryCell.Model(id: $0.subliminalId, title: $0.title, imageUrl: .init(string: $0.cover )) })
                    playlistRelay.accept(dict.playlist.map { CategoryCell.Model(id: $0.playlistId, title: $0.title, imageUrl: .init(string: $0.cover )) })
                    Logger.info("Search Request Success - \(dict)", topic: .presentation)
                case .error(let errorResponse):
                    Logger.error("Search Response Error", topic: .presentation)
                    debugPrint("RESPONSE ERROR - \(errorResponse.message)")
                }
            } catch {
                debugPrint("Network Error Response - \(error.localizedDescription)")
            }
            
        }
    }
    
}

extension SearchViewModel {
    
    struct Dependencies {
        let router: Router
        let networkService: NetworkService
        let authenticationUseCase: AuthenticationUseCase
        
        static var standard: Dependencies {
            return .init(
                router: SharedDependencies.sharedDependencies.router,
                networkService: SharedDependencies.sharedDependencies.networkService,
                authenticationUseCase: SharedDependencies.sharedDependencies.useCases.authenticationUseCase
            )
        }
    }
    
}
