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
    private let store: Store
    private let router: Router
    private let networkService: NetworkService
    
    let userName = BehaviorRelay<String>(value: "")
    var userNameObservable: Observable<String> { userName.asObservable() }
    
    let password = BehaviorRelay<String>(value: "")
    var passwordObservable: Observable<String> { password.asObservable() }
    
    init(dependencies: Dependencies = .standard) {
        store = dependencies.store
        router = dependencies.router
        networkService = dependencies.networkService
    }
    
    func loginAction() {
        router.selectedRoute = .mood
        if userName.value.count < 8, password.value.count < 8 {
            Logger.warning("Username or Password is less than 8 characters", topic: .other)
            return
        }
        Task {
            do {
                let response = try await networkService.signIn(email: userName.value, password: password.value)
                store.appState.user = response.user
                store.saveAppState()
            } catch {
                Logger.error("SignIn Network Error: \(error.localizedDescription)", topic: .network)
            }
        }
    }
    
}

extension LoginViewModel {
    struct Dependencies {
        let store: Store
        let router: Router
        let networkService: NetworkService
        
        static var standard: Dependencies {
            return .init(store: SharedDependencies.sharedDependencies.store,
                         router: SharedDependencies.sharedDependencies.router,
                         networkService: SharedDependencies.sharedDependencies.networkService)
        }
    }
}
