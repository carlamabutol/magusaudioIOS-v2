//
//  Presentation.swift
//  Magus
//
//  Created by Jomz on 5/30/23.
//

import Foundation

class Presentation {
    
    let signUpPresentation: SignInPresentation
    
    private let networkService: NetworkService
    private let router: Router
    
    init(networkService: NetworkService, router: Router) {
        self.networkService = networkService
        self.router = router
        
        signUpPresentation = SignInPresentation(networkService: networkService)
    }
    
}
