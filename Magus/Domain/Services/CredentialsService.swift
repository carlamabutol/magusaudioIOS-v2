//
//  CredentialsService.swift
//  Magus
//
//  Created by Jomz on 6/22/23.
//

import Foundation

protocol AuthenticationService: AnyObject {
    
    func tokenForID(_ id: String) -> String?
    func setToken(_ token: String, forID id: String)
    
    var isLoggedIn: Bool { get }
    
    func clearCredentials()
}
