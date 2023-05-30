//
//  NetworkService.swift
//  Magus
//
//  Created by Jomz on 5/30/23.
//

import Foundation
import RxSwift

protocol AuthenticationService {
    func signIn(email: String, password: String) async throws -> SignInResponse
}
