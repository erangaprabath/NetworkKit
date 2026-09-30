//
//  NetworkManager.swift
//  NetworkKit
//
//  Created by Eranga Prabath on 2026-09-26.
//

import Foundation

public final class NetworkKit:NetworkManagerProtocol,Sendable{

    private let cacheManager:CacheManager
    private let requestManager:RequestManager
    
   public init(cacheManager: CacheManager, requestManager: RequestManager) {
        self.cacheManager = cacheManager
        self.requestManager = requestManager
    }

   public func dataFetch<T>(_ endpoint: any EndpointsProtocol) async throws -> T where T : Decodable {
        let request = try RequestBuilder.init(endpoints: endpoint).buildURLRequest()
        if endpoint.httpMethod == .get,
            let cached: T = try? cacheManager.createCacheResponse(for: request){
            return cached
        }
        do {
            return try await requestManager.perform(from: request,check: cacheManager)
        }catch {
            throw error
        }
    }
}
