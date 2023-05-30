//
//  Configuration.swift
//  Magus
//
//  Created by Jomz on 5/30/23.
//

import Foundation

class Configuration {
    static var baseURL: URL {
        let urlString = "https://magusaudio.com"
        //        guard let urlString = "https://magusaudio.com",
        guard let baseURL = URL(string: urlString)
        else {
            fatalError("Failed to get the baseUrl")
        }
        return baseURL
    }
}
