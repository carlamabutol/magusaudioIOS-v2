//
//  ProfileMoodViewModel.swift
//  Magus
//
//  Created by Jomz on 9/20/23.
//

import Foundation
import RxSwift
import RxRelay

class ProfileMoodViewModel: ViewModel {
    
    private let dateTodayRelay = PublishRelay<Date>()
    private let weeklyDataRelay = PublishRelay<[WeeklyData]>()
    var weeklyDataObservable: Observable<[WeeklyData]> { weeklyDataRelay.asObservable()}
    private let networkService: NetworkService
    private let getUserID: () -> String?
    private let moodUseCase: MoodUseCase
    let calendar = Calendar.current
    var now: Date {
        get {
            return Date()
        }
    }
    
    init(dependency: ProfileMoodViewModel.Dependencies = .standard) {
        networkService = dependency.networkService
        getUserID = dependency.getUserID
        moodUseCase = dependency.moodUseCase
        super.init()
        getAllMoods()
        getWeeklyDates()
    }
    
    private func getWeeklyDates() {
        let weeklyDates = getAllDatesInWeek(forDate: now).map { WeeklyData(day: $0.dayToday(with: "EE"), dayString: $0.dayToday(with: "dd"), mood: nil) }
        Logger.info("WeeklyDates \(weeklyDates)", topic: .presentation)
    }
    
    func getAllDatesInWeek(forDate date: Date) -> [Date] {
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!

        var currentDay = startOfWeek
        var allDatesInWeek: [Date] = []

        while currentDay <= endOfWeek {
            allDatesInWeek.append(currentDay)
            currentDay = calendar.date(byAdding: .day, value: 1, to: currentDay)!
        }

        return allDatesInWeek
    }
    
    func getAllMoods() {
        Task {
            do {
                let month = now.getDateFormat(with: "yyyy-MM")
                Logger.info("Selected Month \(month)", topic: .presentation)
                let calendarResponse = try await moodUseCase.getMoodCalendar(month: month)
                let weeklyMoods = calendarResponse.weekly.map { WeeklyData(day: $0.day, dayString: $0.week, mood: $0.mood)}
                weeklyDataRelay.accept(weeklyMoods)
            } catch {
                Logger.error("Calendar ErrorResponse - \(error.localizedDescription)", topic: .presentation)
            }
        }
        
    }
    
}

extension ProfileMoodViewModel {
    
    struct Dependencies {
        let store: Store
        let router: Router
        let networkService: NetworkService
        let moodUseCase: MoodUseCase
        let getUserID: () -> String?
        
        static var standard: Dependencies {
            return .init(
                store: SharedDependencies.sharedDependencies.store,
                router: SharedDependencies.sharedDependencies.router,
                networkService: SharedDependencies.sharedDependencies.networkService,
                moodUseCase: SharedDependencies.sharedDependencies.useCases.moodUseCase,
                getUserID: { SharedDependencies.sharedDependencies.store.appState.userId }
            )
        }
    }
    
}
