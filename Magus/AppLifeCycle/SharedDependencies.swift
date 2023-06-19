//
//  SharedDependencies.swift
//  Magus
//
//  Created by Jose Mari Pascual on 5/14/23.
//

import Foundation

class SharedDependencies {
    let store: Store
    let router: Router
    let networkService: NetworkService
    let presentation: Presentation
    
    private init(
        store: Store,
        router: Router,
        networkService: NetworkService
    ) {
        self.store = store
        self.router = router
        self.networkService = networkService
        
        self.presentation = .init(networkService: networkService, router: router)
    }
}

extension SharedDependencies {
    
    static let sharedDependencies: SharedDependencies = {
        var appState: AppState?
        
        do {
            try appState = Store.getSavedAppState()
        } catch {
            Logger.error("Error decoding saved app state", topic: .domain)
        }
        
        let store = Store(appState: appState ?? AppState())
        let router = Router()
        let networkService = StandardNetworkService(baseURL: Configuration.baseURL)
        return .init(store: store, router: router, networkService: networkService)
    }()
}
