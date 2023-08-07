//
//  EditProfileViewModel.swift
//  Magus
//
//  Created by Jomz on 8/5/23.
//

import Foundation
import RxSwift

class EditProfileViewModel: ViewModel {
    
    private var user: () -> User?
    
    init(sharedDependencies: EditProfileViewModel.Dependencies = .standard) {
        user = sharedDependencies.user
        super.init()
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
