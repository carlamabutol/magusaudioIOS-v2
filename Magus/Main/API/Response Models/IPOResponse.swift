//
//  IPOResponse.swift
//  Magus
//
//  Created by Jomz on 12/5/23.
//

import Foundation

struct IPOResponse: EndpointResponse, Equatable, Encodable {
    typealias ErrorResponse = FAQsResponseErrorResponse
    
    let title: String
    let image: String
    let description: String
    
}
                        
struct IPOResponseErrorResponse: Decodable {
    let message: String
}


