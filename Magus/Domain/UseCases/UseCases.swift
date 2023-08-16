//
//  UseCases.swift
//  Magus
//
//  Created by Jomz on 6/22/23.
//

import Foundation

class UseCases {
    
    let authenticationUseCase: AuthenticationUseCase
    let profileUseCase: ProfileUseCase
    let subliminalUseCase: SubliminalUseCase
    
    init(store: Store, networkService: NetworkService, credentialsService: AuthenticationService, router: Router) {
        
        authenticationUseCase = AuthenticationUseCase(
            store: store,
            networkService: networkService,
            credentialsService: credentialsService
        )
        
        profileUseCase = ProfileUseCase(
            store: store,
            networkService: networkService,
            credentialsService: credentialsService
        )
        
        subliminalUseCase = SubliminalUseCase(
            store: store,
            networkService: networkService,
            credentialsService: credentialsService
        )
    }
    
}
