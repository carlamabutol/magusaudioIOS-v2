//
//  NetworkServiceError.swift
//  Magus
//
//  Created by Jomz on 5/30/23.
//

import Foundation

enum NetworkServiceError: Error {
    case notAuthenticated
    case jsonDecodingError
    case unknown
}
