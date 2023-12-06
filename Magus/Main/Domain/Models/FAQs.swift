//
//  FAQs.swift
//  Magus
//
//  Created by Jomz on 12/3/23.
//

import Foundation

struct FAQs {
    
    let answer: String
    let question: String
    
}

extension FAQs {
    
    init(faqsResponse: FAQsResponse) {
        answer = faqsResponse.answer
        question = faqsResponse.question
    }
    
}
