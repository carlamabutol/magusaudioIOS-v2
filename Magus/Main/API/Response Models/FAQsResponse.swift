//
//  FAQsResponse.swift
//  Magus
//
//  Created by Jomz on 12/3/23.
//

import Foundation

struct FAQsResponse: EndpointResponse, Equatable, Encodable {
    typealias ErrorResponse = FAQsResponseErrorResponse
    
    let answer: String
    let question: String
    
}
                        
struct FAQsResponseErrorResponse: Decodable {
    let message: String
}

