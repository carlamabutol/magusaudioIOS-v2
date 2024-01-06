//
//  EditProfileViewModel.swift
//  Magus
//
//  Created by Jomz on 8/5/23.
//

import Foundation
import RxSwift
import RxRelay
import Photos
import AVFoundation

class EditProfileViewModel: ViewModel {
    
    private var user: () -> User?
    var firstNameRelay: BehaviorRelay<String>
    var lastNameRelay: BehaviorRelay<String>
    var emailRelay: BehaviorRelay<String>
    var showSaveButton = PublishRelay<Bool>()
    private let alertModel = PublishRelay<ProfileAlertViewController.AlertModel>()
    var alertModelObservable: Observable<ProfileAlertViewController.AlertModel> { alertModel.asObservable() }
    
    let profileUseCase: ProfileUseCase
    
    init(sharedDependencies: EditProfileViewModel.Dependencies = .standard) {
        user = sharedDependencies.user
        firstNameRelay = BehaviorRelay(value: user()?.info.firstName ?? "")
        lastNameRelay = BehaviorRelay(value: user()?.info.lastName ?? "")
        emailRelay = BehaviorRelay(value: user()?.email ?? "")
        profileUseCase = sharedDependencies.profileUseCase
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
    
    func updateUserDetails() {
        Task {
            let result = await profileUseCase.updateProfileDetails(firstName: firstNameRelay.value, lastName: lastNameRelay.value)
            switch result {
            case .success(let user):
                self.alertModel.accept(.init(message: "Profile successfully updated.", image: .goodPassword))
                Logger.info("Updated User \(user)", topic: .presentation)
            case .failure(let error):
                Logger.error("updateUserDetails Network Error: \(error.localizedDescription)", topic: .network)
            }
        }
    }
    
    func changeProfilePhoto(_ data: Data) {
        Task {
            do {
                let result = await profileUseCase.updateProfilePhoto(photo: data)
                self.alertModel.accept(.init(message: "Profile Photo successfully updated.", image: .goodPassword))
                Logger.info("updateProfilePhoto \(result)", topic: .presentation)
            } catch {
                Logger.error("updateProfilePhoto Network Error: \(error.localizedDescription)", topic: .network)
            }
        }
    }
    
}

extension EditProfileViewModel {
    
    struct Dependencies {
        let user: () -> User?
        let router: Router
        let networkService: NetworkService
        let profileUseCase: ProfileUseCase
        
        static var standard: Dependencies {
            return .init(
                user: { SharedDependencies.sharedDependencies.store.appState.user },
                router: SharedDependencies.sharedDependencies.router,
                networkService: SharedDependencies.sharedDependencies.networkService,
                profileUseCase: SharedDependencies.sharedDependencies.useCases.profileUseCase
            )
        }
    }
    
}
