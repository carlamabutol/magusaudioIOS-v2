//
//  PlayerViewModel.swift
//  Magus
//
//  Created by Jomz on 9/2/23.
//

import UIKit

class PlayerViewModel: ViewModel {
    
    var subliminals: [Subliminal] = []
    
    func updateSubliminals(subliminals: [Subliminal]) {
        self.subliminals = subliminals
    }
    
}
