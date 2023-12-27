//
//  ChangePasswordViewModel.swift
//  Magus
//
//  Created by Jomz on 8/5/23.
//

import Foundation
import RxSwift
import RxRelay

class ChangePasswordViewModel: ViewModel {
    
    let currentPasswordRelay = BehaviorRelay(value: "")
    let enterNewPasswordRelay = BehaviorRelay(value: "")
    let confirmNewPasswordRelay = BehaviorRelay(value: "")
    let alertModel = PublishRelay<LoginAlertViewController.AlertModel?>()
    var alertModelObservable: Observable<LoginAlertViewController.AlertModel> { alertModel.compactMap{ $0 }.asObservable() }
    let saveButtonIsEnabled: Observable<Bool>
    let alertRelay = PublishRelay<AlertModelEnum>()
    
    let contains8CharacterObservable: Observable<ChangePasswordViewModel.PasswordRequirementModel>
    let includeNumberCharacterObservable: Observable<ChangePasswordViewModel.PasswordRequirementModel>
    let includeUppercaseCharacterObservable: Observable<ChangePasswordViewModel.PasswordRequirementModel>
    let includeLowerCharacterObservable: Observable<ChangePasswordViewModel.PasswordRequirementModel>
    
    let store: Store
    let networkService: NetworkService
    let authenticationUseCase: AuthenticationUseCase
    
    init(dependencies: ChangePasswordViewModel.Dependencies = .standard) {
        store = dependencies.store
        networkService = dependencies.networkService
        authenticationUseCase = dependencies.authenticationUseCase
        
        let currentPasswordIsAvailable = currentPasswordRelay.asObservable()
            .map { $0.count >= 8 }
        let newPasswordIsAvailable = enterNewPasswordRelay.asObservable()
            .map { $0.count >= 8 }
        let newPasswordIncludeUppercase = enterNewPasswordRelay.asObservable()
            .map { Helper.shared.containsUppercaseCharacter(text: $0) }
        let newPasswordIncludeLowercase = enterNewPasswordRelay.asObservable()
            .map { Helper.shared.containsLowercaseCharacter(text: $0) }
        let newPasswordIncludeNumbers = enterNewPasswordRelay.asObservable()
            .map { Helper.shared.containsNumberCharacter(text: $0) }
        
        contains8CharacterObservable = newPasswordIsAvailable.asObservable()
            .map { .init(imageName: $0 ? .check : .cross, text: LocalisedStrings.ChangePassword.contain8Characters) }
        
        includeNumberCharacterObservable = newPasswordIncludeNumbers.asObservable()
            .map { .init(imageName: $0 ? .check : .cross, text: LocalisedStrings.ChangePassword.includeOneNumber)
            }
        includeUppercaseCharacterObservable = newPasswordIncludeUppercase.asObservable()
            .map { .init(imageName: $0 ? .check : .cross, text: LocalisedStrings.ChangePassword.includeOneUppercase)
                
            }
        includeLowerCharacterObservable = newPasswordIncludeLowercase.asObservable()
            .map {
                .init(imageName: $0 ? .check : .cross, text: LocalisedStrings.ChangePassword.includeOneLowercase)
            }
        
        let newConfirmPasswordIsAvailable = confirmNewPasswordRelay.asObservable()
            .map { $0.count >= 8 }
        
        let validationApproved = Observable.combineLatest(newPasswordIncludeNumbers, newPasswordIncludeLowercase, newPasswordIncludeUppercase)
            .map {
                $0 && $1 && $2
            }
        
        let conditionObservable = Observable.combineLatest(currentPasswordIsAvailable, newConfirmPasswordIsAvailable, validationApproved)
            .map {
                $0 && $1 && $2
            }
        
        saveButtonIsEnabled = conditionObservable
        super.init()
        currentPasswordRelay.asObservable()
            .subscribe { currentPassword in
                Logger.info(currentPassword, topic: .presentation)
            }
            .disposed(by: disposeBag)
        enterNewPasswordRelay.asObservable()
            .subscribe { newPassword in
                Logger.info(newPassword, topic: .presentation)
            }
            .disposed(by: disposeBag)
        confirmNewPasswordRelay.asObservable()
            .subscribe { confirmedPassword in
                Logger.info(confirmedPassword, topic: .presentation)
            }
            .disposed(by: disposeBag)
    }
    
    func changePassword() {
        alertRelay.accept(.loading(true))
        Task {
            do {
                let response = try await authenticationUseCase.changePassword(
                    currentPassword: currentPasswordRelay.value,
                    newPassword: enterNewPasswordRelay.value,
                    confirmPassword: confirmNewPasswordRelay.value
                )
                alertRelay.accept(
                    .alertModal(
                        .init(title: "", message: response.message, actionHandler: {})
                    )
                )
            } catch {
                alertRelay.accept(
                    .alertModal(
                        .init(title: "", message: "Error validation", actionHandler: {})
                    )
                )
            }
        }
    }
    
}

extension ChangePasswordViewModel {
    struct PasswordRequirementModel {
        let imageName: ImageAsset
        let text: String
    }
}

extension ChangePasswordViewModel {
    struct Dependencies {
        let store: Store
        let networkService: NetworkService
        let authenticationUseCase: AuthenticationUseCase
        
        static var standard: Dependencies {
            return .init(
                store: SharedDependencies.sharedDependencies.store,
                networkService: SharedDependencies.sharedDependencies.networkService,
                authenticationUseCase: SharedDependencies.sharedDependencies.useCases.authenticationUseCase
            )
        }
    }
}
