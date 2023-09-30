//
//  PlaylistUseCase.swift
//  Magus
//
//  Created by Jose Mari Pascual on 9/23/23.
//

import Foundation

final class PlaylistUseCase {
    
    private var store: Store
    private let networkService: NetworkService
    private let credentialsService: AuthenticationService
    
    init(store: Store, networkService: NetworkService, credentialsService: AuthenticationService) {
        self.store = store
        self.networkService = networkService
        self.credentialsService = credentialsService
    }
    
    func searchPlaylists(search: String) async throws -> [Playlist] {
        do {
            let response = try await networkService.searchSubliminalAndPlaylist(search: search)
            switch response {
            case .success(let response):
                return response.playlist.map { Playlist(searchPlaylistResponse: $0) }
            case .error(_):
                throw NetworkServiceError.jsonDecodingError
            }
        } catch {
            throw error
        }
    }
    
    func getAllLikePlaylist() async throws -> [Playlist] {
        do {
            let response = try await networkService.getAllFavoritePlaylist()
            switch response {
            case .success(let response):
                return response.map { Playlist(searchPlaylistResponse: $0) }
            case .error(_):
                throw NetworkServiceError.jsonDecodingError
            }
        } catch {
            throw error
        }
    }
    
    func addToFavorite(id: String) async throws -> EmptyResponse {
        do {
            let response = try await networkService.updateFavorite(id: id, api: .playlist, isLiked: true)
            return response
        } catch {
            throw error
        }
    }
    
    func deleteToFavorite(id: String) async throws -> EmptyResponse {
        do {
            let response = try await networkService.updateFavorite(id: id, api: .playlist, isLiked: false)
            return response
        } catch {
            throw error
        }
    }
    
}

