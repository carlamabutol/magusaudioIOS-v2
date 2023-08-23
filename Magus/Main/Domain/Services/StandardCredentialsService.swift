//
//  StandardCredentialsService.swift
//  Magus
//
//  Created by Jomz on 6/22/23.
//

import Foundation
import KeychainAccess

class StandardCredentialsService: AuthenticationService {
    
    private let keychain = Keychain(service: Bundle.main.bundleIdentifier!)
    
    private let cachedUserIDsKey = "CachedUserIDs"
    
    private var cachedIDs: Set<String> {
        set {
            let array = Array(newValue)
            UserDefaults.standard.set(array, forKey: cachedUserIDsKey)
        }
        
        get {
            guard let array = UserDefaults.standard.array(forKey: cachedUserIDsKey) as? [String] else { return [] }
            return Set(array)
        }
    }
    
    func tokenForID(_ id: String) -> String? {
        keychain[id]
    }
    
    func setToken(_ token: String, forID id: String) {
        keychain[id] = token
        cachedIDs.insert(id)
    }
    
    var isLoggedIn: Bool {
        !cachedIDs.isEmpty
    }
    
    func clearAuthentication() {
        cachedIDs.forEach { id in
            keychain[id] = nil
        }
        cachedIDs = []
    }
    
}
