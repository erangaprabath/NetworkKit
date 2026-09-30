//
//  RequestBuilder.swift
//  NetworkKit
//
//  Created by Eranga Prabath on 2026-09-26.
//

import Foundation

final class RequestBuilder{
    
    private let endpoints:EndpointsProtocol
    private let timeOutInterval:TimeInterval = 30
    
    init(endpoints: EndpointsProtocol) {
        self.endpoints = endpoints
    }
    
    private func buildURLComponents() throws -> URLComponents{
        guard let baseUrl = endpoints.baseURL else { throw CustomURLError.incorrectURLFormat }
        guard let urlComponets = URLComponents(string: baseUrl + endpoints.path) else {
            throw CustomURLError.badURL
        }
        return urlComponets
    }
    
    private func buildRequestWithQueryItems ( _ urlComponents:URLComponents) throws -> URLComponents {
        var urlComponentsWithQueryItems = urlComponents
        if let queryItems = endpoints.queryItems{
            urlComponentsWithQueryItems.queryItems = queryItems.map{
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }
        return urlComponentsWithQueryItems
    }
    
    private func buildURLRequestWithHeadersAndRequestMethod(_ urlComponents:URLComponents) throws -> URLRequest {
        guard let url = urlComponents.url else { throw CustomURLError.incorrectURLFormat }
        var request = URLRequest(
            url: url,
            cachePolicy: .reloadRevalidatingCacheData,
            timeoutInterval: timeOutInterval
        )
        
        request.httpMethod = endpoints.httpMethod.rawValue
        request.allHTTPHeaderFields = endpoints.header
        if endpoints.isAuthTokenRequired,
           let token = endpoints.authToken {
            request.setValue(token.value, forHTTPHeaderField: token.key)
        }
        
        if let rawBody = endpoints.rawBody {
            request.httpBody = rawBody
        }else if let body = endpoints.body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        return request
    }
    
    func buildURLRequest() throws -> URLRequest {
        let urlComponents = try buildURLComponents()
        let urlWithQueryItems = try buildRequestWithQueryItems(urlComponents)
        return try buildURLRequestWithHeadersAndRequestMethod(urlWithQueryItems)
    }
}
