//
//  UserInfo+Init.swift
//  Magus
//
//  Created by Jomz on 6/22/23.
//

import Foundation

extension UserInfo {
    
    init(response: UserInfoResponse) {
        id = response.id
        userID = response.userID
        cover = response.cover
        firstName = response.firstName
        lastName = response.lastName
        isUserAdmin = response.isUserAdmin
        status = response.status
        subscriptionID = response.subscriptionID
        isFirstLogin = response.isFirstLogin
        subscriptionStart = response.subscriptionStart
        subscriptionEnd = response.subscriptionEnd
        subscriptionStatus = response.subscriptionStatus
        categoryID = response.categoryID
        moodsID = response.moodsID
        coverName = response.coverName
    }
}
