//
//  SharedDependencies.swift
//  Magus
//
//  Created by Jose Mari Pascual on 5/14/23.
//

import Foundation

class SharedDependencies {
    let router: Router
    
    private init(router: Router) {
        self.router = router
    }
}

extension SharedDependencies {
    
    static let sharedDependencies: SharedDependencies = {
        let router = Router()
        return .init(router: router)
    }()
}
