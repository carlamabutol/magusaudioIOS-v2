//
//  SettingsUseCase.swift
//  Magus
//
//  Created by Jomz on 12/3/23.
//

import Foundation

class SettingsUseCase {
    
    private var store: Store
    private let networkService: NetworkService
    private let credentialsService: AuthenticationService
    
    init(store: Store, networkService: NetworkService, credentialsService: AuthenticationService) {
        self.store = store
        self.networkService = networkService
        self.credentialsService = credentialsService
    }
    
    func getFAQs(search: String = "") async throws -> [FAQs] {
        do {
            let response = try await networkService.getFAQs(search: search)
            switch response {
            case .success(let response):
                return response.map { FAQs(faqsResponse: $0) }
            case .error(_):
                throw NetworkServiceError.jsonDecodingError
            }
        } catch {
            throw error
        }
    }
    
    func getGuide() async throws -> [Guide] {
        do {
            let response = try await networkService.getGuides()
            switch response {
            case .success(let response):
                return response.map { Guide(guideResponse: $0) }
            case .error(_):
                throw NetworkServiceError.jsonDecodingError
            }
        } catch {
            throw error
        }
    }
    
    func getIPO() async throws -> [IPO] {
        do {
            let response = try await networkService.getIPO()
            switch response {
            case .success(let response):
                return response.map { IPO(ipoResponse: $0) }
            case .error(_):
                throw NetworkServiceError.jsonDecodingError
            }
        } catch {
            throw error
        }
    }
    
}
