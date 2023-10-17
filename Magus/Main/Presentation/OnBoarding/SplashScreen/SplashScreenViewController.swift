//
//  SplashScreenViewController.swift
//  Magus
//
//  Created by Jose Mari Pascual on 5/18/23.
//

import UIKit

class SplashScreenViewController: CommonViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            SharedDependencies.sharedDependencies.router.selectedRoute = .welcomeOnBoard
        }
    }
    
}
