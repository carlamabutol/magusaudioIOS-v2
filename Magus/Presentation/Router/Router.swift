//
//  Router.swift
//  Magus
//
//  Created by Jose Mari Pascual on 5/14/23.
//

import Foundation
import RxSwift
import RxCocoa

class Router {
    private let credentialsService: AuthenticationService
    private let disposeBag = DisposeBag()
    private let selectedRouteRelay: BehaviorRelay<Route>
    let selectedRouterObservable: Observable<Route>
    
    var selectedRoute: Route {
        get {
            selectedRouteRelay.value
        }
        
        set {
            selectedRouteRelay.accept(newValue)
        }
    }
    
    init(credentialsService: AuthenticationService) {
        self.credentialsService = credentialsService
        let initialRoute: Route = credentialsService.isLoggedIn ? .home : .welcomeOnBoard
        selectedRouteRelay = BehaviorRelay(value: initialRoute)
        selectedRouterObservable = selectedRouteRelay.asObservable().observe(on: MainScheduler.asyncInstance)
    }
    
}
