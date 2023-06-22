//
//  HomeViewModel.swift
//  Magus
//
//  Created by Jomz on 6/19/23.
//

import Foundation
import RxSwift
import RxRelay
import RxDataSources

class HomeViewModel: ViewModel {
    
    let sections = BehaviorRelay<[SectionViewModel]>(value: [
        SectionViewModel(header: "Category", items: ["Item 1", "Item 2", "Item 3"]),
        SectionViewModel(header: "Recommendations", items: ["Item 1", "Item 2", "Item 3"]),
        SectionViewModel(header: "Featured Playlists", items: ["Item 1", "Item 2", "Item 3"])
    ])
    
    private let networkService: NetworkService
    
    init(sharedDependencies: SharedDependencies = .sharedDependencies) {
        networkService = sharedDependencies.networkService
    }
    
    func getAllCategory() {
        
        Task {
            
            do {
                let response = try await networkService.getCategorySubliminal()
                switch response {
                case .success(let array):
                    print("RESPONSE - \(array)")
                case .error(let errorResponse):
                    debugPrint("RESPONSE ERROR - \(errorResponse.message)")
                }
            } catch {
                debugPrint("Network Error Response - \(error.localizedDescription)")
            }
            
        }
        
    }
    
}

struct SectionViewModel {
    var header: String!
    var items: [String]
}

extension SectionViewModel: SectionModelType {
    typealias Item = String
    init(original: SectionViewModel, items: [String]) {
        self = original
        self.items = items
    }
}
