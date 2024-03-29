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
    
    func signUp(name: String, email: String, password: String) async -> Result<[String], SignUpError> {
        do {
            let response = try await networkService.signUp(name: name, email: email, password: password)
            
            switch response {
            case let .success(response):
                if let user = response.user, let token = response.token {
                    let user = User(response: user)
                    credentialsService.setToken(token, forID: user.userID)
                    store.appState.user = user
                    store.saveAppState()
                    return .success([])
                } else {
                    return .success(response.password ?? [])
                }
            case .error(let errorResponse):
                Logger.error(errorResponse.message, topic: .domain)
                return .failure(SignUpError.apiError(errorResponse))
            }
        } catch {
            Logger.error("Signin Error: Unable to complete network request - \(error.localizedDescription)", topic: .network)
            return .failure(SignUpError.networkError)
        }
    }
    
    func forgotPassword(email: String) async throws -> ResponseModel {
        do {
            let response = try await networkService.forgotPassowrd(email: email)
            return response
        } catch {
            Logger.error("Signin Error: Unable to complete network request - \(error.localizedDescription)", topic: .network)
            throw error
        }
    }
    
    func changePassword(currentPassword: String, newPassword: String, confirmPassword: String) async throws -> EmptyResponse {
        do {
            let response = try await networkService.changePassword(currentPassword: currentPassword, newPassword: newPassword, newPasswordConf: confirmPassword)
            return response
        } catch {
            Logger.error("ChangePassword Error: Unable to complete network request - \(error.localizedDescription)", topic: .network)
            throw error
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
    
    enum SignUpError: Error {
        case apiError(SignUpErrorResponse)
        case networkError
        
        var errorMesasge: String {
            switch self {
            case let.apiError(response): return response.message
            case .networkError: return "Network Error"
            }
        }
    }
    
    
}
