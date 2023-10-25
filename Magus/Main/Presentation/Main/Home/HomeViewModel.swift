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
    private let recommendations = BehaviorRelay<SubliminalsAndPlaylist?>(value: nil)
    private let featuredRelay = BehaviorRelay<SubliminalsAndPlaylist?>(value: nil)
    private let selectedFooter = PublishRelay<SeeAllViewModel.ModelType>()
    var selectedFooterObservable: Observable<SeeAllViewModel.ModelType> { selectedFooter.asObservable() }
    private let selectedPlaylist = PublishRelay<Playlist>()
    var selectedPlaylistObservable: Observable<Playlist> { selectedPlaylist.asObservable() }
    var currentMoodObservable: Observable<Mood?>
    var currentMoodId: Int?
    
    private let store: Store
    private let router: Router
    private let networkService: NetworkService
    private let categoryUseCase: CategoryUseCase
    private let moodUseCase: MoodUseCase
    private var user: () -> User?
    
    init(sharedDependencies: HomeViewModel.Dependencies = .standard) {
        store = sharedDependencies.store
        categoryUseCase = sharedDependencies.categoryUseCase
        networkService = sharedDependencies.networkService
        moodUseCase = sharedDependencies.moodUseCase
        user = sharedDependencies.user
        router = sharedDependencies.router
        currentMoodObservable = sharedDependencies.currentMoodObservable
        super.init()
        
        let categorySection = categoryRelay
            .map { [weak self] cellModels -> [SectionViewModel] in
                guard let self = self else { return [] }
                if cellModels.isEmpty {
                    return []
                }
                return [
                    self.constructSection(headerTitle: LocalisedStrings.HomeHeaderTitle.category, cellModels: cellModels, footerType: .category)
                ]
            }
        
        let recommendationSection = recommendations
            .map { [weak self] model -> [SectionViewModel] in
                guard let self = self else { return [] }
                let subliminalCellModels = model?.subliminal.compactMap { self.constructSubliminalCell(with: $0) } ?? []
                if subliminalCellModels.isEmpty {
                    return []
                }
                return [
                    self.constructSection(headerTitle: "Recommendations", cellModels: subliminalCellModels, footerType: .recommended())
                ]
            }
        
        let featuredSection = featuredRelay
            .map { [weak self] model -> [SectionViewModel] in
                guard let self = self else { return [] }
                let playlistCellModels = model?.playlist.compactMap { self.constructPlaylistCell(with: $0) } ?? []
                let subliminalCellModels = model?.subliminal.compactMap { self.constructSubliminalCell(with: $0) } ?? []
                var sections: [SectionViewModel] = []
                
                if !subliminalCellModels.isEmpty {
                    sections.append(self.constructSection(headerTitle: "Featured Subliminal", cellModels: subliminalCellModels, footerType: .featuredSubliminal))
                }
                
                if !playlistCellModels.isEmpty {
                    sections.append(self.constructSection(headerTitle: "Featured Playlist", cellModels: playlistCellModels, footerType: .featuredPlaylist))
                }
                
                return sections
            }
        
        
        Observable.combineLatest(
            currentMoodObservable,
            categorySection,
            recommendationSection,
            featuredSection
        ) { currentMood, categories, recommendedSub, featured -> (Mood?, [SectionViewModel], [SectionViewModel], [SectionViewModel]) in
            return (currentMood, categories, recommendedSub, featured)
        }.subscribe { [weak self] (currentMood, categories, recommendations, featured) in
            guard let self else { return }
            self.currentMoodId = currentMood?.id
            var newSection: [SectionViewModel] = []
            if let currentMood = currentMood {
                newSection.append(self.constructMoodSection(currentMood: currentMood))
            }
            newSection.append(contentsOf: categories)
            newSection.append(contentsOf: recommendations)
            newSection.append(contentsOf: featured)
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
                let categories = try await categoryUseCase.searchCategory()
                let cellModels = constructCategoryCell(categories: categories)
                categoryRelay.accept(cellModels)
            } catch {
                Logger.warning(error.localizedDescription, topic: .presentation)
            }
            
        }
    }
    
    private func getFeaturedPlaylists() {
        Task {
            do {
                let response = try await categoryUseCase.searchFeatured()
                featuredRelay.accept(response)
            } catch {
                Logger.warning(error.localizedDescription, topic: .presentation)
            }
        }
        
    }
    
    private func getRecommendations() {
        Task {
            do {
                let response = try await categoryUseCase.searchRecommended(categoryId: nil, moodId: currentMoodId)
                recommendations.accept(response)
            } catch {
                Logger.warning(error.localizedDescription, topic: .presentation)
            }
        }
    }
    
    private func getCurrentMood() {
        Task {
            _ = try await moodUseCase.getCurrentMood()
        }
    }
    
    private func constructMoodSection(currentMood: Mood) -> SectionViewModel {
        var title = Helper.checkTimeOfDay()
        if let user = user() {
            title += " \(user.info.firstName),"
        }
        
        let modelCell = SelectedMoodCell.Model(id: String(currentMood.id), title: title, subTitle: currentMood.greeting, imageAsset: currentMood.status == .positive ? .positive : .negative) { [weak self] in
            self?.router.selectedRoute = .mood
        }
        return SectionViewModel(
                header: LocalisedStrings.HomeHeaderTitle.mood,
                items: [modelCell],
                footerTapHandler: nil
            )
    }
    
    private func constructSection(headerTitle: String, cellModels: [ItemModel], footerType: SeeAllViewModel.ModelType) -> SectionViewModel {
        return SectionViewModel(
                header: headerTitle,
                items: cellModels,
                footerTapHandler: {
                    self.selectedFooter.accept(footerType)
                }
            )
    }
    
    private func constructCategoryCell(categories: [Category]) -> [CategoryCell.Model] {
        return categories.map { category in
            CategoryCell.Model(
                id: String(describing: category.id),
                title: category.name,
                imageUrl: .init(string: category.image ?? "")
            ) { [weak self] in
                self?.selectedFooter.accept(.recommended(categoriyId: category.id))
            }
        }
    }
    
    private func constructPlaylistCell(with playlist: Playlist) -> CategoryCell.Model {
        return CategoryCell.Model(
            id: playlist.playlistID,
            title: playlist.title,
            imageUrl: .init(string: playlist.cover)
        ) { [weak self] in
            self?.selectedPlaylist.accept(playlist)
        }
    }
    
    private func constructSubliminalCell(with subliminal: Subliminal) -> CategoryCell.Model {
        return CategoryCell.Model(
            id: subliminal.subliminalID,
            title: subliminal.title,
            imageUrl: .init(string: subliminal.cover)
        ) { [weak self] in
            self?.store.appState.selectedSubliminal = subliminal
        }
    }
    
}

extension HomeViewModel {
    
    struct Dependencies {
        let user: () -> User?
        let store: Store
        let router: Router
        let networkService: NetworkService
        let authenticationUseCase: AuthenticationUseCase
        let categoryUseCase: CategoryUseCase
        let moodUseCase: MoodUseCase
        let currentMoodObservable: Observable<Mood?>
        
        static var standard: Dependencies {
            return .init(
                user: { SharedDependencies.sharedDependencies.store.appState.user },
                store: SharedDependencies.sharedDependencies.store,
                router: SharedDependencies.sharedDependencies.router,
                networkService: SharedDependencies.sharedDependencies.networkService,
                authenticationUseCase: SharedDependencies.sharedDependencies.useCases.authenticationUseCase,
                categoryUseCase: SharedDependencies.sharedDependencies.useCases.categoryUseCase,
                moodUseCase: SharedDependencies.sharedDependencies.useCases.moodUseCase,
                currentMoodObservable: SharedDependencies.sharedDependencies.store.observable(of: \.selectedMood)
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
