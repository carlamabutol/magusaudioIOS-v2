//
//  EditProfileViewModel.swift
//  Magus
//
//  Created by Jomz on 8/5/23.
//

import Foundation
import RxSwift
import RxRelay

class EditProfileViewModel: ViewModel {
    
    private var user: () -> User?
    var firstNameRelay: BehaviorRelay<String>
    var lastNameRelay: BehaviorRelay<String>
    var emailRelay: BehaviorRelay<String>
    var showSaveButton = PublishRelay<Bool>()
    
    init(sharedDependencies: EditProfileViewModel.Dependencies = .standard) {
        user = sharedDependencies.user
        firstNameRelay = BehaviorRelay(value: user()?.info.firstName ?? "")
        lastNameRelay = BehaviorRelay(value: user()?.info.lastName ?? "")
        emailRelay = BehaviorRelay(value: user()?.email ?? "")
        super.init()
        Observable.combineLatest(firstNameRelay.asObservable(),
                                                      lastNameRelay.asObservable(),
                                                      emailRelay.asObservable()
        ).map { [weak self] firstName, lastName, email in
            guard let self = self else { return false }
            let userFirstName = self.user()?.info.firstName ?? ""
            let userLastName = self.user()?.info.lastName ?? ""
            let userEmail = self.user()?.email ?? ""
            return ((userFirstName != firstName) || (userLastName != lastName) || (userEmail != email))
        }.subscribe { condition in
            self.showSaveButton.accept(condition)
        }.disposed(by: disposeBag)
        
    }
    
    func profileImage() -> URL? {
        guard let stringUrl = user()?.info.cover else { return nil }
        return .init(string: stringUrl)
    }
    
    func userEmail() -> String {
        user()?.email ?? ""
    }
    
    func userFullname() -> String {
        user()?.name ?? ""
    }
    
}

extension EditProfileViewModel {
    
    struct Dependencies {
        let user: () -> User?
        let router: Router
        let networkService: NetworkService
        let authenticationUseCase: AuthenticationUseCase
        
        static var standard: Dependencies {
            return .init(
                user: { SharedDependencies.sharedDependencies.store.appState.user },
                router: SharedDependencies.sharedDependencies.router,
                networkService: SharedDependencies.sharedDependencies.networkService,
                authenticationUseCase: SharedDependencies.sharedDependencies.useCases.authenticationUseCase
            )
        }
    }
    
}
