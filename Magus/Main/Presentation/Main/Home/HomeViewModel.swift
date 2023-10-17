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
    private let selectedPlaylist = PublishRelay<Playlist>()
    var selectedPlaylistObservable: Observable<Playlist> { selectedPlaylist.asObservable() }
    var currentMoodObservable: Observable<Mood?>
    
    private let networkService: NetworkService
    private let categoryUseCase: CategoryUseCase
    private var user: () -> User?
    
    init(sharedDependencies: HomeViewModel.Dependencies = .standard) {
        categoryUseCase = sharedDependencies.categoryUseCase
        networkService = sharedDependencies.networkService
        user = sharedDependencies.user
        currentMoodObservable = sharedDependencies.currentMoodObservable
        super.init()
        Observable.combineLatest(
            currentMoodObservable,
            categoryRelay,
            recommendedSubliminals,
            playlistRelay
        ) { currentMood, category, recommendedSub, playlist -> (Mood?, [CategoryCell.Model], [CategoryCell.Model], [CategoryCell.Model]) in
            let cellPlaylist = playlist.map { self.constructPlaylistCell(with: $0) }
            return (currentMood, category, recommendedSub, cellPlaylist)
        }.subscribe { [weak self] (currentMood, categories, subliminals, playlist) in
            guard let self else { return }
            var newSection: [SectionViewModel] = []
            if let currentMood = currentMood {
                newSection.append(self.constructMoodSection(currentMood: currentMood))
            }
            if !categories.isEmpty {
                newSection.append(self.constructSection(headerTitle: LocalisedStrings.HomeHeaderTitle.category, cellModels: categories, footerType: .category))
            }
            if !subliminals.isEmpty {
                newSection.append(self.constructSection(headerTitle: LocalisedStrings.HomeHeaderTitle.recommendations, cellModels: subliminals, footerType: .recommended))
            }
            if !playlist.isEmpty {
                newSection.append(self.constructSection(headerTitle: LocalisedStrings.HomeHeaderTitle.featuredPlayList, cellModels: playlist, footerType: .featuredPlaylist))
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
    
    private func constructMoodSection(currentMood: Mood) -> SectionViewModel {
        var title = Helper.checkTimeOfDay()
        if let user = user() {
            title += " \(user.info.firstName),"
        }
        
        let modelCell = SelectedMoodCell.Model(id: String(currentMood.id), title: title, subTitle: currentMood.greeting, imageAsset: currentMood.status == .positive ? .positive : .negative)
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
    
    private func getAllCategory() {
        Task {
            do {
                let categories = try await categoryUseCase.getCategorySubliminal()
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
    
    private func constructCategoryCell(categories: [Category]) -> [CategoryCell.Model] {
        return categories.map {
            CategoryCell.Model(id: String(describing: $0.id), title: $0.name, imageUrl: .init(string: $0.image ?? ""))
        }
    }
    
    private func constructPlaylistCell(with playlist: Playlist) -> CategoryCell.Model {
        return CategoryCell.Model(
            id: playlist.playlistID,
            title: playlist.title
        ) { [weak self] in
            self?.selectedPlaylist.accept(playlist)
        }
    }
    
}

extension HomeViewModel {
    
    struct Dependencies {
        let user: () -> User?
        let router: Router
        let networkService: NetworkService
        let authenticationUseCase: AuthenticationUseCase
        let categoryUseCase: CategoryUseCase
        let currentMoodObservable: Observable<Mood?>
        
        static var standard: Dependencies {
            return .init(
                user: { SharedDependencies.sharedDependencies.store.appState.user },
                router: SharedDependencies.sharedDependencies.router,
                networkService: SharedDependencies.sharedDependencies.networkService,
                authenticationUseCase: SharedDependencies.sharedDependencies.useCases.authenticationUseCase,
                categoryUseCase: SharedDependencies.sharedDependencies.useCases.categoryUseCase,
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
