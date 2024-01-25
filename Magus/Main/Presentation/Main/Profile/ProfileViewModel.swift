//
//  ProfileViewModel.swift
//  Magus
//
//  Created by Jomz on 7/27/23.
//

import Foundation
import RxSwift
import RxRelay

class ProfileViewModel: ViewModel {
    let tabSelections: [TabSelection] = [.mood, .sub, .settings]
    private let moodViewTypeRelay = BehaviorRelay<MoodViewType>(value: .weekly)
    var moodViewTypeObservable: Observable<MoodViewType> { moodViewTypeRelay.asObservable() }
    var calendar = Calendar(identifier: .gregorian)
    let calendarDatesRelay = BehaviorRelay<[CalendarMonth]>(value: [])
    let user: () -> User?
    
    init(dependencies: Dependencies = .standard) {
        user = dependencies.user
        super.init()
        generateDate()
    }
    
    func selectMood(_ type: MoodViewType) {
        moodViewTypeRelay.accept(type)
    }
    
    private func generateDate() {
        let currentDate = Date()
        let year = calendar.component(.year, from: currentDate)
        let month = calendar.component(.month, from: currentDate)
        let start = calendar.date(from: DateComponents(year: year - 1, month: 1, day: 1))!
        let end = calendar.date(from: DateComponents(year: year, month: month, day: 31))!
        let months = calendar.generateDates(inside: .init(start: start, end: end), matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)).map { date -> CalendarMonth in
            let calendarDays: [Day] = getDays(monthDate: date)
            let monthDays: [WeekDay] = getWeekdays2(days: calendarDays, month: date)
            return CalendarMonth.init(month: date, days: calendarDays, monthDays: monthDays)
        }
//        months.remove(at: 0)
        guard let currentMonth = months.lastIndex(where: { $0.month.getDateFormat(with: "MMMM YYYY") == currentDate.getDateFormat(with: "MMMM YYYY") }) else { return }
    }
    
    private func getDays(monthDate: Date) -> [Day] {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: monthDate),
            let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
            let monthLastWeek = calendar.dateInterval(of: .month, for: monthInterval.end)
        else { return [] }
        return calendar.generateDates(
            inside: DateInterval(start: monthFirstWeek.start, end: monthLastWeek.end),
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        ).map({ Day(date: $0) })
    }
    
    private func getWeekdays2(days: [Day], month: Date) -> [WeekDay] {
        var weekDays: [WeekDay] = []
        var weekDay: WeekDay!
        for day in days {
            let dayOfTheWeek = calendar.component(.weekday, from: day.date)
            let dayMonth = calendar.component(.month, from: day.date)
            let myMonth = calendar.component(.month, from: month)
            if myMonth != dayMonth && weekDay == nil {
                continue
            }
            if myMonth <= dayMonth {
                if weekDay == nil {
                    weekDay = WeekDay(startDate: day.date)
                }
                weekDay.dates.append(day.date)
                if dayOfTheWeek == 7 {
                    weekDay.endDate = day.date
                    weekDays.append(weekDay)
                    weekDay = nil
                }
            }
        }
        return weekDays
    }
    
}

extension ProfileViewModel {
    
    struct Dependencies {
        let user: () -> User?
        
        static var standard: Dependencies {
            return .init(
                user: { SharedDependencies.sharedDependencies.store.appState.user }
            )
        }
    }
    enum TabSelection {
        case mood
        case sub
        case settings
        
        var index: Int {
            switch self {
            case .mood:
                return 0
            case .sub:
                return 1
            case .settings:
                return 2
            }
        }
        
        var title: String {
            switch self {
            case .mood:
                return "My Mood"
            case .sub:
                return "My Subs"
            case .settings:
                return "Settings"
            }
        }
    }
    
    enum MoodViewType {
        case weekly
        case monthly
    }
}

struct WeeklyData: Identifiable {
    let day: String
    let dayString: String
    let mood: Mood?
    let subliminal: Subliminal?
    
    var id: String {
        return day
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
