//
//  SignUpViewModel.swift
//  Magus
//
//  Created by Jose Mari Pascual on 5/23/23.
//

import Foundation
import RxCocoa
import RxSwift

class SignUpViewModel: ViewModel {
    private let store: Store
    private let router: Router
    private let networkService: NetworkService
    private let authenticationUseCase: AuthenticationUseCase
    
    let fullNameRelay = BehaviorRelay(value: "")
    let emailRelay = BehaviorRelay(value: "")
    let passwordRelay = BehaviorRelay(value: "")
    let confirmPasswordRelay = BehaviorRelay(value: "")
    
    let alertModel = PublishRelay<LoginAlertViewController.AlertModel?>()
    var alertModelObservable: Observable<LoginAlertViewController.AlertModel> { alertModel.compactMap{ $0 }.asObservable() }
    
    
    let passwordWrongInputRelay = PublishRelay<String>()
    let confirmPasswordWrongInputRelay = PublishRelay<String>()
    
    private let checkboxState = BehaviorRelay<Bool>(value: false)
    var checkboxStateObsevable: Observable<Bool> { checkboxState.asObservable() }
    private let isLoading = PublishRelay<Bool>()
    var isLoadingObservable: Observable<Bool> { isLoading.asObservable() }
    
    init(dependencies: SignUpViewModel.Dependencies = .standard) {
        store = dependencies.store
        router = dependencies.router
        networkService = dependencies.networkService
        authenticationUseCase = dependencies.authenticationUseCase
    }
    
    func changeCheckboxState() {
        let state = !checkboxState.value
        checkboxState.accept(state)
    }
    
    func signUp() {
        if passwordRelay.value.lessThan8Characters() {
            alertModel.accept(.init(message: "Password must be greater than 8 characters", image: nil))
            return
        }
        if confirmPasswordRelay.value.lessThan8Characters() {
            alertModel.accept(.init(message: "Confirm Password must be greater than 8 characters", image: nil))
            return
        }
        if !passwordRelay.value.containsUppercaseLetter() {
            alertModel.accept(.init(message: "Password must contain atleast one uppercase character", image: nil))
            return
        }
        if !confirmPasswordRelay.value.containsUppercaseLetter() {
            alertModel.accept(.init(message: "Confirm Password must contain atleast one uppercase character", image: nil))
            return
        }
        if passwordRelay.value != confirmPasswordRelay.value {
            alertModel.accept(.init(message: "Password and Confirm Password does not match", image: nil))
            return
        }
        if fullNameRelay.value.isEmpty || emailRelay.value.isEmpty {
            alertModel.accept(.init(message: "Your name or email must not be empty", image: nil))
            return
        }
        if !checkboxState.value {
            alertModel.accept(.init(message: "You must agree to the terms and condition", image: nil))
            return
        }
        isLoading.accept(true)
        Task {
            do {
                let result = await authenticationUseCase.signUp(name: fullNameRelay.value, email: emailRelay.value, password: passwordRelay.value)
                switch result {
                case .success:
                    DispatchQueue.main.async { [weak self] in
                        self?.router.selectedRoute = .mood
                    }
                case .failure(let error):
                    alertModel.accept(.init(message: error.errorMesasge, image: nil))
                    Logger.error("SignUp Network Error: \(error.errorMesasge)", topic: .network)
                }
                isLoading.accept(false)
            }
        }
        
    }
    
}

extension SignUpViewModel {
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


