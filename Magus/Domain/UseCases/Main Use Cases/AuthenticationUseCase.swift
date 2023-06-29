//
//  AuthenticationUseCase.swift
//  Magus
//
//  Created by Jomz on 6/22/23.
//

import Foundation

final class AuthenticationUseCase {
    
    private var store: Store
    private let networkService: NetworkService
    private let credentialsService: AuthenticationService
    
    init(store: Store, networkService: NetworkService, credentialsService: AuthenticationService) {
        self.store = store
        self.networkService = networkService
        self.credentialsService = credentialsService
    }
    
    func signIn(email: String, password: String) async -> Result<User, SignInError> {
        do {
            let response = try await networkService.signIn(email: email, password: password)
            
            switch response {
            case let .success(response):
                let user = User(response: response.user)
                credentialsService.setToken(response.token, forID: user.userID)
                store.appState.user = user
                store.saveAppState()
                return .success(user)
            case .error(let errorResponse):
                Logger.error(errorResponse.message, topic: .domain)
                return .failure(SignInError.apiError(errorResponse))
            }
        } catch {
            Logger.error("Signin Error: Unable to complete network request - \(error.localizedDescription)", topic: .network)
            return .failure(SignInError.networkError)
        }
    }
    
}

extension AuthenticationUseCase {
    
    enum SignInError: Error {
        case apiError(SignInErrorResponse)
        case networkError
        
        var errorMesasge: String {
            switch self {
            case let.apiError(response): return response.message
            case .networkError: return "Network Error"
            }
        }
    }
    
}
