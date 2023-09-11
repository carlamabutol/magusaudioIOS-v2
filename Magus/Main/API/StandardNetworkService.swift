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
    private let getSubscriptionID: () -> Int
    private static let validStatusCodes: [Int] = (200 ..< 300) + [422]
    
    init(baseURL: URL,
         credentialsService: AuthenticationService,
         getUserID: @escaping () -> String?,
         getSubscriptionID: @escaping () -> Int) {
        self.baseURL = baseURL
        self.credentialsService = credentialsService
        self.getUserID = getUserID
        self.getSubscriptionID = getSubscriptionID
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
        Logger.info("Authorization - \(token) -- \(userID)", topic: .domain)
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
    
    func signUp(name: String, email: String, password: String) async throws -> JSONAPIDictionaryResponse<SignUpResponse> {
        let url = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("register")
        
        let parameters: [String: String] = [
            "name": name,
            "email": email,
            "password": password,
            "password_confirmation": password
        ]
        
        let task = requestManager.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: getUnauthenticatedHeaders())
            .validate(statusCode: Self.validStatusCodes)
            .serializingDecodable(JSONAPIDictionaryResponse<SignUpResponse>.self)
        
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
            .appendingPathComponent("mood")
            .appendingPathComponent("update")
        
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
    
    func getFeaturedPlaylists() async throws -> JSONAPIDictionaryResponse<FeaturedPlaylistResponse> {
        let url = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("featured")
        
        var parameters: [String: String] = [
            "subscription_id": String(describing: getSubscriptionID())
        ]
        
        if let userID = getUserID() {
            parameters["user_id"] = userID
        }
        
        let task = requestManager.request(url, method: .post, parameters: parameters, headers: try getAuthenticatedHeaders())
            .validate(statusCode: Self.validStatusCodes)
            .serializingDecodable(JSONAPIDictionaryResponse<FeaturedPlaylistResponse>.self)
        
        return try await task.value
    }
    
    func getRecommendations() async throws -> JSONAPIDictionaryResponse<RecommendationResponse> {
        let url = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("recommendations")
        
        var parameters: [String: String] = [
            "subscription_id": String(describing: getSubscriptionID())
        ]
        
        if let userID = getUserID() {
            parameters["user_id"] = userID
        }
        
        let task = requestManager.request(url, method: .post, parameters: parameters, headers: try getAuthenticatedHeaders())
            .validate(statusCode: Self.validStatusCodes)
            .serializingDecodable(JSONAPIDictionaryResponse<RecommendationResponse>.self)
        
        return try await task.value
    }
    
    func getSubliminals() async throws -> JSONAPIDictionaryResponse<SubliminalArrayResponse> {
        let url = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("subliminal")
        
        let task = requestManager.request(url, method: .get, headers: try getAuthenticatedHeaders())
            .validate(statusCode: Self.validStatusCodes)
            .serializingDecodable(JSONAPIDictionaryResponse<SubliminalArrayResponse>.self)
        
        return try await task.value
    }
    
    func getSubscriptions() async throws -> JSONAPIArrayResponse<SubscriptionResponse> {
        let url = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("subscription")
        
        var parameters: [String: String] = [:]
        
        if let userID = getUserID() {
            parameters["user_id"] = userID
        }
        
        let task = requestManager.request(url, method: .get, headers: try getAuthenticatedHeaders())
            .validate(statusCode: Self.validStatusCodes)
            .serializingDecodable(JSONAPIArrayResponse<SubscriptionResponse>.self)
        
        return try await task.value
    }
    
    func searchSubliminalAndPlaylist(search: String) async throws -> JSONAPIDictionaryResponse<SearchPlaylistAndSubliminalResponse> {
        let url = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("search")
            .appendingPathComponent("filter")
        
        var parameters: [String: String] = [
            "subscription_id": "1",
            "search": search
        ]
        
        if let userID = getUserID() {
            parameters["user_id"] = userID
        }
        
        let task = requestManager.request(url, method: .post, parameters: parameters, headers: try getAuthenticatedHeaders())
            .validate(statusCode: Self.validStatusCodes)
            .serializingDecodable(JSONAPIDictionaryResponse<SearchPlaylistAndSubliminalResponse>.self)
        
        return try await task.value
    }
    
    func updateUserSettings(firstName: String, lastName: String) async throws -> JSONAPIArrayResponse<UserResponse> {
        var url = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("user")
            .appendingPathComponent("info")
            .appendingPathComponent("update")
        if let userID = getUserID() {
            url = url.appendingPathComponent(userID)
        }
        let parameters: [String: String] = [
            "name": firstName + " " + lastName,
            "first_name": firstName,
            "last_name": lastName
        ]
        
        let task = requestManager.request(url, method: .post, parameters: parameters, headers: try getAuthenticatedHeaders())
            .validate(statusCode: Self.validStatusCodes)
            .serializingDecodable(JSONAPIArrayResponse<UserResponse>.self)
        
        return try await task.value
    }
    
    func getSubliminalAudio(subliminalId: String) async throws -> ResponseArrayModel<String> {
        var url = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("audio")
            .appendingPathComponent("subliminal")
            .appendingPathComponent(subliminalId)
        
        let task = requestManager.request(url, method: .get, headers: try getAuthenticatedHeaders())
            .validate(statusCode: Self.validStatusCodes)
            .serializingDecodable(ResponseArrayModel<String>.self)
        
        return try await task.value
    }
    
    func updateFavorite(id: String, api: FavoriteAPI, isLiked: Bool) async throws -> EmptyResponse {
        guard let userID = getUserID() else {
            throw NetworkServiceError.notAuthenticated
        }
        let parameters: [String: String] = [
            "user_id": userID,
            "\(api.rawValue)_id": id
        ]
        
        let url = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("like")
            .appendingPathComponent(api.rawValue)
            .appendingPathComponent(isLiked ? "add" : "delete")
        
        let task = requestManager.request(url, method: .post, parameters: parameters, headers: try getAuthenticatedHeaders())
            .validate(statusCode: Self.validStatusCodes)
            .serializingDecodable(EmptyResponse.self)
        
        return try await task.value
    }
    
}
