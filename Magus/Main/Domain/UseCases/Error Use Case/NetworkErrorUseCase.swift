//
//  NetworkErrorUseCase.swift
//  Magus
//
//  Created by Jomz on 6/22/23.
//

import Foundation

class NetworkErrorUseCase {
    private let credentialsService: AuthenticationService
    private let router: Router
    
    init(credentialsService: AuthenticationService, router: Router) {
        self.credentialsService = credentialsService
        self.router = router
    }
    
    func handleInvalidAuth() {
        guard router.selectedRoute != .welcomeOnBoard else { return }
        credentialsService.clearAuthentication()
        SharedDependencies.sharedDependencies.store.appState = AppState()
        router.selectedRoute = .welcomeOnBoard
    }
}
