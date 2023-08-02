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
    
    let weeklyData: [WeeklyData] = [
        .init(day: "20", dayString: "Sun"),
        .init(day: "19", dayString: "Sat"),
        .init(day: "18", dayString: "Fri"),
        .init(day: "17", dayString: "Thu"),
        .init(day: "16", dayString: "Wed"),
        .init(day: "15", dayString: "Tue"),
        .init(day: "14", dayString: "Mon"),
    ]
    
    let tabSelections: [TabSelection] = [.mood, .sub, .settings]
    private let moodViewTypeRelay = BehaviorRelay<MoodViewType>(value: .weekly)
    var moodViewTypeObservable: Observable<MoodViewType> { moodViewTypeRelay.asObservable() }
    
    func selectMood(_ type: MoodViewType) {
        moodViewTypeRelay.accept(type)
    }
    
}

extension ProfileViewModel {
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
    
    var id: String {
        return day
    }
}
