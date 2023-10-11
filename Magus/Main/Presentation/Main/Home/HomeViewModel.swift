//
//  HomeViewModel.swift
//  Magus
//
//  Created by Jomz on 6/19/23.
//

import Foundation
import RxSwift
import RxRelay
import RxDataSources

class HomeViewModel: ViewModel {
    
    let sections = BehaviorRelay<[SectionViewModel]>(value: [])
    
    private let categoryRelay = BehaviorRelay<[CategoryCell.Model]>(value: [])
    private let recommendedSubliminals = BehaviorRelay<[CategoryCell.Model]>(value: [])
    private let playlistRelay = BehaviorRelay<[Playlist]>(value: [])
    private let selectedFooter = PublishRelay<SeeAllViewModel.ModelType>()
    var selectedFooterObservable: Observable<SeeAllViewModel.ModelType> { selectedFooter.asObservable() }
    
    private let networkService: NetworkService
    private var user: () -> User?
    
    init(sharedDependencies: HomeViewModel.Dependencies = .standard) {
        networkService = sharedDependencies.networkService
        user = sharedDependencies.user
        super.init()
        Observable.combineLatest(categoryRelay, recommendedSubliminals, playlistRelay)
            .map { category, recommendedSub, playlist in
                let cellPlaylist = playlist.map { CategoryCell.Model(id: $0.playlistID, title: $0.title, imageUrl: .init(string: $0.cover )) }
                return (category, recommendedSub, cellPlaylist)
            }
            .subscribe { [weak self] (categories, subliminals, playlist) in
                guard let self else { return }
                var newSection = self.sections.value
                if newSection.isEmpty {
                    newSection.insert(SectionViewModel(
                        header: LocalizedStrings.HomeHeaderTitle.category,
                        items: categories,
                        footerTapHandler: {
                            self.selectedFooter.accept(.category)
                        }
                    ), at: 0)
                } else if !categories.isEmpty {
                    newSection[0].items = categories
                }
                if self.user()?.info.moodsID != nil {
                    if !subliminals.isEmpty {
                        if let recommendationIndex = newSection.lastIndex(where: { $0.header == LocalizedStrings.HomeHeaderTitle.recommendations }) {
                            newSection[recommendationIndex].items = subliminals
                        } else if !categories.isEmpty {
                            newSection.append(
                                SectionViewModel(
                                    header: LocalizedStrings.HomeHeaderTitle.recommendations,
                                    items: subliminals,
                                    footerTapHandler: {
                                        self.selectedFooter.accept(.recommended)
                                    }
                                )
                            )
                        }
                    } else {
                        if let recommendationIndex = newSection.lastIndex(where: { $0.header == LocalizedStrings.HomeHeaderTitle.recommendations }) {
                            newSection.remove(at: recommendationIndex)
                        }
                    }
                }
                if !playlist.isEmpty {
                    if let playListIndex = newSection.lastIndex(where: { $0.header == LocalizedStrings.HomeHeaderTitle.featuredPlayList }) {
                        newSection[playListIndex].items = playlist
                    } else if !playlist.isEmpty {
                        newSection.append(
                            SectionViewModel(
                                header: LocalizedStrings.HomeHeaderTitle.featuredPlayList,
                                items: playlist,
                                footerTapHandler: {
                                    self.selectedFooter.accept(.featuredPlaylist)
                                }
                            )
                        )
                    }
                } else {
                    if let playListIndex = newSection.lastIndex(where: { $0.header == LocalizedStrings.HomeHeaderTitle.featuredPlayList }) {
                        newSection.remove(at: playListIndex)
                    }
                }
                self.sections.accept(newSection)
            }
            .disposed(by: disposeBag)
    }
    
    func getHomeDetails() {
        getAllCategory()
        getFeaturedPlaylists()
        getRecommendations()
    }
    
    private func getAllCategory() {
        Task {
            do {
                let response = try await networkService.getCategorySubliminal()
                switch response {
                case .success(let array):
                    categoryRelay.accept(array.map { CategoryCell.Model(id: String(describing: $0.id), title: $0.name, imageUrl: .init(string: $0.image ?? "")) })
                case .error(let errorResponse):
                    Logger.warning(errorResponse.message, topic: .presentation)
                }
            } catch {
                Logger.warning(error.localizedDescription, topic: .presentation)
            }
            
        }
    }
    
    private func getFeaturedPlaylists() {
        Task {
            do {
                let response = try await networkService.getFeaturedPlaylists()
                switch response {
                case .success(let response):
                    playlistRelay.accept(response.playlist.map { Playlist(searchPlaylistResponse: $0) })
                case .error(let errorResponse):
                    Logger.warning(errorResponse.message, topic: .presentation)
                }
            } catch {
                Logger.warning(error.localizedDescription, topic: .presentation)
            }
        }
        
    }
    
    private func getRecommendations() {
        Task {
            do {
                let response = try await networkService.getRecommendations()
                switch response {
                case .success(let response):
                    recommendedSubliminals.accept(response.subliminal.map { CategoryCell.Model(id: String(describing: $0.id), title: $0.title, imageUrl: .init(string: $0.cover )) })
                case .error(let errorResponse):
                    Logger.warning(errorResponse.message, topic: .presentation)
                }
            } catch {
                Logger.warning(error.localizedDescription, topic: .presentation)
            }
            
        }
        
    }
    
    func getPlaylistByID(id: String) -> Playlist? {
        playlistRelay.value.first(where: { $0.playlistID == id})
    }
    
}

extension HomeViewModel {
    
    struct Dependencies {
        let user: () -> User?
        let router: Router
        let networkService: NetworkService
        let authenticationUseCase: AuthenticationUseCase
        
        static var standard: Dependencies {
            return .init(
                user: { SharedDependencies.sharedDependencies.store.appState.user },
                router: SharedDependencies.sharedDependencies.router,
                networkService: SharedDependencies.sharedDependencies.networkService,
                authenticationUseCase: SharedDependencies.sharedDependencies.useCases.authenticationUseCase
            )
        }
    }
    
}

struct SectionViewModel {
    var header: String
    var items: [ItemModel]
    var footerTapHandler: CompletionHandler?
    
    init(header: String, items: [ItemModel], footerTapHandler: CompletionHandler? = nil) {
        self.header = header
        self.items = items
        self.footerTapHandler = footerTapHandler
    }
}

protocol ItemModel {
    var id: String { get set }
    var title: String { get set }
    var imageUrl: URL? { get set }
    var tapActionHandler: CompletionHandler? { get set }
}

extension SectionViewModel: SectionModelType {
    typealias Item = ItemModel
    init(original: SectionViewModel, items: [ItemModel]) {
        self = original
        self.items = items
    }
}
