//
//  File.swift
//  NetworkLayer
//
//  Created by Eranga Prabath on 2026-09-26.
//

import Foundation

public final class RequestManager{
    
    private let urlSession:URLSession
    private let decoder:JSONDecoder
    private let retryLimit:Int
    private var retryDelay:TimeInterval
    private let logs:NetworkLogger
    private let statusCodeCheck:CheckResponseStatus = CheckResponseStatus()
    
    public init(urlSession: URLSession = .shared, decoder: JSONDecoder = JSONDecoder(), retryLimit: Int = 3, retryDelay: TimeInterval = 3.0) {
        self.urlSession = urlSession
        self.decoder = decoder
        self.retryLimit = retryLimit
        self.retryDelay = retryDelay
        self.logs = NetworkLogger()
    }
    
    public func perform<T:Decodable>(from request:URLRequest,check cacheManager:CacheManager? = nil, by attempt:Int = 1) async throws -> T {
        
        let (data,response):(Data,URLResponse)
        
        do{
            (data,response) = try await urlSession.data(for: request)
            logs.logRequest(request)
            
        }catch let urlError as URLError{
            switch urlError.code{
                case .cancelled:
                    throw NetworkError.cancelled
                case .timedOut:
                    return try await retryEvent(from: request, check: cacheManager, by: attempt, faildWith: NetworkError.retryFailed)
                default:
                    throw NetworkError.unknown(error: urlError)
            }
        }
        
        let httpReponse = try responseCast(to: response)
        logs.logResponse(httpReponse, data: data)
        
        if try statusCodeCheck.check500StatusCode(from: httpReponse), attempt < retryLimit {
            return try await retryEvent(from: request, check: cacheManager, by: attempt, faildWith: NetworkError.invalidStatusCode(statusCode: httpReponse.statusCode))
            
        }
        
        guard try statusCodeCheck.checkUnAuthorizedStatusCode(from: httpReponse) else {
            throw NetworkError.unAuthorized
        }
        
        guard try statusCodeCheck.checkStatusCode(from: httpReponse) else {
            throw NetworkError.invalidStatusCode(statusCode: httpReponse.statusCode)
        }
        
        cacheManager?.storedCache(response: response, data: data, for: request)
        
        do {
            return try decoder.decode(T.self, from: data)
        }catch {
            throw NetworkError.decodingFailed(error)
        }
    }
    
    private func retryEvent<T:Decodable>(from request:URLRequest,check cache:CacheManager?, by attempt:Int, faildWith error:NetworkError) async throws -> T {
        if attempt < retryLimit {
            try await Task.sleep(nanoseconds: UInt64(retryDelay * 1_000_000_000))
            return try await perform(from: request, check: cache, by: attempt + 1)
        }else {
            throw error
        }
    }
    
    private func responseCast(to response:URLResponse) throws -> HTTPURLResponse {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        return httpResponse
    }
    
}
