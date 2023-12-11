//
//  MoodCategoryUseCase.swift
//  Magus
//
//  Created by Jomz on 10/17/23.
//

import Foundation

final class MoodUseCase {
    
    private var store: Store
    private let networkService: NetworkService
    private let credentialsService: AuthenticationService
    
    init(store: Store, networkService: NetworkService, credentialsService: AuthenticationService) {
        self.store = store
        self.networkService = networkService
        self.credentialsService = credentialsService
    }
    
    // TODO: TELL API TO ADD LIMIT
    func getAllMoods() async throws -> [Mood] {
        do {
            let response = try await networkService.getAllMoods()
            switch response {
            case .success(let response):
                return response.map { Mood(moodResponse: $0) }
            case .error(_):
                throw NetworkServiceError.jsonDecodingError
            }
        } catch {
            throw error
        }
    }
    
    func getCurrentMood() async throws {
        do {
            let response = try await networkService.getCurrentMood()
            switch response {
            case .success(let data):
                let allMoods = store.appState.allMoods
                guard let currentMoodId = Int(data.first?.currentMood ?? "") else { return }
                let selectedMood = allMoods.first(where: { $0.id == currentMoodId })
                store.appState.selectedMood = selectedMood
            case .error(_):
                throw NetworkServiceError.jsonDecodingError
            }
        } catch {
            throw MessageError.message(error.localizedDescription)
        }
    }
    
    func updateSelectedMood(moodId: Int) async throws -> EmptyResponse {
        do {
            let response = try await networkService.updateSelectedMoods(moodId: moodId)
            return response
        } catch {
            throw MessageError.message(error.localizedDescription)
        }
    }
    
    func searchCategory(search: String) async throws -> [Category] {
        do {
            let response = try await networkService.getCategorySubliminal(search: "")
            switch response {
            case .success(let response):
                return response.map { Category(model: $0) }
            case .error(_):
                throw NetworkServiceError.jsonDecodingError
            }
        } catch {
            throw error
        }
    }
    
    // Ex. "2012-12"
    func getMoodCalendar(month: String) async throws -> MoodCalendar {
        do {
            let response = try await networkService.getMoodCalendar(month: month)
            switch response {
            case .success(let calendar):
                return MoodCalendar(moodCalendar: calendar)
            case .error(_):
                throw NetworkServiceError.jsonDecodingError
            }
        } catch {
            throw error
        }
    }
}
