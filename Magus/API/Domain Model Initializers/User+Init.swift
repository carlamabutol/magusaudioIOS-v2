//
//  User+Init.swift
//  Magus
//
//  Created by Jomz on 6/22/23.
//

import Foundation

extension User {
    
    init(response: UserResponse) {
        id = response.id
        userID = response.userID
        name = response.name
        email = response.email
        createdAt = response.createdAt
        info = UserInfo.init(response: response.info)
    }
}
