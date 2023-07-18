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
    func getAllMoods() async throws -> JSONAPIArrayResponse<Mood>
    func updateSelectedMoods(userId: String, moodId: Int) async throws -> DefaultResponse
    func getCategorySubliminal() async throws -> JSONAPIArrayResponse<CategorySubliminalElement>
    func getFeaturedPlaylists() async throws -> JSONAPIArrayResponse<FeaturedPlaylistResponse>
    func getSubliminals() async throws -> JSONAPIDictionaryResponse<SubliminalResponse>
    func getSubscriptions() async throws -> JSONAPIArrayResponse<SubscriptionResponse>
    func searchSubliminalAndPlaylist(search: String) async throws -> JSONAPIDictionaryResponse<SearchPlaylistAndSubliminalResponse>
}
