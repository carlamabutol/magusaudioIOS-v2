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
    private let networkService: AuthenticationService
    
    let userName = BehaviorRelay<String>(value: "")
    var userNameObservable: Observable<String> { userName.asObservable() }
    
    let password = BehaviorRelay<String>(value: "")
    var passwordObservable: Observable<String> { password.asObservable() }
    
    init(dependencies: Dependencies = .standard) {
        router = dependencies.router
        networkService = dependencies.networkService
    }
    
    func loginAction() {
        if userName.value.count < 8, password.value.count < 8 {
            print("Username or Password is less than 8 characters")
            return
        }
        Task {
            do {
                let response = try await networkService.signIn(email: userName.value, password: password.value)
//                print(response, to: &<#T##TextOutputStream#>)
//                switch response {
//                case .success(let response):
                    print("SignIn Success Response: \(response)")
//                    router.selectedRoute = .home
//                case .error(let errorResponse):
//                    print("SignIn Error Response: \(errorResponse)")
//                }
            } catch {
                print("SignIn Network Error: \(error.localizedDescription)")
            }
        }
    }
    
}

extension LoginViewModel {
    struct Dependencies {
        let router: Router
        let networkService: AuthenticationService
        
        static var standard: Dependencies {
            return .init(router: SharedDependencies.sharedDependencies.router, networkService: SharedDependencies.sharedDependencies.networkService)
        }
    }
}
