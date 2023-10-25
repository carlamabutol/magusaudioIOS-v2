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
    private let moodUseCase: MoodUseCase
    
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
        moodUseCase = dependencies.moodUseCase
    }
    
    func loginAction() {
        if userName.value.count < 8, password.value.count < 8 {
            alertModel.accept(.init(message: LocalisedStrings.Login.signInError, image: nil))
            Logger.warning(LocalisedStrings.Login.signInError, topic: .other)
            return
        }
        isLoading.accept(true)
        Task {
            let result = await authenticationUseCase.signIn(email: userName.value, password: password.value)
            switch result {
            case .success:
                getCurrentMood()
            case .failure(let error):
                alertModel.accept(.init(message: error.errorMesasge, image: nil))
                Logger.error("SignIn Network Error: \(error.errorMesasge)", topic: .network)
            }
            isLoading.accept(false)
        }
    }
    
    func getCurrentMood() {
        Task {
            do {
                _ = try await moodUseCase.getCurrentMood()
                DispatchQueue.main.async { [weak self] in
                    if self?.store.appState.selectedMood != nil {
                        self?.router.selectedRoute = .home
                    } else {
                        self?.router.selectedRoute = .mood
                    }
                }
            } catch {
                Logger.error(error.localizedDescription, topic: .presentation)
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
        let moodUseCase: MoodUseCase
        
        static var standard: Dependencies {
            return .init(
                store: SharedDependencies.sharedDependencies.store,
                router: SharedDependencies.sharedDependencies.router,
                networkService: SharedDependencies.sharedDependencies.networkService,
                authenticationUseCase: SharedDependencies.sharedDependencies.useCases.authenticationUseCase,
                moodUseCase: SharedDependencies.sharedDependencies.useCases.moodUseCase
            )
        }
    }
}
