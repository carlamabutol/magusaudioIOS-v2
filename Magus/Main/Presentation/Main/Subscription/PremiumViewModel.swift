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
    
    private static let partialHeight: CGFloat = 105
    
    let premiumFeatures = BehaviorRelay<[PremiumFeatures]>(value: [])
    let planRelay = BehaviorRelay<[PremiumPlan]>(value: [])
    let finalHeightRelay = BehaviorRelay<CGFloat>(value: PremiumViewModel.partialHeight)
    
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
                        .init(premiumId: UUID().uuidString, premiumType: .monthly, amount: Float(premium.amountMonthly), isSelected: false, tapHandler: { [weak self] in
                            self?.didSelectPlan(type: .monthly)
                        }),
                        .init(premiumId: UUID().uuidString, premiumType: .yearly, amount: Float(premium.amountYearly), isSelected: false, tapHandler: { [weak self] in
                            self?.didSelectPlan(type: .yearly)
                        })
                    ]
                    planRelay.accept(subscriptions)
                    premiumFeatures.accept(premium.description.map { PremiumFeatures(title: $0.description, image: $0.image) { [weak self] height in
                        self?.updateHeight(height: height)
                    }})
                case .error(let errorResponse):
                    Logger.warning(errorResponse.message, topic: .presentation)
                }
            } catch {
                Logger.warning(error.localizedDescription, topic: .presentation)
            }
            
        }
    }
    
    private func didSelectPlan(type: PremiumType) {
        guard let planIndex = planRelay.value.lastIndex(where: { $0.premiumType == type }) else { return }
        var subscriptions = planRelay.value
        subscriptions = subscriptions.map({ plan in
            var plan = plan
            plan.isSelected = false
            return plan
        })
        subscriptions[planIndex].isSelected = true
        planRelay.accept(subscriptions)
    }
    
    private func updateHeight(height: CGFloat) {
        let possibleHeight = height + Self.partialHeight
        let existingHeight = finalHeightRelay.value
        if possibleHeight > existingHeight {
            finalHeightRelay.accept(possibleHeight)
        }
    }
    
}

extension PremiumViewModel {
    
    enum PremiumType: String {
        case monthly = "Monthly"
        case yearly = "Yearly"
        
        var coverImage: ImageAsset {
            switch self {
            case .monthly:
                return .premiumMonthlyBG
            case .yearly:
                return .premiumAnnuallyBG
            }
        }
    }
    
    struct PremiumFeatures {
        let title: String
        let image: String
        let webViewHeight: (_ height: CGFloat) -> Void
    }
    
    struct PremiumPlan {
        let premiumId: String
        let premiumType: PremiumType
        let amount: Float
        var isSelected: Bool
        var tapHandler: () -> Void
    }
    
}
