//
//  Store.swift
//  Magus
//
//  Created by Jomz on 6/19/23.
//

import Foundation
import RxCocoa
import RxSwift

class Store {
    
    private let appStateObject: BehaviorRelay<AppState>
    private static let appStateStorageKey = "appStateStorageKey"
    
    private let queue = DispatchQueue(label: "com.magus.subliminal.audio.store")
    
    var appState: AppState {
        didSet {
            queue.sync {
                appStateObject.accept(appState)
            }
        }
    }
    
    init(appState: AppState) {
        self.appState = appState
        appStateObject = BehaviorRelay<AppState>(value: appState)
    }
    
    func saveAppState() {
        let encoder = JSONEncoder()
        do {
            let appStateData = try encoder.encode(appState)
            UserDefaults.standard.set(appStateData, forKey: Self.appStateStorageKey)
        } catch {
            Logger.error("Could not save app state. Got error \(error)", topic: .appState)
        }
    }
    
    static func getSavedAppState() throws -> AppState? {
        guard let savedAppStateData = UserDefaults.standard.data(forKey: Self.appStateStorageKey) else {
            Logger.info("No savedAppStateData in UserDefaults", topic: .appState)
            return nil
        }
        return try JSONDecoder().decode(AppState.self, from: savedAppStateData)
    }
    
    func removeAppState() {
        AudioPlayerManager.shared.removePlayers()
        UserDefaults.standard.removeObject(forKey: Self.appStateStorageKey)
    }
    
    func observable<T: Equatable>(of path: KeyPath<AppState, T>) -> Observable<T> {
        return appStateObject
            .map { $0[keyPath: path]}
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
    }
    
    var subliminalsObservable: Observable<[Subliminal]> {
        return observable(of: \.subliminals)
    }
    
    var isLikedObservable: Observable<Bool> {
        return observable(of: \.selectedSubliminal?.isLiked).map { $0 == 1 }
    }
    
}
