//
//  ProfileMoodViewModel.swift
//  Magus
//
//  Created by Jomz on 9/20/23.
//

import Foundation
import RxSwift

class ProfileMoodViewModel: ViewModel {
    
    
    
    let weeklyData: [WeeklyData] = [
        .init(day: "20", dayString: "Sun"),
        .init(day: "19", dayString: "Sat"),
        .init(day: "18", dayString: "Fri"),
        .init(day: "17", dayString: "Thu"),
        .init(day: "16", dayString: "Wed"),
        .init(day: "15", dayString: "Tue"),
        .init(day: "14", dayString: "Mon"),
    ]
    
    private let networkService: NetworkService
    private let getUserID: () -> String?
    
    init(dependency: ProfileMoodViewModel.Dependencies = .standard) {
        networkService = dependency.networkService
        getUserID = dependency.getUserID
        super.init()
        getAllMoods()
    }
    
    func getAllMoods() {
        guard let userId = getUserID() else { return }
        Task {
            do {
                let response = try await networkService.getMoodCalendar(userId: userId)
                switch response {
                case .success(let array):
                    Logger.info("Moods - \(array)", topic: .presentation)
                case .error(let errorResponse):
                    Logger.info("Moods ErrorResponse - \(errorResponse)", topic: .presentation)
                }
            } catch {
                Logger.error("Moods ErrorResponse - \(error.localizedDescription)", topic: .presentation)
            }
        }
        
    }
    
}

extension ProfileMoodViewModel {
    
    struct Dependencies {
        let store: Store
        let router: Router
        let networkService: NetworkService
        let getUserID: () -> String?
        
        static var standard: Dependencies {
            return .init(
                store: SharedDependencies.sharedDependencies.store,
                router: SharedDependencies.sharedDependencies.router,
                networkService: SharedDependencies.sharedDependencies.networkService,
                getUserID: { SharedDependencies.sharedDependencies.store.appState.userId }
            )
        }
    }
    
}
