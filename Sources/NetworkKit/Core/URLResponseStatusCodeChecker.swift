//
//  CheckResponseStatus.swift
//  NetworkKit
//
//  Created by Eranga Prabath on 2026-09-26.
//

import Foundation

final class URLResponseStatusCodeChecker:Sendable{
    
    func isSuccess(_ response: HTTPURLResponse) -> Bool {
        (200...299).contains(response.statusCode)
    }
    
    func isUnauthorized(_ response: HTTPURLResponse) -> Bool {
        [401, 403].contains(response.statusCode)
    }
    
    func isClientError(_ response: HTTPURLResponse) -> Bool {
        (400...499).contains(response.statusCode)
    }
    
    func isServerError(_ response: HTTPURLResponse) -> Bool {
        (500...599).contains(response.statusCode)
    }
    
    func isRetryableStatus(_ response: HTTPURLResponse) -> Bool {
        [408, 429].contains(response.statusCode) || isServerError(response)
    }
}

