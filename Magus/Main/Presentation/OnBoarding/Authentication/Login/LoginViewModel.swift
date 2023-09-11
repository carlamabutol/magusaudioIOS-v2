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
    
    let alertModel = PublishRelay<LoginAlertViewController.AlertModel?>()
    var alertModelObservable: Observable<LoginAlertViewController.AlertModel> { alertModel.compactMap{ $0 }.asObservable() }
    private let isLoading = PublishRelay<Bool>()
    var isLoadingObservable: Observable<Bool> { isLoading.asObservable() }
    let alertRelay = PublishRelay<String>()
    
    init(dependencies: Dependencies = .standard) {
        store = dependencies.store
        router = dependencies.router
        networkService = dependencies.networkService
        authenticationUseCase = dependencies.authenticationUseCase
    }
    
    func loginAction() {
        if userName.value.count < 8, password.value.count < 8 {
            alertModel.accept(.init(message: LocalizedStrings.Login.signInError, image: nil))
            Logger.warning(LocalizedStrings.Login.signInError, topic: .other)
            return
        }
        isLoading.accept(true)
        Task {
            let result = await authenticationUseCase.signIn(email: userName.value, password: password.value)
            switch result {
            case .success:
                DispatchQueue.main.async { [weak self] in
                    self?.router.selectedRoute = .mood
                }
            case .failure(let error):
                alertModel.accept(.init(message: error.errorMesasge, image: nil))
                Logger.error("SignIn Network Error: \(error.errorMesasge)", topic: .network)
            }
            isLoading.accept(false)
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
