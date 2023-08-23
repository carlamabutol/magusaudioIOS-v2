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
    private let playlistRelay = BehaviorRelay<[CategoryCell.Model]>(value: [])
    
    private let networkService: NetworkService
    private var user: () -> User?
    
    init(sharedDependencies: HomeViewModel.Dependencies = .standard) {
        networkService = sharedDependencies.networkService
        user = sharedDependencies.user
        super.init()
        Observable.combineLatest(categoryRelay, playlistRelay)
            .subscribe { [weak self] categories, playlist in
                guard let self else { return }
                var newSection = self.sections.value
                if newSection.isEmpty {
                    newSection.insert(.init(header: LocalizedStrings.HomeHeaderTitle.category, items: categories), at: 0)
                } else if !categories.isEmpty {
                    newSection[0].items = categories
                }
                if let playListIndex = newSection.lastIndex(where: { $0.header == LocalizedStrings.HomeHeaderTitle.featuredPlayList }) {
                    newSection[playListIndex].items = playlist
                } else if !playlist.isEmpty {
                    newSection.append(.init(header: LocalizedStrings.HomeHeaderTitle.featuredPlayList, items: playlist))
                }
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
                let response = try await networkService.getCategorySubliminal()
                switch response {
                case .success(let array):
                    categoryRelay.accept(array.map { CategoryCell.Model(id: String(describing: $0.id), title: $0.name, imageUrl: .init(string: $0.image ?? "")) })
                case .error(let errorResponse):
                    debugPrint("RESPONSE ERROR - \(errorResponse.message)")
                }
            } catch {
                debugPrint("Network Error Response - \(error.localizedDescription)")
            }
            
        }
    }
    
    private func getFeaturedPlaylists() {
        Task {
            do {
                let response = try await networkService.getFeaturedPlaylists()
                switch response {
                case .success(let array):
                    playlistRelay.accept(array.map { CategoryCell.Model(id: String(describing: $0.id), title: $0.title, imageUrl: .init(string: $0.cover )) })
                case .error(let errorResponse):
                    debugPrint("RESPONSE ERROR - \(errorResponse.message)")
                }
            } catch {
                Logger.error(error.localizedDescription, topic: .presentation)
            }
            
        }
        
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
    var header: String!
    var items: [ItemModel]
}

protocol ItemModel {
    var id: String { get set }
    var title: String { get set }
    var imageUrl: URL? { get set }
}

extension SectionViewModel: SectionModelType {
    typealias Item = ItemModel
    init(original: SectionViewModel, items: [ItemModel]) {
        self = original
        self.items = items
    }
}
