//
//  RootViewModel.swift
//  Magus
//
//  Created by Jose Mari Pascual on 5/10/23.
//

import Foundation
import RxSwift

class ViewModel {
    let disposeBag = DisposeBag()
}

class RootViewModel: ViewModel {
    
    let selectedRoute: Observable<Route>
    
    init(dependencies: SharedDependencies) {
        selectedRoute = dependencies.router.selectedRouterObservable
        super.init()
    }
    
}
