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
    private let authenticationUseCase: AuthenticationUseCase
    
    let userName = BehaviorRelay<String>(value: "")
    var userNameObservable: Observable<String> { userName.asObservable() }
    
    let password = BehaviorRelay<String>(value: "")
    var passwordObservable: Observable<String> { password.asObservable() }
    
    let alertRelay = PublishRelay<String>()
    
    init(dependencies: Dependencies = .standard) {
        store = dependencies.store
        router = dependencies.router
        networkService = dependencies.networkService
        authenticationUseCase = dependencies.authenticationUseCase
    }
    
    func loginAction() {
        if userName.value.count < 8, password.value.count < 8 {
            Logger.warning("Username or Password is less than 8 characters", topic: .other)
            return
        }
        Task {
            let result = await authenticationUseCase.signIn(email: userName.value, password: password.value)
            switch result {
            case .success:
                DispatchQueue.main.async { [weak self] in
                    self?.router.selectedRoute = .mood
                }
            case .failure(let error):
                alertRelay.accept(error.errorMesasge)
                Logger.error("SignIn Network Error: \(error.errorMesasge)", topic: .network)
            }
        }
    }
    
}

extension LoginViewModel {
    struct Dependencies {
        let store: Store
        let router: Router
        let networkService: NetworkService
        let authenticationUseCase: AuthenticationUseCase
        
        static var standard: Dependencies {
            return .init(
                store: SharedDependencies.sharedDependencies.store,
                router: SharedDependencies.sharedDependencies.router,
                networkService: SharedDependencies.sharedDependencies.networkService,
                authenticationUseCase: SharedDependencies.sharedDependencies.useCases.authenticationUseCase
            )
        }
    }
}
