//
//  Presentation.swift
//  Magus
//
//  Created by Jomz on 5/30/23.
//

import Foundation

class Presentation {
    
    let signUpPresentation: SignInPresentation
    
    private let networkService: AuthenticationService
    private let router: Router
    
    init(networkService: AuthenticationService, router: Router) {
        self.networkService = networkService
        self.router = router
        
        signUpPresentation = SignInPresentation(networkService: networkService)
    }
    
}
