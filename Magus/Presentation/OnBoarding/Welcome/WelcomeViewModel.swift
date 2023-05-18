//
//  WelcomeViewModel.swift
//  Magus
//
//  Created by Jose Mari Pascual on 5/16/23.
//

import Foundation
import RxSwift
import RxCocoa

class WelcomeViewModel: ViewModel {
    
    private let router: Router
    
    init(dependencies: SharedDependencies = .sharedDependencies) {
        router = dependencies.router
        super.init()
    }
    
    func signInAction() {
        router.selectedRoute = .login
    }
    
}
