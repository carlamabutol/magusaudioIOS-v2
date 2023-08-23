//
//  SubliminalUseCase.swift
//  Magus
//
//  Created by Jomz on 8/14/23.
//

import Foundation

final class SubliminalUseCase {
    
    private var store: Store
    private let networkService: NetworkService
    private let credentialsService: AuthenticationService
    
    init(store: Store, networkService: NetworkService, credentialsService: AuthenticationService) {
        self.store = store
        self.networkService = networkService
        self.credentialsService = credentialsService
    }
    
    func getSubliminalAudios(_ subliminalId: String) async -> Result<[String], Error> {
        do {
            let response = try await networkService.getSubliminalAudio(subliminalId: subliminalId)
            return .success(response.data ?? [])
        } catch {
            return .failure(error)
        }
    }
    
    func getSubliminals() async throws -> [Subliminal] {
        do {
            let response = try await networkService.getSubliminals()
            switch response {
            case .success(let response):
                return response.data.map{ Subliminal(subliminalReponse: $0) }
            case .error(_):
                throw NetworkServiceError.jsonDecodingError
            }
        } catch {
            throw error
        }
    }
    
}
