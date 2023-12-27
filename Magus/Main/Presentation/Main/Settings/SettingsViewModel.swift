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
    let guideRelay = BehaviorRelay<[GuideModel]>(value: [])
    private let ipoRelay = BehaviorRelay<[IPO]>(value: [])
    let searchFAQsRelay = BehaviorRelay<String>(value: "")
    var ipoObservable: Observable<[IPO]> { ipoRelay.asObservable() }
    var faqsObservable: Observable<[FAQsSection]> { faqsRelay.asObservable() }
    var guideObservable: Observable<[GuideModel]> { guideRelay.asObservable() }
    
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
                                FAQsModel(description: faqs.answer, potentialHeight: 0, didLoadScrollHeight: { [weak self] scrollHeight in
                                    self?.updateHeight(faqs: faqs, height: scrollHeight)
                                })
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
    
    private func updateHeight(faqs: FAQs, height: CGFloat) {
        guard let index = faqsRelay.value.firstIndex(where: { $0.title == faqs.question}) else { return }
        let old = faqsRelay.value[index]
        let oldItem = old.items[0]
        let item = FAQsModel(description: oldItem.description, potentialHeight: height)
        let section = FAQsSection(items: [item], title: faqs.question, isCollapsed: faqsRelay.value[index].isCollapsed, tapHandler: { [weak self] in
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
                guideRelay.accept(
                    response.map { guide in
                        GuideModel(image: guide.image, description: guide.description, potentialHeight: 0) { [weak self] scrollHeight in
                            self?.updateHeight(guide: guide, height: scrollHeight)
                        }
                        
                    }
                )
            } catch(let error) {
                Logger.error("Fetching of Guide failed \(error.localizedDescription)", topic: .network)
            }
        }
    }
    
    private func updateHeight(guide: Guide, height: CGFloat) {
        guard let index = guideRelay.value.firstIndex(where: { $0.description == guide.description}) else { return }
        let old = guideRelay.value[index]
        let item = GuideModel(image: old.image, description: old.description, potentialHeight: height)
        var guides = guideRelay.value
        guides[index] = item
        guideRelay.accept(guides)
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
        var didLoadScrollHeight: ((_ scrollHeight: CGFloat) -> Void)?
    }
    
    struct GuideModel {
        let image: String
        let description: String
        var potentialHeight: CGFloat
        var didLoadScrollHeight: ((_ scrollHeight: CGFloat) -> Void)?
    }
    
}
