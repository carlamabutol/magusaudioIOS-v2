//
//  SettingsViewModel.swift
//  Magus
//
//  Created by Jomz on 8/17/23.
//

import Foundation
import RxRelay
import RxSwift
import RxDataSources

class SettingsViewModel: ViewModel {
    
    private let router: Router
    private let store: Store
    private let settingsUseCase: SettingsUseCase
    let faqsRelay = BehaviorRelay<[FAQsSection]>(value: [])
    private let guideRelay = BehaviorRelay<[Guide]>(value: [])
    private let ipoRelay = BehaviorRelay<[IPO]>(value: [])
    let searchFAQsRelay = BehaviorRelay<String>(value: "")
    var ipoObservable: Observable<[IPO]> { ipoRelay.asObservable() }
    var faqsObservable: Observable<[FAQsSection]> { faqsRelay.asObservable() }
    var guideObservable: Observable<[Guide]> { guideRelay.asObservable() }
    
    init(dependencies: SettingsViewModel.Dependencies = .standard) {
        router = dependencies.router
        store = dependencies.store
        settingsUseCase = dependencies.settingsUseCase
        super.init()
        getGuide()
        getIPO()
        
        searchFAQsRelay.asObservable()
            .debounce(dependencies.searchDebounceTime, scheduler: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .subscribe { [weak self] search in
                self?.getFAQs(search: search)
            }
            .disposed(by: disposeBag)
    }
    
    func logout() {
        store.removeAppState()
        router.logout()
    }
    
    func setSearchFilter(_ search: String) {
        searchFAQsRelay.accept(search)
    }
    
    func getFAQs(search: String = "") {
        Task {
            do {
                let response = try await settingsUseCase.getFAQs(search: search)
                faqsRelay.accept(
                    response.map { faqs in
                        FAQsSection(
                            items: [
                                FAQsModel(description: faqs.answer, potentialHeight: 0)
                            ],
                            title: faqs.question,
                            isCollapsed: false,
                            tapHandler: { [weak self] in
                                self?.updateIsCollapsed(faqs: faqs)
                            }
                        )
                    }
                )
            } catch(let error) {
                Logger.error("Fetching of FAQs failed \(error.localizedDescription)", topic: .network)
            }
        }
    }
    
    private func updateIsCollapsed(faqs: FAQs) {
        guard let index = faqsRelay.value.firstIndex(where: { $0.title == faqs.question}) else { return }
        let old = faqsRelay.value[index]
        let section = FAQsSection(items: old.items, title: faqs.question, isCollapsed: !faqsRelay.value[index].isCollapsed, tapHandler: { [weak self] in
            self?.updateIsCollapsed(faqs: faqs)
        })
        var faqs = faqsRelay.value
        faqs[index] = section
        faqsRelay.accept(faqs)
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
        let searchDebounceTime: RxTimeInterval
        
        static var standard: Dependencies {
            return .init(
                store: SharedDependencies.sharedDependencies.store,
                router: SharedDependencies.sharedDependencies.router,
                networkService: SharedDependencies.sharedDependencies.networkService,
                settingsUseCase: SharedDependencies.sharedDependencies.useCases.settingsUseCase,
                searchDebounceTime: .milliseconds(200)
            )
        }
    }
    
}

extension SettingsViewModel {
    
    
    struct FAQsSection: SectionModelType {
        
        
        typealias Item = SettingsViewModel.FAQsModel
        
        var items: [Item]
        var title: String?
        var isCollapsed: Bool
        var tapHandler: CompletionHandler?
        
        init(items: [Item], title: String? = nil, isCollapsed: Bool = false, tapHandler: CompletionHandler? = nil) {
            self.items = items
            self.title = title
            self.isCollapsed = isCollapsed
            self.tapHandler = tapHandler
        }
        
        init(original: SettingsViewModel.FAQsSection, items: [Item]) {
            self = original
            self.items = items
        }
    }
    
    struct FAQsModel {
        let description: String
        var potentialHeight: CGFloat
    }
}
