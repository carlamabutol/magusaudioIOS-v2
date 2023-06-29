//
//  UseCases.swift
//  Magus
//
//  Created by Jomz on 6/22/23.
//

import Foundation

class UseCases {
    
    let authenticationUseCase: AuthenticationUseCase
    
    init(store: Store, networkService: NetworkService, credentialsService: AuthenticationService, router: Router) {
        
        authenticationUseCase = AuthenticationUseCase(
            store: store,
            networkService: networkService,
            credentialsService: credentialsService
        )
    }
    
}
