//
//  SharedDependencies.swift
//  Magus
//
//  Created by Jose Mari Pascual on 5/14/23.
//

import Foundation

class SharedDependencies {
    let router: Router
    let networkService: AuthenticationService
    let presentation: Presentation
    
    private init(
        router: Router,
        networkService: AuthenticationService
    ) {
        self.router = router
        self.networkService = networkService
        
        self.presentation = .init(networkService: networkService, router: router)
    }
}

extension SharedDependencies {
    
    static let sharedDependencies: SharedDependencies = {
        let router = Router()
        let networkService = StandardNetworkService(baseURL: Configuration.baseURL)
        return .init(router: router, networkService: networkService)
    }()
}
