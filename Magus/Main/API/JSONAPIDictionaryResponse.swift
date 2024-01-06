//
//  JSONAPIDictionaryResponse.swift
//  Magus
//
//  Created by Jomz on 5/30/23.
//

import Foundation

enum JSONAPIDictionaryResponse<Response: EndpointResponse>: Decodable {
    
    case success(Response)
    case error(Response.ErrorResponse)
    
    private enum CodingKeys: String, CodingKey {
        case success
        case data
        case message
        case errors
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if values.contains(.data) {
            do {
                let data = try values.decode(Response.self, forKey: .data)
                self = .success(data)
            } catch {
                Logger.error("Failed to decode response: \(String(describing: Response.self)), Error: \(error)", topic: .network)
                throw NetworkServiceError.jsonDecodingError
            }
        } else if values.contains(.message) {
            let error = try Response.ErrorResponse(from: decoder)
            Logger.error("Failed to decode response: \(String(describing: Response.self)), Error: \(error)", topic: .network)
            self = .error(error)
        } else {
            throw NetworkServiceError.jsonDecodingError
        }
    }
    
}
