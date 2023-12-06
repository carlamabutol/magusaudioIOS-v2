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
    private let getMoodId: () -> Int?
    private let getSubscriptionID: () -> Int
    private static let validStatusCodes: [Int] = (200 ..< 300) + [422]
    
    init(baseURL: URL,
         credentialsService: AuthenticationService,
         getUserID: @escaping () -> String?,
         getMoodId: @escaping () -> Int?,
         getSubscriptionID: @escaping () -> Int) {
        self.baseURL = baseURL
        self.credentialsService = credentialsService
        self.getMoodId = getMoodId
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
    
    // MARK: MOODS
    
    func getAllMoods() async throws -> JSONAPIArrayResponse<MoodResponse> {
        let url = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("mood")
        
        let task = requestManager.request(url, method: .get, headers: try getAuthenticatedHeaders())
            .validate(statusCode: Self.validStatusCodes)
            .serializingDecodable(JSONAPIArrayResponse<MoodResponse>.self)
        
        return try await task.value
    }
    
    func getCurrentMood() async throws -> JSONAPIArrayResponse<CurrentMoodResponse> {
        let url = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("user")
            .appendingPathComponent("mood")
        
        var parameters: [String: Any] = [:]
        
        if let userID = getUserID() {
            parameters["user_id"] = userID
        }
        
        let task = requestManager.request(url, method: .post, headers: try getAuthenticatedHeaders())
            .validate(statusCode: Self.validStatusCodes)
            .serializingDecodable(JSONAPIArrayResponse<CurrentMoodResponse>.self)
        
        return try await task.value
    }
    
    func updateSelectedMoods(moodId: Int) async throws -> EmptyResponse {
        let url = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("user")
            .appendingPathComponent("mood")
            .appendingPathComponent("update")
        
        var parameters: [String: Any] = [
            "mood_id": moodId
        ]
        
        if let userID = getUserID() {
            parameters["user_id"] = userID
        }
        
        let task = requestManager.request(url, method: .post, parameters: parameters, headers: try getAuthenticatedHeaders())
            .validate(statusCode: Self.validStatusCodes)
            .serializingDecodable(EmptyResponse.self)
        
        return try await task.value
    }
    
    func getMoodCalendar() async throws -> JSONAPIDictionaryResponse<MoodCalendarResponse> {
        let url = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("user")
            .appendingPathComponent("mood")
            .appendingPathComponent("calendar")
        
        var parameters: [String: Any] = [:]
        
        if let userID = getUserID() {
            parameters["user_id"] = userID
        }
        
        let task = requestManager.request(url, method: .post, parameters: parameters, headers: try getAuthenticatedHeaders())
            .validate(statusCode: Self.validStatusCodes)
            .serializingDecodable(JSONAPIDictionaryResponse<MoodCalendarResponse>.self)
        
        return try await task.value
    }
    
    // MARK: HOME
    
    func getCategorySubliminal(search: String) async throws -> JSONAPIArrayResponse<CategorySubliminalElement> {
        let url = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("home")
            .appendingPathComponent("category")
            .appendingPathComponent("search")
        
        var parameters: [String: String] = [
            "subscription_id": String(describing: getSubscriptionID()),
            "search": search
        ]
        
        if let moodId = getMoodId() {
            parameters["mood_id"] = String(describing: moodId)
        }
        
        if let userID = getUserID() {
            parameters["user_id"] = userID
        }
        
        let task = requestManager.request(url, method: .post, parameters: parameters, headers: try getAuthenticatedHeaders())
            .validate(statusCode: Self.validStatusCodes)
            .serializingDecodable(JSONAPIArrayResponse<CategorySubliminalElement>.self)
        
        return try await task.value
    }
    
    func getRecommendations(search: String, categoryId: Int?, moodId: Int?) async throws -> JSONAPIDictionaryResponse<RecommendationResponse> {
        let url = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("recommendation")
        
        var parameters: [String: String] = [
            "subscription_id": String(describing: getSubscriptionID()),
            "search": search
        ]
        
        if let userID = getUserID() {
            parameters["user_id"] = userID
        }
        
        if let categoryId = categoryId {
            parameters["category_id"] = String(describing: categoryId)
        }
        
        if let moodId = moodId {
            parameters["mood_id"] = String(describing: moodId)
        }
        
        let task = requestManager.request(url, method: .post, parameters: parameters, headers: try getAuthenticatedHeaders())
            .validate(statusCode: Self.validStatusCodes)
            .serializingDecodable(JSONAPIDictionaryResponse<RecommendationResponse>.self)
        
        return try await task.value
    }
    
    func getFeatured(search: String) async throws -> JSONAPIDictionaryResponse<FeaturedResponse> {
        let url = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("featured")
        
        var parameters: [String: String] = [
            "subscription_id": String(describing: getSubscriptionID()),
            "search": search
        ]
        
        if let userID = getUserID() {
            parameters["user_id"] = userID
        }
        
        let task = requestManager.request(url, method: .post, parameters: parameters, headers: try getAuthenticatedHeaders())
            .validate(statusCode: Self.validStatusCodes)
            .serializingDecodable(JSONAPIDictionaryResponse<FeaturedResponse>.self)
        
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
    
    func getAllFavoriteSubliminals() async throws -> JSONAPIArrayResponse<SubliminalResponse> {
        let url = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("like")
            .appendingPathComponent("subliminal")
        
        var parameters: [String: String] = [
            "subscription_id": String(describing: getSubscriptionID())
        ]
        
        if let userID = getUserID() {
            parameters["user_id"] = userID
        }
        
        let task = requestManager.request(url, method: .post, parameters: parameters, headers: try getAuthenticatedHeaders())
            .validate(statusCode: Self.validStatusCodes)
            .serializingDecodable(JSONAPIArrayResponse<SubliminalResponse>.self)
        
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
        let url = baseURL
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
            "\(api.rawValue)_id": id,
            "subscription_id": getSubscriptionID().toString()
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
    
    func getAllFavoritePlaylist() async throws -> JSONAPIArrayResponse<SearchPlaylistResponse> {
        let url = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("like")
            .appendingPathComponent("playlist")
        
        var parameters: [String: String] = [
            "subscription_id": String(describing: getSubscriptionID())
        ]
        
        if let userID = getUserID() {
            parameters["user_id"] = userID
        }
        
        let task = requestManager.request(url, method: .post, parameters: parameters, headers: try getAuthenticatedHeaders())
            .validate(statusCode: Self.validStatusCodes)
            .serializingDecodable(JSONAPIArrayResponse<SearchPlaylistResponse>.self)
        
        return try await task.value
    }
    
    func addPlaylist(title: String) async throws -> JSONAPIArrayResponse<SearchPlaylistResponse> {
        let url = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("own")
            .appendingPathComponent("playlist")
            .appendingPathComponent("add")
        
        var parameters: [String: String] = [
            "subscription_id": String(describing: getSubscriptionID()),
            "title": title
        ]
        
        if let userID = getUserID() {
            parameters["user_id"] = userID
        }
        
        let task = requestManager.request(url, method: .post, parameters: parameters, headers: try getAuthenticatedHeaders())
            .validate(statusCode: Self.validStatusCodes)
            .serializingDecodable(JSONAPIArrayResponse<SearchPlaylistResponse>.self)
        
        return try await task.value
    }
    
    func savePlaylist(playlistID: String, title: String) async throws -> JSONAPIArrayResponse<SearchPlaylistResponse> {
        let url = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("own")
            .appendingPathComponent("playlist")
        
        var parameters: [String: String] = [
            "subscription_id": String(describing: getSubscriptionID()),
            "title": title,
            "playlist_id": playlistID
        ]
        
        if let userID = getUserID() {
            parameters["user_id"] = userID
        }
        
        let task = requestManager.request(url, method: .put, parameters: parameters, headers: try getAuthenticatedHeaders())
            .validate(statusCode: Self.validStatusCodes)
            .serializingDecodable(JSONAPIArrayResponse<SearchPlaylistResponse>.self)
        
        return try await task.value
    }
    
    func deletePlaylist(playlistID: String) async throws -> JSONAPIArrayResponse<SearchPlaylistResponse> {
        let url = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("own")
            .appendingPathComponent("playlist")
            .appendingPathComponent("delete")
        
        var parameters: [String: String] = [
            "subscription_id": String(describing: getSubscriptionID()),
            "playlist_id": playlistID
        ]
        
        if let userID = getUserID() {
            parameters["user_id"] = userID
        }
        
        let task = requestManager.request(url, method: .post, parameters: parameters, headers: try getAuthenticatedHeaders())
            .validate(statusCode: Self.validStatusCodes)
            .serializingDecodable(JSONAPIArrayResponse<SearchPlaylistResponse>.self)
        
        return try await task.value
    }
    
    func getOwnPlaylist() async throws -> JSONAPIArrayResponse<SearchPlaylistResponse> {
        let url = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("own")
            .appendingPathComponent("playlist")
        
        var parameters: [String: String] = [:]
        
        if let userID = getUserID() {
            parameters["user_id"] = userID
        }
        
        let task = requestManager.request(url, method: .post, parameters: parameters, headers: try getAuthenticatedHeaders())
            .validate(statusCode: Self.validStatusCodes)
            .serializingDecodable(JSONAPIArrayResponse<SearchPlaylistResponse>.self)
        
        return try await task.value
    }
    
    func addSubliminalToPlaylist(playlistId: String, subliminalId: String) async throws -> JSONAPIArrayResponse<SearchPlaylistResponse> {
        let url = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("own")
            .appendingPathComponent("playlist")
            .appendingPathComponent("info")
            .appendingPathComponent("add")
        
        var parameters: [String: String] = [
            "subscription_id": String(describing: getSubscriptionID()),
            "subliminal_id": subliminalId,
            "playlist_id": playlistId
        ]
        
        if let userID = getUserID() {
            parameters["user_id"] = userID
        }
        
        let task = requestManager.request(url, method: .post, parameters: parameters, headers: try getAuthenticatedHeaders())
            .validate(statusCode: Self.validStatusCodes)
            .serializingDecodable(JSONAPIArrayResponse<SearchPlaylistResponse>.self)
        
        return try await task.value
    }
    
    func deleteSubliminalToPlaylist(playlistId: String, subliminalId: String) async throws -> JSONAPIArrayResponse<SearchPlaylistResponse> {
        let url = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("own")
            .appendingPathComponent("playlist")
            .appendingPathComponent("info")
            .appendingPathComponent("delete")
        
        var parameters: [String: String] = [
            "subscription_id": String(describing: getSubscriptionID()),
            "subliminal_id": subliminalId,
            "playlist_id": playlistId
        ]
        
        if let userID = getUserID() {
            parameters["user_id"] = userID
        }
        
        let task = requestManager.request(url, method: .post, parameters: parameters, headers: try getAuthenticatedHeaders())
            .validate(statusCode: Self.validStatusCodes)
            .serializingDecodable(JSONAPIArrayResponse<SearchPlaylistResponse>.self)
        
        return try await task.value
    }
    
    // MARK: SETTINGS
    
    func getTermsAndCondition() async throws -> JSONAPIDictionaryResponse<String> {
        let url = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("magus")
            .appendingPathComponent("terms")
        
        let task = requestManager.request(url, method: .get, headers: try getAuthenticatedHeaders())
            .validate(statusCode: Self.validStatusCodes)
            .serializingDecodable(JSONAPIDictionaryResponse<String>.self)
        
        return try await task.value
        
    }
    
    func getPrivacy() async throws -> JSONAPIDictionaryResponse<String> {
        let url = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("magus")
            .appendingPathComponent("privacy")
        
        let task = requestManager.request(url, method: .get, headers: try getAuthenticatedHeaders())
            .validate(statusCode: Self.validStatusCodes)
            .serializingDecodable(JSONAPIDictionaryResponse<String>.self)
        
        return try await task.value
        
    }
    
    func getFAQs(search: String) async throws -> JSONAPIArrayResponse<FAQsResponse> {
        let url = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("magus")
            .appendingPathComponent("faqs")
        
        let task = requestManager.request(url, method: .get, headers: try getAuthenticatedHeaders())
            .validate(statusCode: Self.validStatusCodes)
            .serializingDecodable(JSONAPIArrayResponse<FAQsResponse>.self)
        
        return try await task.value
    }
    
    func getGuides() async throws -> JSONAPIArrayResponse<GuideResponse> {
        let url = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("magus")
            .appendingPathComponent("guide")
        
        let task = requestManager.request(url, method: .get, headers: try getAuthenticatedHeaders())
            .validate(statusCode: Self.validStatusCodes)
            .serializingDecodable(JSONAPIArrayResponse<GuideResponse>.self)
        
        return try await task.value
    }
    
    func getIPO() async throws -> JSONAPIArrayResponse<IPOResponse> {
        let url = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("magus")
            .appendingPathComponent("ipo")
        
        let task = requestManager.request(url, method: .get, headers: try getAuthenticatedHeaders())
            .validate(statusCode: Self.validStatusCodes)
            .serializingDecodable(JSONAPIArrayResponse<IPOResponse>.self)
        
        return try await task.value
    }
}
