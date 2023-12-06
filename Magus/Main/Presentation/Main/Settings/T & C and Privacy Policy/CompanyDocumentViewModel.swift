//
//  CompanyViewModel.swift
//  Magus
//
//  Created by Jomz on 12/2/23.
//

import Foundation
import RxRelay
import RxSwift

class CompanyDocumentViewModel: ViewModel {
    
    private let router: Router
    private let store: Store
    private let networkService: NetworkService
    private let document = PublishRelay<String>()
    var documentObservable: Observable<String> { document.asObservable() }
    
    init(dependencies: SettingsViewModel.Dependencies = .standard) {
        router = dependencies.router
        store = dependencies.store
        networkService = dependencies.networkService
    }
    
    func getDocument(type: DocuType) {
        switch type {
        case .privacy:
            getPrivacy()
        case .terms:
            getTermsAndCondition()
        }
    }
    
    private func getPrivacy() {
        Task {
            do {
                let response = try await networkService.getPrivacy()
                switch response {
                case .success(let document):
                    self.document.accept(document)
                case .error(let errorResponse):
                    Logger.error("Couldn't get privacy policy", topic: .network)
                }
            }
        }
    }
    
    private func getTermsAndCondition() {
        Task {
            do {
                let response = try await networkService.getTermsAndCondition()
                switch response {
                case .success(let document):
                    self.document.accept(document)
                case .error(let errorResponse):
                    Logger.error("Couldn't get terms and condition", topic: .network)
                }
            }
        }
    }
    
}

extension CompanyDocumentViewModel {
    
    enum DocuType: String {
        case privacy = "Privacy Policy"
        case terms = "Terms and Condition"
    }
    
    struct Dependencies {
        let store: Store
        let router: Router
        let networkService: NetworkService
        
        static var standard: Dependencies {
            return .init(
                store: SharedDependencies.sharedDependencies.store,
                router: SharedDependencies.sharedDependencies.router,
                networkService: SharedDependencies.sharedDependencies.networkService
            )
        }
    }
    
}
