//
//  LoginViewModel.swift
//  Magus
//
//  Created by Jose Mari Pascual on 5/10/23.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
    private let router: Router
    private let userName = BehaviorRelay<String>(value: "")
    var userNameObservable: Observable<String> { userName.asObservable() }
    
    private let password = BehaviorRelay<String>(value: "")
    var passwordObservable: Observable<String> { password.asObservable() }
    
    init(dependencies: Dependencies = .standard) {
        router = dependencies.router
    }
    
    func loginAction() {
        DispatchQueue.main.async { [weak self] in
            self?.router.selectedRoute = .home
        }
    }
    
}

extension LoginViewModel {
    struct Dependencies {
        let router: Router
        
        static var standard: Dependencies {
            return .init(router: SharedDependencies.sharedDependencies.router)
        }
    }
}
