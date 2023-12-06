//
//  GuideResponse.swift
//  Magus
//
//  Created by Jomz on 12/3/23.
//

import Foundation

struct GuideResponse: EndpointResponse, Equatable, Encodable {
    typealias ErrorResponse = FAQsResponseErrorResponse
    
    let image: String
    let description: String
    
}
                        
struct GuideResponseErrorResponse: Decodable {
    let message: String
}


