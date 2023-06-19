//
//  MainTabViewModel.swift
//  Magus
//
//  Created by Jomz on 6/19/23.
//

import Foundation
import RxSwift
import RxRelay

class MainTabViewModel: ViewModel {
    
    let tabItems: Observable<[TabItem]> = .just(MainTabViewModel.constructTabItems())
    
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
