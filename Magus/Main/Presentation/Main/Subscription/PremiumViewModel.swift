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
    let planRelay = BehaviorRelay<[PremiumPlan]>(value: [])
    
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
                    let subscriptions: [PremiumPlan] = [
                        .init(premiumId: premium.id, premiumType: .monthly, amount: Float(premium.amount), isSelected: false, tapHandler: {
                            
                        }),
                        .init(premiumId: premium.id, premiumType: .yearly, amount: Float(premium.amountYear), isSelected: false, tapHandler: {
                            
                        })
                    ]
                    planRelay.accept(subscriptions)
                case .error(let errorResponse):
                    Logger.warning(errorResponse.message, topic: .presentation)
                }
            } catch {
                Logger.warning(error.localizedDescription, topic: .presentation)
            }
            
        }
    }
    
}

extension PremiumViewModel {
    
    enum PremiumType: String {
        case monthly = "Monthly"
        case yearly = "Yearly"
        
        var coverImage: String {
            switch self {
            case .monthly:
                return "premiumFeature1"
            case .yearly:
                return "premiumFeature2"
            }
        }
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
        var tapHandler: () -> Void
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
