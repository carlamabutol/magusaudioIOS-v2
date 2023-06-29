//
//  UserUseCase.swift
//  Magus
//
//  Created by Jomz on 6/22/23.
//

import Foundation

final class UserUseCase {
    
    private var store: Store
    private let networkService: NetworkService
    private let credentialsService: AuthenticationService
    
    init(store: Store, networkService: NetworkService, credentialsService: AuthenticationService) {
        self.store = store
        self.networkService = networkService
        self.credentialsService = credentialsService
    }
    
}
