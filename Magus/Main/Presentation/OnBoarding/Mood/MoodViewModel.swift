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
    private let moodUseCase: MoodUseCase
    
    var moods: [Mood] = []
    let moodListRelay = BehaviorRelay<[MoodCell.Model]>(value: [])
    var moodListObservable: Observable<[MoodCell.Model]> { moodListRelay.asObservable() }
    var moodCollectionHiddenObservable: Observable<Bool> { moodListRelay.map { $0.isEmpty }.asObservable() }
    var loadingSpinnerObservable: Observable<Bool> { moodListRelay.map { !$0.isEmpty }.asObservable() }
    var moodSelectedObservable: Observable<Bool> { moodListRelay.map { !$0.filter({ $0.isSelected }).isEmpty }.asObservable() }
    
    init(dependencies: Dependencies = .standard) {
        store = dependencies.store
        router = dependencies.router
        moodUseCase = dependencies.moodUseCase
    }
    
    func getMoodList() {
        Task {
            do {
                moods = try await moodUseCase.getAllMoods()
                let models = constructModels(moods: moods)
                moodListRelay.accept(models)
            } catch {
                Logger.warning(error.localizedDescription, topic: .presentation)
            }
        }
    }
    
    private func constructModels(moods: [Mood]) -> [MoodCell.Model] {
        return moods.map { mood in
            return MoodCell.Model(
                id: mood.id,
                title: mood.name,
                image: mood.image,
                selectedColor: mood.description,
                isSelected: false
            ) { [weak self] in
                self?.didSelectMood(mood)
            }
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
            do {
                let response = try await moodUseCase.updateSelectedMood(moodId: selectedMood.id)
                store.appState.allMoods = moods 
                store.appState.selectedMood = moods.first(where: { $0.id == selectedMood.id })
                store.saveAppState()
                router.selectedRoute = .home
                Logger.info(response.message, topic: .presentation)
            }
            catch {
                Logger.error(error.localizedDescription, topic: .domain)
            }
        }
    }
    
}

extension MoodViewModel {
    struct Dependencies {
        let store: Store
        let router: Router
        let moodUseCase: MoodUseCase
        
        static var standard: Dependencies {
            return .init(store: SharedDependencies.sharedDependencies.store,
                         router: SharedDependencies.sharedDependencies.router,
                         moodUseCase: SharedDependencies.sharedDependencies.useCases.moodUseCase)
        }
    }
}

