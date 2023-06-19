//
//  NetworkService.swift
//  Magus
//
//  Created by Jomz on 5/30/23.
//

import Foundation
import RxSwift

protocol NetworkService {
    func signIn(email: String, password: String) async throws -> SignInResponse
    func getAllMoods() async throws -> MoodResponse
    func updateSelectedMoods(userId: String, moodId: Int) async throws -> DefaultResponse
}
