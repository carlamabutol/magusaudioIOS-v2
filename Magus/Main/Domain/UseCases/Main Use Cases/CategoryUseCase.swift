//
//  CategoryUseCase.swift
//  Magus
//
//  Created by Jomz on 10/17/23.
//

import Foundation

final class CategoryUseCase {
    
    private var store: Store
    private let networkService: NetworkService
    private let credentialsService: AuthenticationService
    
    init(store: Store, networkService: NetworkService, credentialsService: AuthenticationService) {
        self.store = store
        self.networkService = networkService
        self.credentialsService = credentialsService
    }
    
    // TODO: TELL API TO ADD LIMIT
    func getCategorySubliminal() async throws -> [Category] {
        do {
            let response = try await networkService.getCategorySubliminal(search: "")
            switch response {
            case .success(let response):
                return response.map { Category(model: $0) }
            case .error(_):
                throw NetworkServiceError.jsonDecodingError
            }
        } catch {
            throw error
        }
    }
    
    func searchCategory(search: String)  async throws -> [Category] {
        do {
            let response = try await networkService.getCategorySubliminal(search: "")
            switch response {
            case .success(let response):
                return response.map { Category(model: $0) }
            case .error(_):
                throw NetworkServiceError.jsonDecodingError
            }
        } catch {
            throw error
        }
    }
    
}

