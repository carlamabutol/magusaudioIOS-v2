//
//  MoodViewModel.swift
//  Magus
//
//  Created by Jomz on 6/7/23.
//

import Foundation
import RxSwift
import RxCocoa

class MoodViewModel: ViewModel {
    private let store: Store
    private let router: Router
    private let networkService: NetworkService
    
    let moodListRelay = BehaviorRelay<[MoodCell.Model]>(value: [])
    var moodListObservable: Observable<[MoodCell.Model]> { moodListRelay.asObservable() }
    var moodCollectionHiddenObservable: Observable<Bool> { moodListRelay.map { $0.isEmpty }.asObservable() }
    var loadingSpinnerObservable: Observable<Bool> { moodListRelay.map { !$0.isEmpty }.asObservable() }
    var moodSelectedObservable: Observable<Bool> { moodListRelay.map { !$0.filter({ $0.isSelected }).isEmpty }.asObservable() }
    
    // TODO: GET FROM APP STATE
    var userId: String {
        return "zKIsn2ks28UZqDc1PBDAVW"
    }
    
    init(dependencies: Dependencies = .standard) {
        store = dependencies.store
        router = dependencies.router
        networkService = dependencies.networkService
    }
    
    func getMoodList() {
        Task {
            let response = try await networkService.getAllMoods()
            self.moodListRelay.accept(response.data.map { mood in
                return MoodCell.Model(id: mood.id, title: mood.name, image: mood.image, selectedColor: mood.description, isSelected: false) { [weak self] in
                    self?.didSelectMood(mood)
                }
            })
        }
    }
    
    private func didSelectMood(_ mood: Mood) {
        var moodList = moodListRelay.value.map { model in
            var model = model
            model.isSelected = false
            return model
        }
        guard let index = moodList.lastIndex(where: { $0.id == mood.id }) else { return }
        moodList[index].isSelected = !moodList[index].isSelected
        moodListRelay.accept(moodList)
    }
    
    func updateSelectedMood() {
        guard let selectedMood = moodListRelay.value.first(where: { $0.isSelected }) else { return }
        Task {
            let response = try await networkService.updateSelectedMoods(userId: userId, moodId: selectedMood.id)
            store.saveAppState()
            router.selectedRoute = .home
        }
    }
    
}

extension MoodViewModel {
    
    struct SectionMood {
        let mood: [Mood]
    }
    
}

extension MoodViewModel {
    struct Dependencies {
        let store: Store
        let router: Router
        let networkService: NetworkService
        
        static var standard: Dependencies {
            return .init(store: SharedDependencies.sharedDependencies.store,
                         router: SharedDependencies.sharedDependencies.router,
                         networkService: SharedDependencies.sharedDependencies.networkService)
        }
    }
}

