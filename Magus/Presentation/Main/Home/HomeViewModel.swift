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
        SectionViewModel(header: LocalizedStrings.HomeHeaderTitle.category, items: []),
        SectionViewModel(header: LocalizedStrings.HomeHeaderTitle.recommendations, items: []),
        SectionViewModel(header: LocalizedStrings.HomeHeaderTitle.featuredPlayList, items: [])
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
                    var newSection = sections.value
                    newSection[0].items = array.map { CategoryCell.Model(id: $0.id, title: $0.name, imageUrl: .init(string: $0.image ?? "")) }
                    sections.accept(newSection)
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
    var items: [ItemModel]
}

protocol ItemModel {
    var id: Int { get set }
    var title: String { get set }
    var imageUrl: URL? { get set }
}

extension SectionViewModel: SectionModelType {
    typealias Item = ItemModel
    init(original: SectionViewModel, items: [ItemModel]) {
        self = original
        self.items = items
    }
}
