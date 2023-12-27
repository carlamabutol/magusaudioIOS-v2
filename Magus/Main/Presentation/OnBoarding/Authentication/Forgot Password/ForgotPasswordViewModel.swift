//
//  ForgotPasswordViewModel.swift
//  Magus
//
//  Created by Jose Mari Pascual on 5/27/23.
//

import Foundation
import RxSwift
import RxCocoa

class ForgotPasswordViewModel: ViewModel {
    private let store: Store
    private let router: Router
    private let networkService: NetworkService
    private let authenticationUseCase: AuthenticationUseCase
    
    let emailRelay = BehaviorRelay<String>(value: "")
    let alertRelay = PublishRelay<AlertModelEnum>()
    let backRelay = PublishRelay<Void>()
    
    var submitButtonIsEnabled: Observable<Bool> { emailRelay.map { !$0.isEmpty }.asObservable() }
    
    init(dependency: ForgotPasswordViewModel.Dependencies = .standard) {
        self.store = dependency.store
        self.router = dependency.router
        self.networkService = dependency.networkService
        self.authenticationUseCase = dependency.authenticationUseCase
    }
    
    func forgotPassword() {
        let email = emailRelay.value
        alertRelay.accept(.loading(true))
        Task {
            do {
                let response = try await authenticationUseCase.forgotPassword(email: email)
                alertRelay.accept(
                    .alertModal(.init(title: "", message: response.message, actionHandler: { [weak self] in
                        if response.success {
                            self?.backRelay.accept(())
                        }
                    }))
                )
            } catch {
                alertRelay.accept(
                    .alertModal(.init(title: "Failed", message: "Please try again later.", actionHandler: {
                        
                    }))
                )
            }
        }
    }
    
}

extension ForgotPasswordViewModel {
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
