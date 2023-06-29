//
//  PremiumViewModel.swift
//  Magus
//
//  Created by Jomz on 6/29/23.
//

import Foundation
import RxSwift
import RxCocoa

class PremiumViewModel {
    
    let premiumFeatures = BehaviorRelay(value: PremiumViewModel.PremiumFeatures.sample)
    
}

extension PremiumViewModel {
    
    struct PremiumFeatures {
        let title: String
        let image: String
    }
    
}

extension PremiumViewModel.PremiumFeatures {
    static let sample: [PremiumViewModel.PremiumFeatures] = [
        .init(title: "Exclusive Playlist\njust for you", image: "premium_features_playlist"),
        .init(title: "More Advance\nVolume Controls", image: "premium_features_volume"),
    ]
}
