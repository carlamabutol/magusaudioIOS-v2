//
//  SeeAllViewModel.swift
//  Magus
//
//  Created by Jomz on 10/9/23.
//

import Foundation
import RxRelay
import RxSwift

class SeeAllViewModel: ViewModel {
    
    private let titleRelay = BehaviorRelay<ModelType?>(value: nil)
    var titleObservable: Observable<ModelType> { titleRelay.compactMap { $0 }.asObservable() }
    private let networkService: NetworkService
    private var user: () -> User?
    private let categoryRelay = BehaviorRelay<[CategoryCell.Model]>(value: [])
    private let recommendedSubliminals = BehaviorRelay<[CategoryCell.Model]>(value: [])
    private let playlistRelay = BehaviorRelay<[Playlist]>(value: [])
    
    let selectedPlaylistRelay = PublishRelay<Playlist>()
    
    let sections = BehaviorRelay<[SectionViewModel]>(value: [])
    var modelType: ModelType!
    
    init(sharedDependencies: HomeViewModel.Dependencies = .standard) {
        networkService = sharedDependencies.networkService
        user = sharedDependencies.user
        super.init()
    }
    
    func setup(for modelType: ModelType) {
        titleRelay.accept(modelType)
        switch modelType {
        case .featuredPlaylist:
            getFeaturedPlaylists()
        case .recommended:
            getRecommendations()
        case .category:
            getAllCategory()
        }
        self.modelType = modelType
    }
    
    
    private func getAllCategory() {
        Task {
            do {
                let response = try await networkService.getCategorySubliminal()
                switch response {
                case .success(let array):
                    configureSectionCategory(with: array)
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
                    let playlist = response.playlist.map { Playlist(searchPlaylistResponse: $0) }
                    configureSectionFeaturedPlaylist(with: playlist)
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
                    configureSectionRecommendations(with: response.subliminal)
                case .error(let errorResponse):
                    Logger.warning(errorResponse.message, topic: .presentation)
                }
            } catch {
                Logger.warning(error.localizedDescription, topic: .presentation)
            }
            
        }
        
    }
    
    private func configureSectionCategory(with items: [CategorySubliminalElement]) {
        let itemModels = items.map { CategoryCell.Model(id: String(describing: $0.id), title: $0.name, imageUrl: .init(string: $0.image ?? "")) }
        sections.accept([SectionViewModel(header: "", items: itemModels)])
    }
    
    private func configureSectionRecommendations(with items: [SubliminalResponse]) {
        let itemModels = items.map { CategoryCell.Model(id: String(describing: $0.id), title: $0.title, imageUrl: .init(string: $0.cover )) }
        sections.accept([SectionViewModel(header: "", items: itemModels)])
    }
    
    private func configureSectionFeaturedPlaylist(with items: [Playlist]) {
        let itemModels = items.map { playlist in
            CategoryCell.Model(
            id: playlist.playlistID,
            title: playlist.title,
            imageUrl: .init(string: playlist.cover ), tapActionHandler: { [weak self] in
                self?.selectedPlaylistRelay.accept(playlist)
            })
        }
        sections.accept([SectionViewModel(header: "", items: itemModels)])
        
    }
    
    func setSearchFilter(search: String) {
        if let modelType = modelType, search.isEmpty {
            switch modelType {
            case .featuredPlaylist:
                getFeaturedPlaylists()
            case .recommended:
                getRecommendations()
            case .category:
                getAllCategory()
            }
            return
        }
        guard let section = sections.value.first else { return }
        let items = section.items.filter { $0.title.lowercased().range(of: search.lowercased()) != nil }
        sections.accept([SectionViewModel(header: "", items: items)])
    }
}

extension SeeAllViewModel {
    
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
    
    enum ModelType: String {
        case featuredPlaylist = "Featured Playlist"
        case recommended = "Recommendations"
        case category = "Category"
    }
    
}
