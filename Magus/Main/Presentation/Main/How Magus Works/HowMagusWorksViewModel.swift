//
//  HowMagusWorksViewModel.swift
//  Magus
//
//  Created by Jose Mari Pascual on 10/11/23.
//

import Foundation

class HowMagusWorksViewModel: ViewModel {
    
    
    
}

extension HowMagusWorksViewModel {
    
    struct Model {
        let image: ImageAsset
        let title: String
        let description: String
    }
    
    static let first: Model = .init(
        image: .howMagusWorks1,
        title: "Lorem Ipsum",
        description: " In some musical compositions, the term \"Magus\" might be used to evoke a sense of magic or mysticism. Composers or musicians could use this term to suggest that the music is otherworldly, enchanting, or has a mystical quality.")
    
    static let second: Model = .init(
        image: .howMagusWorks2,
        title: "Lorem Ipsum",
        description: " In some musical compositions, the term \"Magus\" might be used to evoke a sense of magic or mysticism. Composers or musicians could use this term to suggest that the music is otherworldly, enchanting, or has a mystical quality.")
    
}
