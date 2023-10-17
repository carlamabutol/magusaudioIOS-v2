//
//  SettingsViewModel.swift
//  Magus
//
//  Created by Jomz on 8/17/23.
//

import Foundation
import RxSwift

class SettingsViewModel: ViewModel {
    
    private let router: Router
    private let store: Store
    
    init(dependencies: SettingsViewModel.Dependencies = .standard) {
        router = dependencies.router
        store = dependencies.store
    }
    
    func logout() {
        store.removeAppState()
        router.logout()
    }
    
}

extension SettingsViewModel {
    
    struct Dependencies {
        let store: Store
        let router: Router
        let networkService: NetworkService
        
        static var standard: Dependencies {
            return .init(
                store: SharedDependencies.sharedDependencies.store,
                router: SharedDependencies.sharedDependencies.router,
                networkService: SharedDependencies.sharedDependencies.networkService
            )
        }
    }
    
}
