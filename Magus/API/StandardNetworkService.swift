//
//  StandardNetworkService.swift
//  Magus
//
//  Created by Jomz on 5/29/23.
//

import Foundation
import Alamofire

class StandardNetworkService {
    
    private let baseURL: URL
    private let credentialsService: AuthenticationService
    private let requestManager: Session
    private let getUserID: () -> String?
    private static let validStatusCodes: [Int] = (200 ..< 300) + [422]
    
    init(baseURL: URL,
         credentialsService: AuthenticationService,
         getUserID: @escaping () -> String?) {
        self.baseURL = baseURL
        self.credentialsService = credentialsService
        self.getUserID = getUserID
        self.requestManager = Alamofire.Session(configuration: .default)
    }
    
    private func getUnauthenticatedHeaders() -> HTTPHeaders {
        return HTTPHeaders(["Accept": "application/json"])
    }
    
    private func getAuthenticatedHeaders() throws -> HTTPHeaders {
        guard let userID = getUserID(), let token = credentialsService.tokenForID(userID) else {
            throw NetworkServiceError.notAuthenticated
        }
        
        var headers = getUnauthenticatedHeaders()
        headers.add(HTTPHeader(name: "Authorization", value: "Bearer \(token)"))
        return headers
    }
    
}

extension StandardNetworkService: NetworkService {
    
    func signIn(email: String, password: String) async throws -> JSONAPIDictionaryResponse<SignInResponse> {
        let url = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("login")
        
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        
        let task = requestManager.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: getUnauthenticatedHeaders())
            .validate(statusCode: Self.validStatusCodes)
            .serializingDecodable(JSONAPIDictionaryResponse<SignInResponse>.self)
        
        return try await task.value
    }
    
    func getAllMoods() async throws -> JSONAPIArrayResponse<Mood> {
        let url = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("mood")
        
        let task = requestManager.request(url, method: .get, headers: try getAuthenticatedHeaders())
            .validate(statusCode: Self.validStatusCodes)
            .serializingDecodable(JSONAPIArrayResponse<Mood>.self)
        
        return try await task.value
    }
    
    func updateSelectedMoods(userId: String, moodId: Int) async throws -> DefaultResponse {
        let url = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("user")
            .appendingPathComponent("update")
            .appendingPathComponent("moods")
        
        let parameters: [String: Any] = [
            "user_id": userId,
            "moods": moodId
        ]
        
        let task = requestManager.request(url, method: .post, parameters: parameters, headers: getUnauthenticatedHeaders())
            .validate(statusCode: Self.validStatusCodes)
            .serializingDecodable(DefaultResponse.self)
        
        return try await task.value
    }
    
    func getCategorySubliminal() async throws -> JSONAPIArrayResponse<CategorySubliminalElement> {
        let url = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("category")
        
        let task = requestManager.request(url, method: .get, headers: try getAuthenticatedHeaders())
            .validate(statusCode: Self.validStatusCodes)
            .serializingDecodable(JSONAPIArrayResponse<CategorySubliminalElement>.self)
        
        return try await task.value
    }
    
    func getFeaturedPlaylists() async throws -> JSONAPIArrayResponse<FeaturedPlaylistResponse> {
        let url = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("playlist")
        
        let task = requestManager.request(url, method: .get, headers: try getAuthenticatedHeaders())
            .validate(statusCode: Self.validStatusCodes)
            .serializingDecodable(JSONAPIArrayResponse<FeaturedPlaylistResponse>.self)
        
        return try await task.value
    }
    
    func getSubliminals() async throws -> JSONAPIDictionaryResponse<SubliminalResponse> {
        let url = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("subliminal")
        
        let task = requestManager.request(url, method: .get, headers: try getAuthenticatedHeaders())
            .validate(statusCode: Self.validStatusCodes)
            .serializingDecodable(JSONAPIDictionaryResponse<SubliminalResponse>.self)
        
        return try await task.value
    }
    
    func getSubscriptions() async throws -> JSONAPIArrayResponse<SubscriptionResponse> {
        let url = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("subscription")
        
        let task = requestManager.request(url, method: .get, headers: try getAuthenticatedHeaders())
            .validate(statusCode: Self.validStatusCodes)
            .serializingDecodable(JSONAPIArrayResponse<SubscriptionResponse>.self)
        
        return try await task.value
    }
    
}
