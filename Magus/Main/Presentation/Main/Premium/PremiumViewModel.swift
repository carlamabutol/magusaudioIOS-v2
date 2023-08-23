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
    let premiumFeature = BehaviorRelay<[PremiumPlan]>(value: [])
    
    private let networkService: NetworkService
    
    init(sharedDependencies: SearchViewModel.Dependencies = .standard) {
        networkService = sharedDependencies.networkService
        getSubscriptions()
    }
    
    private func getSubscriptions() {
        Task {
            do {
                let response = try await networkService.getSubscriptions()
                switch response {
                case .success(let array):
                    guard let premium = array.first(where: { $0.name == "Premium" }) else { return}
                    
                    premiumFeature.accept([.init(premiumId: premium.id, premiumType: .monthly, amount: Float(premium.amount), isSelected: false),
                                           .init(premiumId: premium.id, premiumType: .yearly, amount: Float(premium.amount), isSelected: false)])
                    debugPrint("getSubscriptions - \(premiumFeature.value)")
                case .error(let errorResponse):
                    debugPrint("RESPONSE ERROR - \(errorResponse.message)")
                }
            } catch {
                debugPrint("Network Error Response - \(error.localizedDescription)")
            }
            
        }
    }
    
}

extension PremiumViewModel {
    
    enum PremiumType {
        case monthly
        case yearly
    }
    
    struct PremiumFeatures {
        let title: String
        let image: String
    }
    
    struct PremiumPlan {
        let premiumId: Int
        let premiumType: PremiumType
        let amount: Float
        var isSelected: Bool
    }
    
}

extension PremiumViewModel.PremiumFeatures {
    static let sample: [PremiumViewModel.PremiumFeatures] = [
        .init(title: "Exclusive Playlist\njust for you", image: "premiumFeature1"),
        .init(title: "More Advance\nVolume Controls", image: "premiumFeature2"),
        .init(title: "Exclusive Playlist\njust for you", image: "premiumFeature1"),
        .init(title: "More Advance\nVolume Controls", image: "premiumFeature2"),
    ]
}
