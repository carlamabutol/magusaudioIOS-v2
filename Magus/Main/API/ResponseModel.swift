//
//  ResponseModel.swift
//  Magus
//
//  Created by Jose Mari Pascual on 12/15/23.
//

import Foundation

struct ResponseModel: Decodable {
    let success: Bool
    let message: String
    let data: ForgotPasswordResponse
}

struct ForgotPasswordResponse: Decodable {
    let valid: Bool
}
