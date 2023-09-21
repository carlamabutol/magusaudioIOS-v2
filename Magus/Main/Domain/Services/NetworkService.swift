//
//  NetworkService.swift
//  Magus
//
//  Created by Jomz on 5/30/23.
//

import Foundation
import RxSwift

protocol NetworkService {
    func signIn(email: String, password: String) async throws -> JSONAPIDictionaryResponse<SignInResponse>
    func signUp(name: String, email: String, password: String) async throws -> JSONAPIDictionaryResponse<SignUpResponse>
    func getAllMoods() async throws -> JSONAPIArrayResponse<Mood>
    func getMoodCalendar(userId: String) async throws -> JSONAPIArrayResponse<MoodCalendarResponse>
    func updateSelectedMoods(userId: String, moodId: Int) async throws -> EmptyResponse
    func getCategorySubliminal() async throws -> JSONAPIArrayResponse<CategorySubliminalElement>
    func getFeaturedPlaylists() async throws -> JSONAPIDictionaryResponse<FeaturedPlaylistResponse>
    func getRecommendations() async throws -> JSONAPIDictionaryResponse<RecommendationResponse>
    func getSubliminals() async throws -> JSONAPIDictionaryResponse<SubliminalArrayResponse>
    func getSubscriptions() async throws -> JSONAPIArrayResponse<SubscriptionResponse>
    func searchSubliminalAndPlaylist(search: String) async throws -> JSONAPIDictionaryResponse<SearchPlaylistAndSubliminalResponse>
    func updateUserSettings(firstName: String, lastName: String) async throws -> JSONAPIArrayResponse<UserResponse>
    func getSubliminalAudio(subliminalId: String) async throws -> ResponseArrayModel<String>
    func updateFavorite(id: String, api: FavoriteAPI, isLiked: Bool) async throws -> EmptyResponse
}

enum FavoriteAPI: String{
    case subliminal = "subliminal"
    case playlist = "playlist"
    
    
}
