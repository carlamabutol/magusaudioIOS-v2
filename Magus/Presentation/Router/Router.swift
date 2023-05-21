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
    
    init() {
        selectedRouteRelay = BehaviorRelay(value: .splashscreen)
        selectedRouterObservable = selectedRouteRelay.asObservable().observe(on: MainScheduler.asyncInstance)
    }
    
}
