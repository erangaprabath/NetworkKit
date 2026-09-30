//
//  CacheManager.swift
//  NetworkLayer
//
//  Created by Eranga Prabath on 2026-09-26.
//

import Foundation

public final class CacheManager{
    
    private let cache:URLCache
    private let decoder:JSONDecoder
    unowned let logs:NetworkLogger
    
   public init(memoryCapacity:Int = 50 * 1024 * 1024, diskCapacity:Int = 100 * 1024 * 1024, decoder:JSONDecoder = JSONDecoder(),logs:NetworkLogger) {
        self.cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity)
        self.decoder = decoder
        self.logs = logs

    }
    
    func createCacheResponse<T:Decodable>(for request:URLRequest) throws -> T{
        guard let cached = cache.cachedResponse(for: request) else {
            throw NetworkError.invalidResponse
        }
        
        return try decoder.decode(T.self, from: cached.data)
    }
    
    func storedCache(response:URLResponse,data:Data,for request:URLRequest) {
        let cachedURLRepsonse = CachedURLResponse(response: response, data: data)
        cache.storeCachedResponse(cachedURLRepsonse, for: request)
        logs.cacheMemoryStatus(cache)
    }
    
    func removeCache(for request:URLRequest){
        cache.removeCachedResponse(for: request)
    }
    
    func removeCacheSince() {
        cache.removeCachedResponses(since: Date().addingTimeInterval(-3600))
        
    }
}
