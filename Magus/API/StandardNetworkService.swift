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
    private let requestManager: Session
    private static let validStatusCodes = [Int](200 ..< 300) + [422]
    
    init(baseURL: URL) {
        self.baseURL = baseURL
        self.requestManager = Alamofire.Session(configuration: .default)
    }
    
    private func getUnauthenticatedHeaders() -> HTTPHeaders {
        return HTTPHeaders(["Accept": "application/json"])
    }
    
}

extension StandardNetworkService: NetworkService {
    
    func signIn(email: String, password: String) async throws -> SignInResponse {
        let url = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("v1")
            .appendingPathComponent("user")
            .appendingPathComponent("login")
        
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        
        let task = requestManager.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: getUnauthenticatedHeaders())
            .validate(statusCode: Self.validStatusCodes)
            .serializingDecodable(SignInResponse.self)
        
        return try await task.value
    }
    
    func getAllMoods() async throws -> MoodResponse {
        let url = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("v1")
            .appendingPathComponent("moods")
        
        let task = requestManager.request(url, method: .get, headers: getUnauthenticatedHeaders())
            .validate(statusCode: Self.validStatusCodes)
            .serializingDecodable(MoodResponse.self)
        
        return try await task.value
    }
    
    func updateSelectedMoods(userId: String, moodId: Int) async throws -> DefaultResponse {
        let url = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("v1")
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
            .appendingPathComponent("v1")
            .appendingPathComponent("category")
        
        let task = requestManager.request(url, method: .get, headers: getUnauthenticatedHeaders())
            .validate(statusCode: Self.validStatusCodes)
            .serializingDecodable(JSONAPIArrayResponse<CategorySubliminalElement>.self)
        
        return try await task.value
    }
    
}
