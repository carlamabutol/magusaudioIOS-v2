//
//  CategoryUseCase.swift
//  Magus
//
//  Created by Jomz on 10/17/23.
//

import Foundation

final class CategoryUseCase {
    
    private var store: Store
    private let networkService: NetworkService
    private let credentialsService: AuthenticationService
    
    init(store: Store, networkService: NetworkService, credentialsService: AuthenticationService) {
        self.store = store
        self.networkService = networkService
        self.credentialsService = credentialsService
    }
    
    // TODO: TELL API TO ADD LIMIT
    func searchCategory(search: String = "") async throws -> [Category] {
        do {
            let response = try await networkService.getCategorySubliminal(search: search)
            switch response {
            case .success(let response):
                return response.map { Category(model: $0) }
            case .error(let error):
                Logger.warning("Search Category Failed - \(error.message)", topic: .presentation)
                throw NetworkServiceError.jsonDecodingError
            }
        } catch {
            Logger.warning("Search Category Failed - \(error.localizedDescription)", topic: .presentation)
            throw error
        }
    }
    
    func searchRecommended(search: String = "", categoryId: Int?, moodId: Int?) async throws -> SubliminalsAndPlaylist {
        do {
            let response = try await networkService.getRecommendations(search: search, categoryId: categoryId, moodId: moodId)
            switch response {
            case .success(let response):
                let playlist = response.playlist.map { Playlist(searchPlaylistResponse: $0) }
                let subliminal = response.subliminal.map { Subliminal(subliminalReponse: $0) }
                return .init(subliminal: subliminal, playlist: playlist)
            case .error(let error):
                Logger.warning("Search Recommendations Failed - \(error.message)", topic: .presentation)
                throw NetworkServiceError.jsonDecodingError
            }
        } catch {
            Logger.warning("Search Recommendations Failed - \(error.localizedDescription)", topic: .presentation)
            throw error
        }
    }
    
    func searchFeatured(search: String = "") async throws -> SubliminalsAndPlaylist {
        do {
            let response = try await networkService.getFeatured(search: search)
            switch response {
            case .success(let response):
                let playlist = response.playlist.map { Playlist(searchPlaylistResponse: $0) }
                let subliminal = response.subliminal.map { Subliminal(subliminalReponse: $0) }
                return .init(subliminal: subliminal, playlist: playlist)
            case .error(let error):
                Logger.warning("Search Featured Failed - \(error.message)", topic: .presentation)
                throw NetworkServiceError.jsonDecodingError
            }
        } catch {
            Logger.warning("Search Featured Failed - \(error.localizedDescription)", topic: .presentation)
            throw error
        }
    }
    
}

