//
//  MainTabViewModel.swift
//  Magus
//
//  Created by Jomz on 6/19/23.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

class MainTabViewModel: ViewModel {
    
    let tabItems: Observable<[TabItem]> = .just(MainTabViewModel.constructTabItems())
    
    private let selectedSubRelay = PublishRelay<Subliminal>()
    var selectedSubliminalObservable: Observable<Subliminal> { selectedSubRelay.compactMap{ $0 }.asObservable() }
    private var user: () -> User?
    private let subliminalUseCase: SubliminalUseCase
    private let subliminalAudios = PublishRelay<[String]>()
    var subliminalAudiosObservable: Observable<[String]> { subliminalAudios.compactMap{ $0 }.asObservable() }
    private let selectedTabIndex = BehaviorRelay<MainTabViewModel.TabItem>(value: .home)
    var selectedTabIndexObservable: Observable<MainTabViewModel.TabItem> { selectedTabIndex.asObservable() }
    
    init(sharedDependencies: MainTabViewModel.Dependencies = .standard) {
        user = sharedDependencies.user
        subliminalUseCase = sharedDependencies.subliminalUseCase
        super.init()
    }
    
    func profileImage() -> URL? {
        guard let stringUrl = user()?.info.cover else { return nil }
        return .init(string: stringUrl)
    }
    
    func userEmail() -> String {
        user()?.email ?? ""
    }
    
    func userFullname() -> String {
        user()?.name ?? ""
    }
    
    func selectSubliminal(_ subliminal: Subliminal) {
        selectedSubRelay.accept(subliminal)
    }
    
    func getSubliminalAudios(_ id: String) {
        selectedTabIndex.accept(TabItem.sound)
        Task {
            let response = await subliminalUseCase.getSubliminalAudios(id)
            switch response {
            case .success(let audios):
                Logger.info("RESPONSE SUBLIMINAL AUDIO - \(audios)", topic: .presentation)
                subliminalAudios.accept(audios)
            case .failure(let error):
                Logger.error(error.localizedDescription, topic: .presentation)
            }
        }
    }
    
}

extension MainTabViewModel {
    
    struct Dependencies {
        let user: () -> User?
        let router: Router
        let networkService: NetworkService
        let subliminalUseCase: SubliminalUseCase
        
        static var standard: Dependencies {
            return .init(
                user: { SharedDependencies.sharedDependencies.store.appState.user },
                router: SharedDependencies.sharedDependencies.router,
                networkService: SharedDependencies.sharedDependencies.networkService,
                subliminalUseCase: SharedDependencies.sharedDependencies.useCases.subliminalUseCase
            )
        }
    }
    
}

extension MainTabViewModel {
    
    enum TabItem {
        case home
        case search
        case sound
        case premium
        case user
        
        var imageNameSelected: ImageAsset {
            switch self {
            case .home: return ImageAsset.tabHomeSelected
            case .search: return ImageAsset.tabSearchSelected
            case .sound: return ImageAsset.tabSoundSelected
            case .premium: return ImageAsset.tabPremiumSelected
            case .user: return ImageAsset.tabUserSelected
            }
        }
        
        var imageNameUnSelected: ImageAsset {
            switch self {
            case .home: return ImageAsset.tabHomeUnselected
            case .search: return ImageAsset.tabSearchUnselected
            case .sound: return ImageAsset.tabSoundUnselected
            case .premium: return ImageAsset.tabPremiumUnselected
            case .user: return ImageAsset.tabUserUnselected
            }
        }
        
        var title: String {
            switch self {
            case .home: return LocalizedStrings.TabBarTitle.home
            case .search: return LocalizedStrings.TabBarTitle.search
            case .sound: return LocalizedStrings.TabBarTitle.subs
            case .premium: return LocalizedStrings.TabBarTitle.premium
            case .user: return LocalizedStrings.TabBarTitle.profile
            }
        }
        
        var orderIndex: Int {
            switch self {
            case .home: return Self.homeOrderIndex
            case .search: return Self.searchOrderIndex
            case .sound: return Self.subsOrderIndex
            case .premium: return Self.premiumOrderIndex
            case .user: return Self.profileOrderIndex
            }
        }
        
        static let homeOrderIndex = 0
        static let searchOrderIndex = 1
        static let subsOrderIndex = 2
        static let premiumOrderIndex = 3
        static let profileOrderIndex = 4
    }
    
    private static func constructTabItems() -> [TabItem] {
        [.home, .search, .sound, .premium, .user]
            .sorted { $0.orderIndex < $1.orderIndex }
    }
    
}
