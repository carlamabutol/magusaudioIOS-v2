//
//  JSONAPIArrayResponse.swift
//  Magus
//
//  Created by Jomz on 5/30/23.
//

import Foundation

enum JSONAPIArrayResponse<Response: EndpointResponse>: Decodable {
    
    case success([Response])
    case error(Response.ErrorResponse)
    
    private enum CodingKeys: String, CodingKey {
        case data
        case message
        case errors
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if values.contains(.data) {
            do {
                let data = try values.decode([Response].self, forKey: .data)
                self = .success(data)
            } catch {
                Logger.error("Failed to decode response: \(String(describing: Response.self)), Error: \(error)", topic: .network)
                throw NetworkServiceError.jsonDecodingError
            }
        } else if values.contains(.message) {
            let error = try Response.ErrorResponse(from: decoder)
            self = .error(error)
        } else {
            Logger.error("Failed to decode response: \(String(describing: Response.self))", topic: .network)
            throw NetworkServiceError.jsonDecodingError
        }
    }
    
}

struct ResponseArrayModel<T: Decodable>: Decodable {
    let message: String
    let data: [T]?
}

struct EmptyResponse: Decodable {
    let success: Bool
    let message: String
}
