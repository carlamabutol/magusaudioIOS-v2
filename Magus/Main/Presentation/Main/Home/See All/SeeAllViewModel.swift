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
    private let store: Store
    private let networkService: NetworkService
    private let categoryUseCase: CategoryUseCase
    private var user: () -> User?
    private let categoryRelay = BehaviorRelay<[CategoryCell.Model]>(value: [])
    private let recommendations = BehaviorRelay<SubliminalsAndPlaylist?>(value: nil)
    private let featuredRelay = BehaviorRelay<SubliminalsAndPlaylist?>(value: nil)
    private let recommendedSubliminals = BehaviorRelay<[CategoryCell.Model]>(value: [])
    private let playlistRelay = BehaviorRelay<[Playlist]>(value: [])
    private let currentMood: () -> Int?
    private let selectedPlaylist = PublishRelay<Playlist>()
    
    let selectedPlaylistRelay = PublishRelay<Playlist>()
    
    let sections = BehaviorRelay<[SectionViewModel]>(value: [])
    var modelType: ModelType!
    
    init(sharedDependencies: SeeAllViewModel.Dependencies = .standard) {
        store = sharedDependencies.store
        categoryUseCase = sharedDependencies.categoryUseCase
        networkService = sharedDependencies.networkService
        user = sharedDependencies.user
        currentMood = sharedDependencies.currentMood
        super.init()
    }
    
    func setup(for modelType: ModelType) {
        titleRelay.accept(modelType)
        getItemsInAPI(for: modelType)
        self.modelType = modelType
    }
    
    private func getItemsInAPI(for modelType: ModelType) {
        switch modelType {
        case .featuredPlaylist, .featuredSubliminal:
            getFeaturedPlaylists(modelType: modelType)
        case .recommendations(let categoryId):
            getRecommendations(categoriyId: categoryId)
        case .category(let categoryId):
            getRecommendations(categoriyId: categoryId)
        }
    }
    
    private func getFeaturedPlaylists(modelType: ModelType) {
        Task {
            do {
                let response = try await categoryUseCase.searchFeatured()
                featuredRelay.accept(response)
                configureSectionFeatured(subliminalsAndPlaylist: response, modelType: modelType)
            } catch {
                Logger.warning(error.localizedDescription, topic: .presentation)
            }
        }
        
    }
    
    private func getRecommendations(categoriyId: Int?) {
        Task {
            do {
                let response = try await categoryUseCase.searchRecommended(categoryId: categoriyId, moodId: currentMood())
                recommendations.accept(response)
                configureSectionRecommendations(subliminalsAndPlaylist: response)
            } catch {
                Logger.warning(error.localizedDescription, topic: .presentation)
            }
        }
    }
    
    private func configureSectionRecommendations(subliminalsAndPlaylist: SubliminalsAndPlaylist) {
        let subliminalCells = subliminalsAndPlaylist.subliminal.map { constructSubliminalCell(with: $0) }
        let playlistCells = subliminalsAndPlaylist.playlist.map { constructPlaylistCell(with: $0) }
        var newSection: [SectionViewModel] = []
        if !subliminalCells.isEmpty {
            newSection.append(SectionViewModel(header: "Recommended Subliminal", items: subliminalCells))
        }
        if !playlistCells.isEmpty {
            newSection.append(SectionViewModel(header: "Recommended Playlist", items: playlistCells))
        }
        sections.accept(newSection)
    }
    
    private func configureSectionFeatured(subliminalsAndPlaylist: SubliminalsAndPlaylist, modelType: ModelType) {
        let subliminalCells = subliminalsAndPlaylist.subliminal.map { constructSubliminalCell(with: $0) }
        let playlistCells = subliminalsAndPlaylist.playlist.map { constructPlaylistCell(with: $0) }
        var newSection: [SectionViewModel] = []
        switch modelType {
        case .featuredPlaylist:
            if !playlistCells.isEmpty {
                newSection.append(SectionViewModel(header: "Featured Playlist", items: playlistCells))
            }
        case .featuredSubliminal:
            if !subliminalCells.isEmpty {
                newSection.append(SectionViewModel(header: "Featured Subliminal", items: subliminalCells))
            }
        default:
            break
        }
        sections.accept(newSection)
    }
    
    private func constructPlaylistCell(with playlist: Playlist) -> CommonCell.Model {
        return CommonCell.Model(
            id: playlist.playlistID,
            title: playlist.title,
            imageUrl: .init(string: playlist.cover)
        ) { [weak self] in
            self?.selectedPlaylist.accept(playlist)
        }
    }
    
    private func constructSubliminalCell(with subliminal: Subliminal) -> CommonCell.Model {
        return CommonCell.Model(
            id: subliminal.subliminalID,
            title: subliminal.title,
            imageUrl: .init(string: subliminal.cover)
        ) { [weak self] in
            self?.updateSelectedSubliminal(subliminal: subliminal)
        }
    }
    
    private func updateSelectedSubliminal(subliminal: Subliminal) {
        switch modelType {
        case .recommendations:
            store.appState.subliminalQueue = recommendations.value?.subliminal ?? []
        case .featuredSubliminal:
            store.appState.subliminalQueue = featuredRelay.value?.subliminal ?? []
        default:
            break
        }
        store.appState.selectedSubliminal = subliminal
    }
    
    func setSearchFilter(search: String) {
        if let modelType = modelType, search.isEmpty {
            getItemsInAPI(for: modelType)
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
        let store: Store
        let router: Router
        let networkService: NetworkService
        let authenticationUseCase: AuthenticationUseCase
        let categoryUseCase: CategoryUseCase
        let currentMood: () -> Int?
        
        static var standard: Dependencies {
            return .init(
                user: { SharedDependencies.sharedDependencies.store.appState.user },
                store: SharedDependencies.sharedDependencies.store,
                router: SharedDependencies.sharedDependencies.router,
                networkService: SharedDependencies.sharedDependencies.networkService,
                authenticationUseCase: SharedDependencies.sharedDependencies.useCases.authenticationUseCase,
                categoryUseCase: SharedDependencies.sharedDependencies.useCases.categoryUseCase,
                currentMood: { SharedDependencies.sharedDependencies.store.appState.selectedMood?.id }
            )
        }
    }
    
    enum ModelType {
        case featuredSubliminal
        case featuredPlaylist
        case recommendations(categoryId: Int? = nil)
        case category(categoryId: Int? = nil)
        
        var title: String {
            switch self {
            case .featuredPlaylist:
                return "Featured Playlist"
            case .featuredSubliminal:
                return "Featured Subliminal"
            case .recommendations:
                return "Recommendations"
            case .category:
                return "Category"
            }
        }
    }
    
}
