//
//  AudioCachingManager.swift
//  Magus
//
//  Created by Jomz on 8/15/23.
//

import Foundation

class AudioCachingManager {
    static let shared = AudioCachingManager()

    private var caches: [URLCache] = []

    private init() {}

    func getCachedData(for url: URL) -> Data? {
        for cache in caches {
            if let cachedResponse = cache.cachedResponse(for: URLRequest(url: url)) {
                return cachedResponse.data
            }
        }
        return nil
    }

    func cacheData(_ data: Data, for url: URL) {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let cachedResponse = CachedURLResponse(response: response!, data: data)
        caches.forEach { cache in
            cache.storeCachedResponse(cachedResponse, for: URLRequest(url: url))
        }
    }

    func addCache() {
        let cache = URLCache(memoryCapacity: 10 * 1024 * 1024, diskCapacity: 50 * 1024 * 1024, diskPath: "audio_cache")
        caches.append(cache)
    }
}
