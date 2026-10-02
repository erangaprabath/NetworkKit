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
    private let tokenProvider:(any AuthTokenProvider)?
    
    public init(cacheManager: CacheManager, requestManager: RequestManager,tokenProvider:(any AuthTokenProvider)? = nil) {
        self.cacheManager = cacheManager
        self.requestManager = requestManager
        self.tokenProvider = tokenProvider
    }
    
    public func dataFetch<T>(_ endpoint: any EndpointsProtocol) async throws -> T where T : Decodable {
        var request = try RequestBuilder.init(endpoints: endpoint).buildURLRequest()
        
        
        
        let useCache = endpoint.httpMethod == .get && !endpoint.requiredAuth
        if useCache, let cached: T = try? cacheManager.createCacheResponse(for: request) {
            return cached
        }
        
        request = try await handleAuthorizationIsNeeded(endpoint, request)
        
        do {
            return try await requestManager.perform(from: request,check: cacheManager)
        }catch {
            throw error
        }
    }
    
    private func handleAuthorizationIsNeeded (_ endpoint:EndpointsProtocol, _ request:URLRequest)async throws -> URLRequest {
        if endpoint.requiredAuth {
            guard let header = try await tokenProvider?.authorizationHeader()else{
                throw NetworkError.unAuthorized
            }
            var request = request
            request.setValue(header.value, forHTTPHeaderField: header.key)
            return request
        }else {
            return request
        }
        
    }
}
