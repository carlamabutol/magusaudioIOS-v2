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
    
    private let categoryRelay = BehaviorRelay<[Category]>(value: [])
    private let recommendations = BehaviorRelay<SubliminalsAndPlaylist?>(value: nil)
    private let featuredRelay = BehaviorRelay<SubliminalsAndPlaylist?>(value: nil)
    private let selectedFooter = PublishRelay<SeeAllViewModel.ModelType>()
    var selectedFooterObservable: Observable<SeeAllViewModel.ModelType> { selectedFooter.asObservable() }
    private let selectedPlaylist = PublishRelay<Playlist>()
    var selectedPlaylistObservable: Observable<Playlist> { selectedPlaylist.asObservable() }
    var currentMoodObservable: Observable<Mood?>
    var currentMoodId: Int?
    var selectedCategoryId: Int?
    private let loadingRelay = BehaviorRelay<Bool>(value: true)
    var loadingObservable: Observable<Bool> { loadingRelay.asObservable() }
    
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
        
        sharedDependencies.selectedCategoryObservable
            .compactMap { $0 }
            .subscribe { [weak self] in
                self?.selectedCategoryId = $0.id
                self?.getRecommendations(categoryId: $0.id)
            }
            .disposed(by: disposeBag)
        
        let categorySection = Observable.combineLatest(categoryRelay, sharedDependencies.selectedCategoryObservable)
            .map { [weak self] categories, _ -> [SectionViewModel] in
                guard let self = self, let selectedCategoryId = self.selectedCategoryId else { return [] }
                
                let cellModels = self.constructCategoryCell(categories: categories)
                if cellModels.isEmpty {
                    return []
                }
                return [
                    self.constructSection(headerTitle: LocalisedStrings.HomeHeaderTitle.category, cellModels: cellModels, footerType: .category(categoryId: selectedCategoryId))
                ]
            }
        
        let recommendationSection = recommendations
            .map { [weak self] model -> [SectionViewModel] in
                guard let self = self, let selectedCategoryId = self.selectedCategoryId else { return [] }
                let subliminalCellModels = model?.subliminal.compactMap { self.constructSubliminalCell(with: $0, type: .recommendations()) } ?? []
                if subliminalCellModels.isEmpty {
                    return []
                }
                return [
                    self.constructSection(headerTitle: LocalisedStrings.HomeHeaderTitle.recommendations, cellModels: subliminalCellModels, footerType: .recommendations(categoryId: selectedCategoryId))
                ]
            }
        
        let featuredSection = featuredRelay
            .map { [weak self] model -> [SectionViewModel] in
                guard let self = self else { return [] }
                let playlistCellModels = model?.playlist.compactMap { self.constructPlaylistCell(with: $0) } ?? []
                let subliminalCellModels = model?.subliminal.compactMap { self.constructSubliminalCell(with: $0, type: .featuredSubliminal) } ?? []
                var sections: [SectionViewModel] = []
                
                if !subliminalCellModels.isEmpty {
                    sections.append(self.constructSection(headerTitle: LocalisedStrings.HomeHeaderTitle.featuredSubliminal, cellModels: subliminalCellModels, footerType: .featuredSubliminal))
                }
                
                if !playlistCellModels.isEmpty {
                    sections.append(self.constructSection(headerTitle: LocalisedStrings.HomeHeaderTitle.featuredPlayList, cellModels: playlistCellModels, footerType: .featuredPlaylist))
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
            self.loadingRelay.accept(false)
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
    }
    
    private func getAllCategory() {
        Task {
            do {
                let categories = try await categoryUseCase.searchCategory()
                store.appState.selectedCategory = categories.first
                categoryRelay.accept(categories)
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
    
    private func getRecommendations(categoryId: Int) {
        Task {
            do {
                let response = try await categoryUseCase.searchRecommended(categoryId: categoryId, moodId: currentMoodId)
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
        let categoryId = selectedCategoryId
        return categories.map { category in
            CategoryCell.Model(
                id: String(describing: category.id),
                title: category.name,
                imageUrl: .init(string: category.image ?? ""),
                isSelected: categoryId == category.id
            ) { [weak self] in
                self?.store.appState.selectedCategory = category
            }
        }
    }
    
    private func constructPlaylistCell(with playlist: Playlist) -> CategoryCell.Model {
        return CategoryCell.Model(
            id: playlist.playlistID,
            title: playlist.title,
            imageUrl: .init(string: playlist.cover),
            isSelected: false
        ) { [weak self] in
            self?.selectedPlaylist.accept(playlist)
        }
    }
    
    private func constructSubliminalCell(with subliminal: Subliminal, type: SeeAllViewModel.ModelType) -> CategoryCell.Model {
        return CategoryCell.Model(
            id: subliminal.subliminalID,
            title: subliminal.title,
            imageUrl: .init(string: subliminal.cover),
            isSelected: false
        ) { [weak self] in
            switch type {
            case .featuredSubliminal:
                self?.store.appState.subliminalQueue = self?.featuredRelay.value?.subliminal ?? []
            case .recommendations:
                self?.store.appState.subliminalQueue = self?.recommendations.value?.subliminal ?? []
            default:
                break
            }
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
        let selectedCategoryObservable: Observable<Category?>
        
        static var standard: Dependencies {
            return .init(
                user: { SharedDependencies.sharedDependencies.store.appState.user },
                store: SharedDependencies.sharedDependencies.store,
                router: SharedDependencies.sharedDependencies.router,
                networkService: SharedDependencies.sharedDependencies.networkService,
                authenticationUseCase: SharedDependencies.sharedDependencies.useCases.authenticationUseCase,
                categoryUseCase: SharedDependencies.sharedDependencies.useCases.categoryUseCase,
                moodUseCase: SharedDependencies.sharedDependencies.useCases.moodUseCase,
                currentMoodObservable: SharedDependencies.sharedDependencies.store.observable(of: \.selectedMood),
                selectedCategoryObservable: SharedDependencies.sharedDependencies.store.observable(of: \.selectedCategory)
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
