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
    
    func getFavoritesPlaylist() async throws -> [Playlist] {
        do {
            let response = try await networkService.getOwnPlaylist()
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
    
    func addPlaylist(title: String) async throws -> EmptyResponse {
        do {
            let response = try await networkService.addPlaylist(title: title)
            switch response {
            case .success:
                return .init(success: true, message: "New Playlist Added.")
            case.error(let error):
                throw MessageError.message(error.message)
            }
        } catch {
            throw error
        }
    }
    
    func savePlaylist(playlistID: String, title: String) async throws -> EmptyResponse {
        do {
            let response = try await networkService.savePlaylist(playlistID: playlistID, title: title)
            switch response {
            case .success:
                return .init(success: true, message: "Updated Playlist successfully.")
            case.error(let error):
                throw MessageError.message(error.message)
            }
        } catch {
            throw MessageError.message(error.localizedDescription)
        }
    }
    
    func deletePlaylist(id: String) async throws -> EmptyResponse {
        do {
            let response = try await networkService.deletePlaylist(playlistID: id)
            switch response {
            case .success:
                return .init(success: true, message: "Deleted Playlist successfully.")
            case.error(let error):
                throw MessageError.message(error.message)
            }
        } catch {
            throw MessageError.message(error.localizedDescription)
        }
    }
    
}

