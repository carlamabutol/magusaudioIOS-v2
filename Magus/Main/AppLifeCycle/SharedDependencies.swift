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
    let credentialsService: AuthenticationService
    let useCases: UseCases
    
    private init(
        store: Store,
        router: Router,
        credentialsService: AuthenticationService,
        networkService: NetworkService
    ) {
        self.store = store
        self.router = router
        self.networkService = networkService
        self.credentialsService = credentialsService
        useCases = UseCases(store: store, networkService: networkService, credentialsService: credentialsService, router: router)
    }
}

extension SharedDependencies {
    
    static let sharedDependencies: SharedDependencies = {
        var appState: AppState?
        let credentialsService = StandardCredentialsService()
        let router = Router(credentialsService: credentialsService)
        
        do {
            try appState = Store.getSavedAppState()
        } catch {
            router.selectedRoute = .welcomeOnBoard
            Logger.error("Error decoding saved app state", topic: .domain)
        }
        
        let store = Store(appState: appState ?? AppState())
        let networkService = StandardNetworkService(
            baseURL: Configuration.baseURL,
            credentialsService: credentialsService,
            getUserID: { store.appState.userId },
            getSubscriptionID: { store.appState.user?.info.subscriptionID ?? 0  }
        )
        return .init(store: store, router: router, credentialsService: credentialsService, networkService: networkService)
    }()
}
