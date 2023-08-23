//
//  EndpointResponse.swift
//  Magus
//
//  Created by Jomz on 5/30/23.
//

import Foundation

protocol EndpointResponse: Decodable {
    associatedtype ErrorResponse: Decodable
}
