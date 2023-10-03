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
    func getRecommendations() async throws -> JSONAPIDictionaryResponse<RecommendationResponse>
    func getSubliminals() async throws -> JSONAPIDictionaryResponse<SubliminalArrayResponse>
    func getAllFavoriteSubliminals() async throws -> JSONAPIArrayResponse<SubliminalResponse>
    func getSubscriptions() async throws -> JSONAPIArrayResponse<SubscriptionResponse>
    func searchSubliminalAndPlaylist(search: String) async throws -> JSONAPIDictionaryResponse<SearchPlaylistAndSubliminalResponse>
    func updateUserSettings(firstName: String, lastName: String) async throws -> JSONAPIArrayResponse<UserResponse>
    func getSubliminalAudio(subliminalId: String) async throws -> ResponseArrayModel<String>
    func updateFavorite(id: String, api: FavoriteAPI, isLiked: Bool) async throws -> EmptyResponse
    
    // MARK: PLAYLIST
    func getOwnPlaylist() async throws -> JSONAPIArrayResponse<SearchPlaylistResponse>
    func addPlaylist(title: String) async throws -> JSONAPIArrayResponse<SearchPlaylistResponse>
    func savePlaylist(playlistID: String, title: String) async throws -> JSONAPIArrayResponse<SearchPlaylistResponse>
    func getAllFavoritePlaylist() async throws -> JSONAPIArrayResponse<SearchPlaylistResponse>
    func getFeaturedPlaylists() async throws -> JSONAPIDictionaryResponse<FeaturedPlaylistResponse>
}

enum FavoriteAPI: String{
    case subliminal = "subliminal"
    case playlist = "playlist"
}
