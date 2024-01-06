//
//  ProfileUseCase.swift
//  Magus
//
//  Created by Jomz on 8/11/23.
//

import Foundation

class ProfileUseCase {
    
    private var store: Store
    private let networkService: NetworkService
    private let credentialsService: AuthenticationService
    
    init(store: Store, networkService: NetworkService, credentialsService: AuthenticationService) {
        self.store = store
        self.networkService = networkService
        self.credentialsService = credentialsService
    }
    
    func updateProfileDetails(firstName: String, lastName: String) async -> Result<User, NetworkServiceError> {
        do {
            let response = try await networkService.updateUserSettings(firstName: firstName, lastName: lastName)
            
            switch response {
            case let .success(response):
                let user = User(response: response.first!)
                store.appState.user = user
                store.saveAppState()
                return .success(user)
            case .error(let errorResponse):
                Logger.error(errorResponse.message, topic: .domain)
                return .failure(.jsonDecodingError)
            }
        } catch {
            Logger.error("updateProfileDetails Error: Unable to complete network request - \(error.localizedDescription)", topic: .network)
            return .failure(.jsonDecodingError)
        }
    }
    
    func updateProfilePhoto(photo: Data) async -> EmptyResponse {
        do {
            let response = try await networkService.updateProfilePhoto(photo: photo)
            
            switch response {
            case let .success(response):
                store.appState.user =  User(response: response)
                store.saveAppState()
                return .init(success: true, message: "")
            case .error(let errorResponse):
                Logger.error(errorResponse.message, topic: .domain)
                return .init(success: false, message: errorResponse.message)
            }
        } catch {
            Logger.error("updateProfileDetails Error: Unable to complete network request - \(error.localizedDescription)", topic: .network)
            return .init(success: false, message: "Failed")
        }
    }
    
}
