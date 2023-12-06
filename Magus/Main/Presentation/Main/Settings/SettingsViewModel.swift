//
//  SettingsViewModel.swift
//  Magus
//
//  Created by Jomz on 8/17/23.
//

import Foundation
import RxRelay
import RxSwift

class SettingsViewModel: ViewModel {
    
    private let router: Router
    private let store: Store
    private let settingsUseCase: SettingsUseCase
    private let faqsRelay = BehaviorRelay<[FAQs]>(value: [])
    private let guideRelay = BehaviorRelay<[Guide]>(value: [])
    private let ipoRelay = BehaviorRelay<[IPO]>(value: [])
    var ipoObservable: Observable<[IPO]> { ipoRelay.asObservable() }
    var faqsObservable: Observable<[FAQs]> { faqsRelay.asObservable() }
    var guideObservable: Observable<[Guide]> { guideRelay.asObservable() }
    
    init(dependencies: SettingsViewModel.Dependencies = .standard) {
        router = dependencies.router
        store = dependencies.store
        settingsUseCase = dependencies.settingsUseCase
        super.init()
        getFAQs()
        getGuide()
        getIPO()
    }
    
    func logout() {
        store.removeAppState()
//        router.logout()
    }
    
    func getFAQs() {
        Task {
            do {
                let response = try await settingsUseCase.getFAQs()
                faqsRelay.accept(response)
            } catch(let error) {
                Logger.error("Fetching of FAQs failed \(error.localizedDescription)", topic: .network)
            }
        }
    }
    
    func getGuide() {
        Task {
            do {
                let response = try await settingsUseCase.getGuide()
                guideRelay.accept(response)
            } catch(let error) {
                Logger.error("Fetching of Guide failed \(error.localizedDescription)", topic: .network)
            }
        }
    }
    
    func getIPO() {
        Task {
            do {
                let response = try await settingsUseCase.getIPO()
                ipoRelay.accept(response)
            } catch(let error) {
                Logger.error("Fetching of IPO failed \(error.localizedDescription)", topic: .network)
            }
        }
    }
    
}

extension SettingsViewModel {
    
    struct Dependencies {
        let store: Store
        let router: Router
        let networkService: NetworkService
        let settingsUseCase: SettingsUseCase
        
        static var standard: Dependencies {
            return .init(
                store: SharedDependencies.sharedDependencies.store,
                router: SharedDependencies.sharedDependencies.router,
                networkService: SharedDependencies.sharedDependencies.networkService,
                settingsUseCase: SharedDependencies.sharedDependencies.useCases.settingsUseCase
            )
        }
    }
    
}
